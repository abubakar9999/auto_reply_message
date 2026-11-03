package com.example.auto_reply

import android.Manifest
import android.app.Notification
import android.app.PendingIntent
import android.app.Person
import android.app.RemoteInput
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.provider.ContactsContract
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import org.json.JSONObject

class VoipCallNotificationListener : NotificationListenerService() {
    data class CachedReplyAction(
        val pendingIntent: PendingIntent,
        val resultKey: String,
        val frameworkRemoteInput: RemoteInput?,
        val compatRemoteInput: androidx.core.app.RemoteInput?,
        val appSource: String,
        val callerName: String,
        val isGroup: Boolean,
        val timestamp: Long = System.currentTimeMillis()
    )

    companion object {
        private const val TAG = "BusyAutoReply_Voip"

        // Cache reply actions STRICTLY by callerKey ("$appSource:${callerName.lowercase()}") and notificationKey
        // NEVER use a generic app-wide fallback to ensure messages NEVER go to the wrong chat or group!
        private val replyActionsByCaller = mutableMapOf<String, CachedReplyAction>()
        private val replyActionsByKey = mutableMapOf<String, CachedReplyAction>()

        // Live callback to notify Flutter
        var voipCallListener: ((Map<String, Any>) -> Unit)? = null

        // Debounce map: key -> last timestamp
        private val lastHandledCalls = mutableMapOf<String, Long>()

        // Pending reply queue: if a call rings before missed call / message notification is posted,
        // we queue the message to send as soon as the caller's action becomes available.
        private val pendingRepliesByCaller = mutableMapOf<String, Pair<String, Long>>() // callerKey -> (message, timestamp)

        private var instance: VoipCallNotificationListener? = null

        fun isGroup(extras: Bundle?, sbn: StatusBarNotification?): Boolean {
            if (extras != null) {
                if (extras.getBoolean("android.isGroupConversation", false)) return true
                if (extras.getBoolean("isGroupCall", false)) return true
            }
            if (sbn != null) {
                val tag = sbn.tag ?: ""
                if (tag.contains("@g.us") || tag.contains("-group")) return true
                val shortcut = sbn.notification?.shortcutId ?: ""
                if (shortcut.contains("@g.us")) return true
                val groupKey = sbn.notification?.group ?: ""
                if (groupKey.contains("@g.us") || groupKey.contains("group_key_messages")) {
                    val title = extras?.getString(Notification.EXTRA_TITLE) ?: ""
                    if (title.equals("WhatsApp", ignoreCase = true)) return true
                }
            }
            return false
        }

        fun matchesCaller(chatTitle: String?, targetCaller: String?): Boolean {
            if (chatTitle.isNullOrEmpty() || targetCaller.isNullOrEmpty()) return false
            val c1 = chatTitle.trim().lowercase()
            val c2 = targetCaller.trim().lowercase()

            if (c1 == c2) return true
            if (c1.contains(c2) || c2.contains(c1)) return true

            // Ignore titles and common suffixes
            val ignored = setOf("bhai", "vai", "vhai", "bro", "apu", "dada", "dr", "engr", "md", "mr", "mrs", "sir", "kaka", "caci", "mama", "coto")
            val tokens1 = c1.split(Regex("\\s+")).filter { it.length >= 2 && it !in ignored }
            val tokens2 = c2.split(Regex("\\s+")).filter { it.length >= 2 && it !in ignored }

            if (tokens1.isEmpty() || tokens2.isEmpty()) return false
            val intersection = tokens1.intersect(tokens2.toSet())
            return intersection.size >= 2 || (tokens1.size == 1 && intersection.isNotEmpty())
        }

        private val SUMMARY_CALL_REGEX = Regex("""^(\d+\s+)?missed\s+(voice|video)?\s*calls?""", RegexOption.IGNORE_CASE)
        private val BANGLA_SUMMARY_REGEX = Regex("""(\d+\s+)?মিসড\s*(ভয়েস|ভিডিও)?\s*কল""", RegexOption.IGNORE_CASE)

        fun isSummaryMissedCall(title: String?): Boolean {
            if (title.isNullOrBlank()) return false
            val t = title.trim()
            return SUMMARY_CALL_REGEX.containsMatchIn(t) || BANGLA_SUMMARY_REGEX.containsMatchIn(t)
        }

        fun extractCallerName(title: String, text: String, bigText: String): String {
            val t = title.trim()
            val txt = text.trim()
            val bTxt = bigText.trim()

            if (isSummaryMissedCall(t)) {
                // In summary notifications like "3 missed voice calls", WhatsApp puts caller names in bigText or text:
                // e.g. "Eon Tarun Datta Vhai, eon Roman Dewan bhai"
                val rawCandidates = if (bTxt.isNotEmpty()) bTxt else txt
                val names = rawCandidates.split(",").map { it.trim() }.filter { it.isNotEmpty() }
                val best = names.firstOrNull { candidate ->
                    !isSummaryMissedCall(candidate) &&
                    !candidate.contains("missed call", ignoreCase = true) &&
                    !candidate.contains("voice call", ignoreCase = true) &&
                    !candidate.contains("video call", ignoreCase = true)
                } ?: ""
                return best
            }

            if (t.equals("WhatsApp", ignoreCase = true) || t.equals("Messenger", ignoreCase = true)) {
                return txt.split(":").firstOrNull()?.trim() ?: ""
            }

            return t
        }

        fun registerReplyAction(
            notificationKey: String,
            appSource: String,
            callerName: String,
            isGroup: Boolean,
            pendingIntent: PendingIntent,
            resultKey: String,
            frameworkRemoteInput: RemoteInput?,
            compatRemoteInput: androidx.core.app.RemoteInput?
        ) {
            // NEVER register group notifications as reply actions for 1-on-1 calls
            if (isGroup) {
                Log.d(TAG, "Ignoring group reply action for $callerName")
                return
            }

            val action = CachedReplyAction(
                pendingIntent = pendingIntent,
                resultKey = resultKey,
                frameworkRemoteInput = frameworkRemoteInput,
                compatRemoteInput = compatRemoteInput,
                appSource = appSource,
                callerName = callerName,
                isGroup = isGroup
            )
            replyActionsByKey[notificationKey] = action
            if (callerName.isNotEmpty()) {
                val callerKey = "$appSource:${callerName.lowercase()}"
                replyActionsByCaller[callerKey] = action
                Log.d(TAG, "Registered direct reply action STRICTLY for caller: $callerKey, resultKey: $resultKey")

                // Check if there was a pending reply waiting for this caller
                val pending = pendingRepliesByCaller[callerKey]
                if (pending != null) {
                    val (pendingMsg, timestamp) = pending
                    if (System.currentTimeMillis() - timestamp < 30000L) {
                        Log.d(TAG, "Found pending reply for $callerKey! Dispatching now...")
                        pendingRepliesByCaller.remove(callerKey)
                        sendDirectReply(
                            notificationKey = notificationKey,
                            appSource = appSource,
                            callerName = callerName,
                            message = pendingMsg
                        )
                    } else {
                        pendingRepliesByCaller.remove(callerKey)
                    }
                }
            }
        }

        fun sendDirectReply(
            notificationKey: String? = null,
            appSource: String? = null,
            callerName: String? = null,
            message: String
        ): Boolean {
            Log.d(TAG, "Executing sendDirectReply: key=$notificationKey, app=$appSource, caller=$callerName")

            if (appSource.isNullOrEmpty() || callerName.isNullOrEmpty()) {
                Log.w(TAG, "Cannot send direct reply: appSource or callerName is empty")
                return false
            }

            val callerKey = "$appSource:${callerName.lowercase()}"

            // 1. Try finding action cached strictly for this caller
            var action: CachedReplyAction? = replyActionsByCaller[callerKey]

            // 2. Try notificationKey only if its caller matches
            if (action == null && !notificationKey.isNullOrEmpty()) {
                val cached = replyActionsByKey[notificationKey]
                if (cached != null && matchesCaller(cached.callerName, callerName)) {
                    action = cached
                }
            }

            // 3. If not found in cache, scan active status bar notifications specifically for this caller
            if (action == null && instance != null) {
                try {
                    val activeSbns = instance?.activeNotifications
                    if (activeSbns != null) {
                        for (sbn in activeSbns) {
                            val pkg = sbn.packageName
                            val isTargetApp = (appSource == "whatsapp" && (pkg == "com.whatsapp" || pkg == "com.whatsapp.w4b")) ||
                                    (appSource == "messenger" && (pkg == "com.facebook.orca" || pkg == "com.facebook.mlite"))
                            if (!isTargetApp) continue

                            val notif = sbn.notification ?: continue
                            val extras = notif.extras ?: continue
                            if (isGroup(extras, sbn)) continue

                            val title = extras.getString(Notification.EXTRA_TITLE) ?: ""
                            if (matchesCaller(title, callerName)) {
                                Log.d(TAG, "Found active notification matching caller '$callerName': ${sbn.key}")
                                instance?.extractAndCacheReplyActions(sbn.key, notif, appSource, callerName, isGroup = false)
                                action = replyActionsByCaller[callerKey]
                                if (action != null) break
                            }
                        }
                    }
                } catch (e: Exception) {
                    Log.w(TAG, "Error scanning active notifications for $callerName", e)
                }
            }

            if (action == null) {
                Log.w(TAG, "No verified direct reply action found for caller '$callerName'. Queuing pending reply in case missed-call notification arrives...")
                pendingRepliesByCaller[callerKey] = Pair(message, System.currentTimeMillis())
                return false
            }

            // Final sanity check: ensure target is NOT a group
            if (action.isGroup || action.callerName.contains("group", ignoreCase = true) || action.callerName.contains("brothers", ignoreCase = true)) {
                Log.e(TAG, "CRITICAL REJECTION: Action target '${action.callerName}' was identified as a group! Aborting send to prevent group spam.")
                return false
            }

            return try {
                val context = MainApplication.appContext
                val fillInIntent = Intent().apply {
                    addFlags(Intent.FLAG_RECEIVER_FOREGROUND)
                }

                val resultsBundle = Bundle().apply {
                    putCharSequence(action.resultKey, message)
                    putCharSequence("key_text_reply", message)
                    putCharSequence("android.intent.extra.TEXT", message)
                }

                // 1. Android standard RemoteInput
                if (action.frameworkRemoteInput != null) {
                    RemoteInput.addResultsToIntent(
                        arrayOf(action.frameworkRemoteInput),
                        fillInIntent,
                        resultsBundle
                    )
                }

                // 2. AndroidX compat RemoteInput (essential for WhatsApp/Messenger)
                val compatRi = action.compatRemoteInput
                    ?: androidx.core.app.RemoteInput.Builder(action.resultKey).build()
                androidx.core.app.RemoteInput.addResultsToIntent(
                    arrayOf(compatRi),
                    fillInIntent,
                    resultsBundle
                )

                // Dispatch PendingIntent using Application Context
                action.pendingIntent.send(context, 0, fillInIntent)
                Log.d(TAG, "Direct reply SUCCESS: dispatched via ${action.appSource} directly to caller '${action.callerName}' (NOT a group)!")
                true
            } catch (e: Exception) {
                Log.e(TAG, "Failed to send direct reply via PendingIntent", e)
                false
            }
        }
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
    }

    override fun onDestroy() {
        if (instance == this) instance = null
        super.onDestroy()
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        super.onNotificationPosted(sbn)
        if (sbn == null) return

        val pkg = sbn.packageName ?: return
        val appSource = when {
            pkg == "com.whatsapp" || pkg == "com.whatsapp.w4b" -> "whatsapp"
            pkg == "com.facebook.orca" || pkg == "com.facebook.mlite" -> "messenger"
            pkg.startsWith("org.telegram") -> "telegram"
            else -> return
        }

        val notification = sbn.notification ?: return
        val extras = notification.extras ?: return

        val title = extras.getString(Notification.EXTRA_TITLE) ?: ""
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString() ?: ""
        val subText = extras.getCharSequence(Notification.EXTRA_SUB_TEXT)?.toString() ?: ""
        val bigText = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString() ?: ""
        val fullContent = "$title $text $subText $bigText".lowercase()
        val callerName = extractCallerName(title, text, bigText)

        val isGroupNotification = isGroup(extras, sbn)

        // 1. Extract and cache any available direct reply actions strictly for this caller (skip groups)
        val hasReplyInThisNotification = if (!isGroupNotification && callerName.isNotEmpty()) {
            extractAndCacheReplyActions(sbn.key, notification, appSource, callerName, isGroup = false)
        } else {
            false
        }

        // 2. Check if notification represents a voice or video call (incoming or missed)
        val isCallCategory = notification.category == Notification.CATEGORY_CALL ||
                notification.category == Notification.CATEGORY_MISSED_CALL
        val callKeywords = listOf(
            "incoming call", "incoming voice call", "incoming video call",
            "missed call", "missed voice call", "missed video call",
            "voice call", "video call", "ringing",
            "ইনকামিং কল", "মিসড কল", "কল আসছে"
        )
        val matchesKeywords = callKeywords.any { fullContent.contains(it) }

        if (!isCallCategory && !matchesKeywords) {
            return
        }

        if (callerName.isEmpty() || isGroupNotification || isSummaryMissedCall(callerName)) {
            Log.d(TAG, "Skipping VoIP notification: callerName='$callerName', isGroup=$isGroupNotification, title='$title'")
            return
        }

        // Debounce duplicate notifications for the same ongoing call (within 12 seconds)
        val debounceKey = "$appSource:$callerName"
        val now = System.currentTimeMillis()
        val lastTime = lastHandledCalls[debounceKey] ?: 0L
        if (now - lastTime < 12000L) {
            return
        }
        lastHandledCalls[debounceKey] = now

        Log.d(TAG, "Detected VoIP call from $appSource: $callerName (isGroup=$isGroupNotification)")

        val callerKey = "$appSource:${callerName.lowercase()}"
        val hasDirectReply = hasReplyInThisNotification || replyActionsByCaller.containsKey(callerKey)

        // Resolve phone number from notification extras or Android Contacts Contract
        var resolvedPhoneNumber = extractPhoneNumberFromExtras(extras)
        if (resolvedPhoneNumber.isNullOrEmpty()) {
            resolvedPhoneNumber = findPhoneNumberByContactName(this, callerName)
        }

        Log.d(TAG, "VoIP call summary: app=$appSource, caller='$callerName', hasDirectReply=$hasDirectReply, phone=$resolvedPhoneNumber")

        val eventData = mapOf(
            "source" to appSource,
            "callerName" to callerName,
            "notificationKey" to sbn.key,
            "hasDirectReply" to hasDirectReply,
            "phoneNumber" to (resolvedPhoneNumber ?: ""),
            "timestamp" to now
        )

        // 1. Notify live listener in Flutter EventChannel if active
        voipCallListener?.invoke(eventData)
        NativeBridge.notifyVoipCall(eventData)

        // 2. Pipe directly to FlutterBackgroundService background isolate
        try {
            val json = JSONObject().apply {
                put("method", "voip_call")
                put("args", JSONObject(eventData))
            }
            id.flutter.flutter_background_service.FlutterBackgroundServicePlugin.servicePipe.invoke(json)
            id.flutter.flutter_background_service.FlutterBackgroundServicePlugin.mainPipe.invoke(json)
        } catch (e: Exception) {
            Log.e(TAG, "Error piping VoIP call to background service", e)
        }

        // 3. Send broadcast intent
        val localIntent = Intent("com.example.auto_reply.VOIP_CALL").apply {
            putExtra("source", appSource)
            putExtra("callerName", callerName)
            putExtra("notificationKey", sbn.key)
            putExtra("hasDirectReply", hasDirectReply)
            putExtra("phoneNumber", resolvedPhoneNumber)
            putExtra("timestamp", now)
            setPackage(packageName)
        }
        sendBroadcast(localIntent)
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification?) {
        super.onNotificationRemoved(sbn)
        // Note: Retain caller actions so PendingIntents remain valid for auto-replying.
    }

    private fun extractAndCacheReplyActions(
        notificationKey: String,
        notification: Notification,
        appSource: String,
        callerName: String,
        isGroup: Boolean
    ): Boolean {
        if (isGroup || callerName.isEmpty()) return false
        var found = false

        // A. Standard actions (look for RemoteInput or "Message" action)
        notification.actions?.forEach { action ->
            val pendingIntent = action.actionIntent ?: return@forEach
            val actionTitle = (action.title ?: "").toString().lowercase()

            action.remoteInputs?.forEach { ri ->
                registerReplyAction(
                    notificationKey = notificationKey,
                    appSource = appSource,
                    callerName = callerName,
                    isGroup = false,
                    pendingIntent = pendingIntent,
                    resultKey = ri.resultKey,
                    frameworkRemoteInput = ri,
                    compatRemoteInput = null
                )
                found = true
            }

            // WhatsApp Missed Call: Action "Message" startService PendingIntent
            if (!found && (actionTitle.contains("message") || actionTitle.contains("reply") || actionTitle.contains("বার্তা"))) {
                val fwRemoteInput = RemoteInput.Builder("key_text_reply")
                    .setLabel("Reply")
                    .build()
                registerReplyAction(
                    notificationKey = notificationKey,
                    appSource = appSource,
                    callerName = callerName,
                    isGroup = false,
                    pendingIntent = pendingIntent,
                    resultKey = "key_text_reply",
                    frameworkRemoteInput = fwRemoteInput,
                    compatRemoteInput = null
                )
                found = true
            }
        }

        // B. Wearable Extender actions (contains RemoteInput for WhatsApp missed calls / messages)
        if (!found) {
            try {
                val wearableExtender = NotificationCompat.WearableExtender(notification)
                for (action in wearableExtender.actions) {
                    val pendingIntent = action.actionIntent ?: continue
                    val remoteInputs = action.remoteInputs
                    if (remoteInputs != null && remoteInputs.isNotEmpty()) {
                        for (ri in remoteInputs) {
                            val fwRemoteInput = RemoteInput.Builder(ri.resultKey)
                                .setLabel(ri.label)
                                .setChoices(ri.choices)
                                .setAllowFreeFormInput(ri.allowFreeFormInput)
                                .addExtras(ri.extras)
                                .build()

                            registerReplyAction(
                                notificationKey = notificationKey,
                                appSource = appSource,
                                callerName = callerName,
                                isGroup = false,
                                pendingIntent = pendingIntent,
                                resultKey = ri.resultKey,
                                frameworkRemoteInput = fwRemoteInput,
                                compatRemoteInput = ri
                            )
                            found = true
                            break
                        }
                    }
                    if (found) break
                }
            } catch (e: Exception) {
                Log.w(TAG, "Error checking wearable actions", e)
            }
        }

        // C. Invisible actions (NotificationCompat)
        if (!found) {
            try {
                val invisibleActions = NotificationCompat.getInvisibleActions(notification)
                for (action in invisibleActions) {
                    val pendingIntent = action.actionIntent ?: continue
                    val remoteInputs = action.remoteInputs
                    if (remoteInputs != null && remoteInputs.isNotEmpty()) {
                        for (ri in remoteInputs) {
                            val fwRemoteInput = RemoteInput.Builder(ri.resultKey)
                                .setLabel(ri.label)
                                .setChoices(ri.choices)
                                .setAllowFreeFormInput(ri.allowFreeFormInput)
                                .addExtras(ri.extras)
                                .build()

                            registerReplyAction(
                                notificationKey = notificationKey,
                                appSource = appSource,
                                callerName = callerName,
                                isGroup = false,
                                pendingIntent = pendingIntent,
                                resultKey = ri.resultKey,
                                frameworkRemoteInput = fwRemoteInput,
                                compatRemoteInput = ri
                            )
                            found = true
                            break
                        }
                    }
                    if (found) break
                }
            } catch (e: Exception) {
                Log.w(TAG, "Error checking invisible actions", e)
            }
        }

        return found
    }

    private fun extractPhoneNumberFromExtras(extras: Bundle): String? {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                val peopleList = extras.getParcelableArrayList<Person>(Notification.EXTRA_PEOPLE_LIST)
                if (peopleList != null) {
                    for (person in peopleList) {
                        val uri = person.uri
                        if (!uri.isNullOrEmpty() && uri.startsWith("tel:")) {
                            val raw = uri.substringAfter("tel:").trim()
                            if (!raw.contains("*") && !raw.contains("#") && raw.length >= 8) {
                                return raw
                            }
                        }
                        val key = person.key
                        if (!key.isNullOrEmpty()) {
                            val candidate = key.substringBefore("@").filter { it.isDigit() || it == '+' }
                            if (!candidate.contains("*") && !candidate.contains("#") && candidate.length >= 8) {
                                return candidate
                            }
                        }
                    }
                }
            }

            @Suppress("DEPRECATION")
            val peopleArray = extras.getStringArray(Notification.EXTRA_PEOPLE)
            if (peopleArray != null) {
                for (personStr in peopleArray) {
                    if (personStr.startsWith("tel:")) {
                        val raw = personStr.substringAfter("tel:").trim()
                        if (!raw.contains("*") && !raw.contains("#") && raw.length >= 8) {
                            return raw
                        }
                    }
                }
            }
            null
        } catch (e: Exception) {
            null
        }
    }

    private fun findPhoneNumberByContactName(context: Context, contactName: String): String? {
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.READ_CONTACTS)
            != PackageManager.PERMISSION_GRANTED) {
            return null
        }

        return try {
            val cleanName = contactName.trim()
            if (cleanName.isEmpty()) return null

            val ignoredTokens = setOf("bhai", "vai", "vhai", "bro", "apu", "dada", "dr", "engr", "md", "mr", "mrs", "miss", "sir", "kaka", "caci", "mama", "coto")
            val tokens = cleanName.split(Regex("\\s+"))
                .map { it.lowercase() }
                .filter { it.length >= 2 && it !in ignoredTokens }

            val cr = context.contentResolver

            // 1. Search standard phone contacts
            val cursor = cr.query(
                ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
                arrayOf(
                    ContactsContract.CommonDataKinds.Phone.NUMBER,
                    ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME
                ),
                null,
                null,
                null
            )

            var bestMatch: String? = null
            var highestScore = 0

            cursor?.use {
                val numIdx = it.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER)
                val nameIdx = it.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME)
                if (numIdx != -1 && nameIdx != -1) {
                    while (it.moveToNext()) {
                        val rawNumber = it.getString(numIdx) ?: continue
                        val displayName = it.getString(nameIdx)?.lowercase() ?: continue

                        // Strictly reject USSD and service codes
                        if (rawNumber.contains("*") || rawNumber.contains("#")) continue
                        val digits = rawNumber.filter { d -> d.isDigit() || d == '+' }
                        if (digits.length < 8) continue

                        // 1. Exact match (case-insensitive)
                        if (displayName == cleanName.lowercase()) {
                            return rawNumber
                        }

                        // 2. Substring match
                        if (displayName.contains(cleanName.lowercase()) || cleanName.lowercase().contains(displayName)) {
                            return rawNumber
                        }

                        // 3. Token match
                        var score = 0
                        for (token in tokens) {
                            if (displayName.contains(token)) {
                                score++
                            }
                        }

                        // Only accept token matches with score >= 2
                        if (score > highestScore && score >= 2) {
                            highestScore = score
                            bestMatch = rawNumber
                        }
                    }
                }
            }

            if (bestMatch != null) return bestMatch

            // 2. Query WhatsApp RawContacts (sync1 stores international phone number, e.g. 88017...@s.whatsapp.net)
            try {
                val rawCursor = cr.query(
                    ContactsContract.RawContacts.CONTENT_URI,
                    arrayOf(
                        ContactsContract.RawContacts.DISPLAY_NAME_PRIMARY,
                        ContactsContract.RawContacts.SYNC1,
                        ContactsContract.RawContacts.ACCOUNT_TYPE
                    ),
                    "${ContactsContract.RawContacts.ACCOUNT_TYPE} = 'com.whatsapp'",
                    null,
                    null
                )
                rawCursor?.use { rc ->
                    val nameCol = rc.getColumnIndex(ContactsContract.RawContacts.DISPLAY_NAME_PRIMARY)
                    val syncCol = rc.getColumnIndex(ContactsContract.RawContacts.SYNC1)
                    if (nameCol != -1 && syncCol != -1) {
                        while (rc.moveToNext()) {
                            val dispName = rc.getString(nameCol) ?: continue
                            val sync1 = rc.getString(syncCol) ?: continue
                            if (sync1.contains("@")) {
                                val candidate = sync1.substringBefore("@").filter { d -> d.isDigit() || d == '+' }
                                if (candidate.length >= 8 && matchesCaller(dispName, cleanName)) {
                                    val formatted = if (candidate.startsWith("+")) candidate else "+$candidate"
                                    Log.d(TAG, "Resolved WhatsApp RawContacts phone for '$cleanName': $formatted (sync1=$sync1, disp=$dispName)")
                                    return formatted
                                }
                            }
                        }
                    }
                }
            } catch (e: Exception) {
                Log.w(TAG, "Error querying WhatsApp RawContacts for $cleanName", e)
            }

            null
        } catch (e: Exception) {
            Log.e(TAG, "Failed to query native contacts for $contactName", e)
            null
        }
    }
}

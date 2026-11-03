package com.example.auto_reply

import android.Manifest
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Handler
import android.os.Looper
import android.provider.CallLog
import android.telephony.TelephonyManager
import android.util.Log
import androidx.core.content.ContextCompat
import org.json.JSONObject

class PhoneCallReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "BusyAutoReply_Receiver"
        var callListener: ((String) -> Unit)? = null
        private var lastProcessedNumber: String? = null
        private var lastProcessedTime: Long = 0L

        /**
         * Fallback for Android 10+ where EXTRA_INCOMING_NUMBER may be null
         * in the broadcast Intent even if permissions are granted.
         */
        fun queryLatestCallLogNumber(context: Context): String? {
            if (ContextCompat.checkSelfPermission(context, Manifest.permission.READ_CALL_LOG)
                != PackageManager.PERMISSION_GRANTED) {
                return null
            }
            return try {
                val cursor = context.contentResolver.query(
                    CallLog.Calls.CONTENT_URI,
                    arrayOf(CallLog.Calls.NUMBER, CallLog.Calls.DATE, CallLog.Calls.TYPE),
                    null,
                    null,
                    "${CallLog.Calls.DATE} DESC"
                )
                cursor?.use {
                    if (it.moveToFirst()) {
                        val numIndex = it.getColumnIndex(CallLog.Calls.NUMBER)
                        val dateIndex = it.getColumnIndex(CallLog.Calls.DATE)
                        if (numIndex != -1 && dateIndex != -1) {
                            val date = it.getLong(dateIndex)
                            // If the log was created within the last 15 seconds
                            if (System.currentTimeMillis() - date < 15000L) {
                                return it.getString(numIndex)
                            }
                        }
                    }
                }
                null
            } catch (e: Exception) {
                Log.e(TAG, "Failed to query CallLog fallback", e)
                null
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != TelephonyManager.ACTION_PHONE_STATE_CHANGED) {
            return
        }

        val stateStr = intent.getStringExtra(TelephonyManager.EXTRA_STATE) ?: return
        Log.d(TAG, "Phone State Changed: $stateStr")

        if (stateStr == TelephonyManager.EXTRA_STATE_RINGING) {
            @Suppress("DEPRECATION")
            var incomingNumber = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)
            Log.d(TAG, "Incoming ringing extra number: $incomingNumber")

            if (incomingNumber.isNullOrEmpty()) {
                // Try immediate fallback to CallLog
                incomingNumber = queryLatestCallLogNumber(context)
                Log.d(TAG, "Fallback CallLog resolved number: $incomingNumber")
            }

            if (!incomingNumber.isNullOrEmpty()) {
                dispatchIncomingCall(context, incomingNumber)
            } else {
                // If number is still null (Android delayed writing CallLog), check again after 1.5 seconds
                Handler(Looper.getMainLooper()).postDelayed({
                    val delayedNumber = queryLatestCallLogNumber(context)
                    if (!delayedNumber.isNullOrEmpty()) {
                        Log.d(TAG, "Delayed CallLog resolved number: $delayedNumber")
                        dispatchIncomingCall(context, delayedNumber)
                    }
                }, 1500L)
            }
        }
    }

    private fun dispatchIncomingCall(context: Context, incomingNumber: String) {
        val now = System.currentTimeMillis()
        if (incomingNumber == lastProcessedNumber && (now - lastProcessedTime < 8000L)) {
            Log.d(TAG, "Debounced duplicate ringing for: $incomingNumber")
            return
        }
        lastProcessedNumber = incomingNumber
        lastProcessedTime = now

        Log.d(TAG, "Dispatching cellular call: $incomingNumber")

        // 1. Store in SharedPreferences for reliable cross-process retrieval
        val prefs = context.getSharedPreferences("BusyAutoReplyPrefs", Context.MODE_PRIVATE)
        prefs.edit()
            .putString("last_incoming_number", incomingNumber)
            .putLong("last_incoming_time", now)
            .apply()

        // 2. Notify EventChannel in NativeBridge
        callListener?.invoke(incomingNumber)
        NativeBridge.notifyPhoneCall(incomingNumber)

        // 3. Pipe directly into FlutterBackgroundService isolate
        try {
            val json = JSONObject().apply {
                put("method", "phone_call")
                put("args", JSONObject(mapOf(
                    "phoneNumber" to incomingNumber,
                    "timestamp" to now
                )))
            }
            id.flutter.flutter_background_service.FlutterBackgroundServicePlugin.servicePipe.invoke(json)
            id.flutter.flutter_background_service.FlutterBackgroundServicePlugin.mainPipe.invoke(json)
        } catch (e: Exception) {
            Log.e(TAG, "Error piping phone call to background service", e)
        }

        // 4. Send local broadcast intent
        val localIntent = Intent("com.example.auto_reply.INCOMING_CALL").apply {
            putExtra("incoming_number", incomingNumber)
            putExtra("timestamp", now)
            setPackage(context.packageName)
        }
        context.sendBroadcast(localIntent)
    }
}

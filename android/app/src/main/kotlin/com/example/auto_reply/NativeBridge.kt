package com.example.auto_reply

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

object NativeBridge {
    const val METHOD_CHANNEL = "com.example.auto_reply/native"
    const val CALL_EVENT_CHANNEL = "com.example.auto_reply/call_events"
    const val VOIP_EVENT_CHANNEL = "com.example.auto_reply/voip_events"

    private val mainHandler = Handler(Looper.getMainLooper())
    private var callEventSink: EventChannel.EventSink? = null
    private var voipEventSink: EventChannel.EventSink? = null

    @JvmStatic
    fun registerWith(flutterEngine: FlutterEngine, context: Context) {
        val messenger = flutterEngine.dartExecutor.binaryMessenger

        MethodChannel(messenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "sendSms" -> {
                    val phoneNumber = call.argument<String>("phoneNumber")
                    val message = call.argument<String>("message")

                    if (phoneNumber.isNullOrEmpty() || message.isNullOrEmpty()) {
                        result.error("INVALID_ARGUMENTS", "Phone number and message must not be empty", null)
                        return@setMethodCallHandler
                    }

                    val (success, errorMsg) = SmsHelper.sendSms(context, phoneNumber, message)
                    result.success(mapOf("success" to success, "error" to errorMsg))
                }
                "sendVoipDirectReply" -> {
                    val notificationKey = call.argument<String>("notificationKey")
                    val source = call.argument<String>("source")
                    val callerName = call.argument<String>("callerName")
                    val message = call.argument<String>("message")
                    if (message.isNullOrEmpty()) {
                        result.success(mapOf("success" to false, "error" to "Message must not be empty"))
                        return@setMethodCallHandler
                    }

                    val sent = VoipCallNotificationListener.sendDirectReply(
                        notificationKey = notificationKey,
                        appSource = source,
                        callerName = callerName,
                        message = message
                    )
                    result.success(mapOf("success" to sent))
                }
                "isNotificationListenerGranted" -> {
                    val enabledPackages = NotificationManagerCompat.getEnabledListenerPackages(context)
                    val isGranted = enabledPackages.contains(context.packageName)
                    result.success(isGranted)
                }
                "requestNotificationListenerPermission" -> {
                    try {
                        val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS).apply {
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }
                        context.startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("INTENT_ERROR", e.localizedMessage, null)
                    }
                }
                "isBatteryOptimizationIgnored" -> {
                    val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
                    val isIgnored = powerManager.isIgnoringBatteryOptimizations(context.packageName)
                    result.success(isIgnored)
                }
                "requestIgnoreBatteryOptimizations" -> {
                    try {
                        val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                            data = Uri.parse("package:${context.packageName}")
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }
                        context.startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("INTENT_ERROR", e.localizedMessage, null)
                    }
                }
                "getLastIncomingCall" -> {
                    val prefs = context.getSharedPreferences("BusyAutoReplyPrefs", Context.MODE_PRIVATE)
                    val number = prefs.getString("last_incoming_number", null)
                    val timestamp = prefs.getLong("last_incoming_time", 0L)
                    result.success(mapOf(
                        "number" to number,
                        "timestamp" to timestamp
                    ))
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Cellular call events channel
        EventChannel(messenger, CALL_EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    callEventSink = events
                    PhoneCallReceiver.callListener = { incomingNumber ->
                        mainHandler.post {
                            callEventSink?.success(mapOf(
                                "phoneNumber" to incomingNumber,
                                "timestamp" to System.currentTimeMillis()
                            ))
                        }
                    }
                }

                override fun onCancel(arguments: Any?) {
                    callEventSink = null
                    PhoneCallReceiver.callListener = null
                }
            }
        )

        // VoIP (WhatsApp / Messenger / Telegram) events channel
        EventChannel(messenger, VOIP_EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    voipEventSink = events
                    VoipCallNotificationListener.voipCallListener = { eventData ->
                        mainHandler.post {
                            voipEventSink?.success(eventData)
                        }
                    }
                }

                override fun onCancel(arguments: Any?) {
                    voipEventSink = null
                    VoipCallNotificationListener.voipCallListener = null
                }
            }
        )
    }

    fun notifyVoipCall(eventData: Map<String, Any>) {
        mainHandler.post {
            voipEventSink?.success(eventData)
        }
    }

    fun notifyPhoneCall(incomingNumber: String) {
        mainHandler.post {
            callEventSink?.success(mapOf(
                "phoneNumber" to incomingNumber,
                "timestamp" to System.currentTimeMillis()
            ))
        }
    }
}

package com.example.auto_reply

import android.content.Context
import android.util.Log
import id.flutter.flutter_background_service.FlutterBackgroundServicePlugin
import io.flutter.app.FlutterApplication
import org.json.JSONObject

class MainApplication : FlutterApplication() {
    companion object {
        private const val TAG = "BusyAutoReply_App"
        lateinit var appContext: Context
            private set
    }

    override fun onCreate() {
        super.onCreate()
        appContext = applicationContext

        // Listen for requests piped from background Flutter isolate
        FlutterBackgroundServicePlugin.mainPipe.addListener { json ->
            try {
                val method = json.optString("method")
                val args = json.optJSONObject("args")
                Log.d(TAG, "mainPipe received: method=$method, args=$args")

                when (method) {
                    "send_sms" -> {
                        if (args != null) {
                            val requestId = args.optString("requestId")
                            val phoneNumber = args.optString("phoneNumber")
                            val message = args.optString("message")

                            val (success, errorMsg) = SmsHelper.sendSms(applicationContext, phoneNumber, message)
                            Log.d(TAG, "SmsHelper send result to $phoneNumber: success=$success, error=$errorMsg")

                            val reply = JSONObject().apply {
                                put("method", "sms_result")
                                put("args", JSONObject(mapOf(
                                    "requestId" to requestId,
                                    "success" to success,
                                    "error" to (errorMsg ?: ""),
                                    "phoneNumber" to phoneNumber
                                )))
                            }
                            FlutterBackgroundServicePlugin.servicePipe.invoke(reply)
                        }
                    }
                    "send_voip_direct_reply" -> {
                        if (args != null) {
                            val requestId = args.optString("requestId")
                            val notificationKey = args.optString("notificationKey")
                            val source = args.optString("source")
                            val callerName = args.optString("callerName")
                            val message = args.optString("message")

                            val sent = VoipCallNotificationListener.sendDirectReply(
                                notificationKey = notificationKey,
                                appSource = source,
                                callerName = callerName,
                                message = message
                            )
                            Log.d(TAG, "sendDirectReply for app=$source, caller=$callerName: $sent")

                            val reply = JSONObject().apply {
                                put("method", "voip_direct_result")
                                put("args", JSONObject(mapOf(
                                    "requestId" to requestId,
                                    "success" to sent
                                )))
                            }
                            FlutterBackgroundServicePlugin.servicePipe.invoke(reply)
                        }
                    }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error processing mainPipe event", e)
            }
        }
    }
}



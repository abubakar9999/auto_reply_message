package com.example.auto_reply

import android.content.Context
import android.os.Build
import android.telephony.SmsManager
import android.util.Log

object SmsHelper {
    private const val TAG = "BusyAutoReply_Sms"

    fun sendSms(context: Context, phoneNumber: String, message: String): Pair<Boolean, String?> {
        return try {
            val cleanNumber = phoneNumber.trim()
            if (cleanNumber.isEmpty()) {
                return Pair(false, "Phone number is empty")
            }

            val smsManager: SmsManager = try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    context.getSystemService(SmsManager::class.java) ?: @Suppress("DEPRECATION") SmsManager.getDefault()
                } else {
                    @Suppress("DEPRECATION")
                    SmsManager.getDefault()
                }
            } catch (e: Exception) {
                @Suppress("DEPRECATION")
                SmsManager.getDefault()
            }

            val parts = smsManager.divideMessage(message)
            if (parts.size > 1) {
                smsManager.sendMultipartTextMessage(cleanNumber, null, parts, null, null)
            } else {
                smsManager.sendTextMessage(cleanNumber, null, message, null, null)
            }
            Log.d(TAG, "SMS successfully dispatched to $cleanNumber")
            Pair(true, null)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to send SMS to $phoneNumber", e)
            Pair(false, e.localizedMessage ?: "Unknown SMS sending error")
        }
    }
}


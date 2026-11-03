import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../core/services/contacts_service.dart';
import '../../core/services/native_sms_service.dart';
import '../../core/services/notification_service.dart';
import '../entities/busy_status.dart';
import '../entities/call_log_entry.dart';
import '../repositories/i_busy_status_repository.dart';
import '../repositories/i_call_log_repository.dart';
import '../repositories/i_settings_repository.dart';
import '../repositories/i_whitelist_repository.dart';
import 'format_reply_message_usecase.dart';
import 'match_busy_status_usecase.dart';
import 'should_send_reply_usecase.dart';

class ProcessIncomingCallUseCase {
  final IBusyStatusRepository statusRepo;
  final ICallLogRepository logRepo;
  final IWhitelistRepository whitelistRepo;
  final ISettingsRepository settingsRepo;
  final ContactsService contactsService;
  final NativeSmsService smsService;
  final MatchBusyStatusUseCase matchBusyStatusUseCase;
  final FormatReplyMessageUseCase formatReplyMessageUseCase;
  final ShouldSendReplyUseCase shouldSendReplyUseCase;

  ProcessIncomingCallUseCase({
    required this.statusRepo,
    required this.logRepo,
    required this.whitelistRepo,
    required this.settingsRepo,
    required this.contactsService,
    required this.smsService,
    required this.matchBusyStatusUseCase,
    required this.formatReplyMessageUseCase,
    required this.shouldSendReplyUseCase,
  });

  Future<T?> _retryQuery<T>(Future<T> Function() queryFn,
      {int maxAttempts = 3}) async {
    for (int i = 0; i < maxAttempts; i++) {
      try {
        return await queryFn();
      } catch (e) {
        if (i == maxAttempts - 1) {
          debugPrint('Query failed after $maxAttempts attempts: $e');
          return null;
        }
        await Future.delayed(Duration(milliseconds: 200 * (i + 1)));
      }
    }
    return null;
  }

  Future<void> execute({
    required String rawCallerNumber,
    DateTime? callTimestamp,
    String callSource = 'cellular',
    String? notificationKey,
    bool hasDirectReply = false,
    String? voipPhoneNumber,
  }) async {
    final callTime = callTimestamp ?? DateTime.now();
    final callerNumber = rawCallerNumber.trim();
    const uuid = Uuid();

    // 1. Fetch current configuration & status with retry
    final settings = await settingsRepo.getSettings();
    final allStatuses =
        await _retryQuery(() => statusRepo.getAllStatuses()) ?? <BusyStatus>[];
    final activeStatus = matchBusyStatusUseCase.execute(
      allStatuses: allStatuses,
      currentTime: callTime,
    );

    // 2. Fetch contact info & whitelist status
    String? contactName;
    String? fallbackPhoneNumber;
    bool isCallerInContacts = false;

    if (callSource == 'cellular') {
      try {
        contactName = await contactsService.findContactName(callerNumber);
        isCallerInContacts = contactName != null;
      } catch (_) {}
    } else {
      // For VoIP calls (WhatsApp, Messenger, Telegram), callerNumber is the contact's name
      contactName = callerNumber;
      if (voipPhoneNumber != null && voipPhoneNumber.isNotEmpty) {
        fallbackPhoneNumber = voipPhoneNumber;
        isCallerInContacts = true;
      } else {
        try {
          fallbackPhoneNumber =
              await contactsService.findPhoneNumberByName(callerNumber);
          isCallerInContacts = fallbackPhoneNumber != null;
        } catch (_) {}
      }
    }

    // Whitelist check
    bool isWhitelisted =
        await _retryQuery(() => whitelistRepo.isWhitelisted(callerNumber)) ??
            false;
    if (!isWhitelisted && fallbackPhoneNumber != null) {
      isWhitelisted = await _retryQuery(
              () => whitelistRepo.isWhitelisted(fallbackPhoneNumber!)) ??
          false;
    }

    final lastLog =
        await _retryQuery(() => logRepo.getLastLogForCaller(callerNumber));

    // 3. Evaluate auto-reply decision
    final decision = shouldSendReplyUseCase.execute(
      settings: settings,
      activeStatus: activeStatus,
      callerNumber: callerNumber,
      isWhitelisted: isWhitelisted,
      isCallerInContacts: isCallerInContacts,
      lastLogForCaller: lastLog,
      callTime: callTime,
      callSource: callSource,
    );

    if (decision.shouldSend && activeStatus != null) {
      // 4. Format auto-reply message
      final isBangla = settings.language == 'bn';
      final replyMessage = formatReplyMessageUseCase.execute(
        status: activeStatus,
        callTime: callTime,
        callerName: contactName,
        isBangla: isBangla,
      );

      // 5. Send reply based on call source
      if (callSource != 'cellular') {
        debugPrint(
            'VoIP call from $callerNumber ($callSource). hasDirectReply: $hasDirectReply, fallbackPhone: $fallbackPhoneNumber');
        bool directSent = false;
        debugPrint('Attempting direct in-app reply via $callSource to $callerNumber...');
        directSent = await smsService.sendVoipDirectReply(
          notificationKey: notificationKey ?? '',
          source: callSource,
          callerName: callerNumber,
          message: replyMessage,
        );
        debugPrint('Direct VoIP reply result for $callerNumber: $directSent');

        if (directSent) {
          debugPrint('Successfully sent direct reply via $callSource to $callerNumber!');
          final logEntry = CallLogEntry(
            id: uuid.v4(),
            callerNumber: callerNumber,
            contactName: contactName,
            callTime: callTime,
            activeStatusTitle: activeStatus.title,
            messageSent: replyMessage,
            smsResult: SmsResult.sent,
            callSource: callSource,
          );
          await _retryQuery(() => logRepo.insertLog(logEntry));

          await NotificationService().showAutoReplySentNotification(
            callerInfo: '$callerNumber ($callSource)',
            statusTitle: activeStatus.title,
            messageSent: replyMessage,
          );
        } else if (fallbackPhoneNumber != null &&
            fallbackPhoneNumber.isNotEmpty &&
            !fallbackPhoneNumber.contains('*') &&
            !fallbackPhoneNumber.contains('#') &&
            fallbackPhoneNumber.replaceAll(RegExp(r'\D'), '').length >= 8) {
          debugPrint(
              'Direct VoIP reply not available for call; sending SMS fallback to $fallbackPhoneNumber');
          final smsResult = await smsService.sendSms(
            phoneNumber: fallbackPhoneNumber,
            message: replyMessage,
          );

          if (smsResult.isSuccess) {
            debugPrint('SMS fallback sent successfully to $fallbackPhoneNumber');
            final logEntry = CallLogEntry(
              id: uuid.v4(),
              callerNumber: callerNumber,
              contactName: contactName,
              callTime: callTime,
              activeStatusTitle: activeStatus.title,
              messageSent: replyMessage,
              smsResult: SmsResult.sent,
              callSource: callSource,
              skipOrFailureReason:
                  'Sent via SMS fallback to $fallbackPhoneNumber',
            );
            await _retryQuery(() => logRepo.insertLog(logEntry));

            await NotificationService().showAutoReplySentNotification(
              callerInfo: '$callerNumber ($callSource -> SMS)',
              statusTitle: activeStatus.title,
              messageSent: replyMessage,
            );
          } else {
            debugPrint('Failed to send SMS fallback: ${smsResult.errorMessage}');
            final logEntry = CallLogEntry(
              id: uuid.v4(),
              callerNumber: callerNumber,
              contactName: contactName,
              callTime: callTime,
              activeStatusTitle: activeStatus.title,
              messageSent: replyMessage,
              smsResult: SmsResult.failed,
              callSource: callSource,
              skipOrFailureReason:
                  'Direct VoIP reply failed; SMS fallback error: ${smsResult.errorMessage}',
            );
            await _retryQuery(() => logRepo.insertLog(logEntry));
          }
        } else {
          debugPrint(
              'Direct VoIP reply unavailable for call and no phone number found in contacts for SMS fallback');
          final logEntry = CallLogEntry(
            id: uuid.v4(),
            callerNumber: callerNumber,
            contactName: contactName,
            callTime: callTime,
            activeStatusTitle: activeStatus.title,
            messageSent: replyMessage,
            smsResult: SmsResult.failed,
            callSource: callSource,
            skipOrFailureReason:
                'WhatsApp/Messenger calls do not support direct text replies in Android; no contact phone number matched for SMS fallback',
          );
          await _retryQuery(() => logRepo.insertLog(logEntry));

          await NotificationService().showVoipUnsavedContactAlert(
            callerName: callerNumber,
            appSource: callSource,
            isBangla: isBangla,
          );
        }
      } else {
        // Cellular Call: Send standard SMS via Native SmsManager
        debugPrint(
            'Dispatching SMS to $callerNumber with message: $replyMessage');
        final sendResult = await smsService.sendSms(
          phoneNumber: callerNumber,
          message: replyMessage,
        );

        if (sendResult.isSuccess) {
          debugPrint('SMS successfully sent to $callerNumber');
          final logEntry = CallLogEntry(
            id: uuid.v4(),
            callerNumber: callerNumber,
            contactName: contactName,
            callTime: callTime,
            activeStatusTitle: activeStatus.title,
            messageSent: replyMessage,
            smsResult: SmsResult.sent,
            callSource: 'cellular',
          );
          await _retryQuery(() => logRepo.insertLog(logEntry));

          final callerDisplay = contactName != null
              ? '$contactName ($callerNumber)'
              : callerNumber;
          await NotificationService().showAutoReplySentNotification(
            callerInfo: callerDisplay,
            statusTitle: activeStatus.title,
            messageSent: replyMessage,
          );
        } else {
          debugPrint('Failed to send SMS: ${sendResult.errorMessage}');
          final logEntry = CallLogEntry(
            id: uuid.v4(),
            callerNumber: callerNumber,
            contactName: contactName,
            callTime: callTime,
            activeStatusTitle: activeStatus.title,
            messageSent: replyMessage,
            smsResult: SmsResult.failed,
            callSource: 'cellular',
            skipOrFailureReason:
                sendResult.errorMessage ?? 'SMS dispatch error',
          );
          await _retryQuery(() => logRepo.insertLog(logEntry));
        }
      }
    } else {
      debugPrint(
          'Call skipped. Reason: ${decision.skipReason ?? "No active busy status"}');
      // Log skipped call event
      final logEntry = CallLogEntry(
        id: uuid.v4(),
        callerNumber: callerNumber,
        contactName: contactName,
        callTime: callTime,
        activeStatusTitle: activeStatus?.title ?? 'None',
        messageSent: '',
        smsResult: SmsResult.skipped,
        callSource: callSource,
        skipOrFailureReason: decision.skipReason ?? 'Skipped by filter rule',
      );
      await _retryQuery(() => logRepo.insertLog(logEntry));
    }

    // Auto-clean logs based on retention policy
    try {
      await _retryQuery(() => logRepo.cleanOldLogs(settings.logRetentionDays));
    } catch (_) {}
  }
}

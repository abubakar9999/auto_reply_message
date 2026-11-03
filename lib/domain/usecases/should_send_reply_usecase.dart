import '../../core/utils/phone_number_helper.dart';
import '../entities/app_settings.dart';
import '../entities/busy_status.dart';
import '../entities/call_log_entry.dart';

class ReplyDecision {
  final bool shouldSend;
  final String? skipReason;

  const ReplyDecision.allow()
      : shouldSend = true,
        skipReason = null;

  const ReplyDecision.skip(this.skipReason) : shouldSend = false;
}

class ShouldSendReplyUseCase {
  ReplyDecision execute({
    required AppSettings settings,
    required BusyStatus? activeStatus,
    required String callerNumber,
    required bool isWhitelisted,
    required bool isCallerInContacts,
    required CallLogEntry? lastLogForCaller,
    required DateTime callTime,
    String callSource = 'cellular',
  }) {
    // 1. Master Switch check
    if (!settings.isMasterEnabled) {
      return const ReplyDecision.skip('Master auto-reply switch is OFF');
    }

    // 2. Call source toggle check
    switch (callSource.toLowerCase()) {
      case 'whatsapp':
        if (!settings.enableWhatsAppCalls) {
          return const ReplyDecision.skip('WhatsApp call auto-reply is disabled in settings');
        }
        break;
      case 'messenger':
        if (!settings.enableMessengerCalls) {
          return const ReplyDecision.skip('Messenger call auto-reply is disabled in settings');
        }
        break;
      case 'telegram':
        if (!settings.enableTelegramCalls) {
          return const ReplyDecision.skip('Telegram call auto-reply is disabled in settings');
        }
        break;
      case 'cellular':
      default:
        if (!settings.enableCellularCalls) {
          return const ReplyDecision.skip('Phone call auto-reply is disabled in settings');
        }
        break;
    }

    // 3. Active Busy Status check
    if (activeStatus == null) {
      return const ReplyDecision.skip('No active busy status at call time');
    }

    // 4. Unknown / Private caller check
    if (callSource == 'cellular') {
      final isValidNumber = PhoneNumberHelper.isValidCaller(callerNumber);
      if (!isValidNumber && settings.skipUnknownNumbers) {
        return const ReplyDecision.skip('Unknown or private number');
      }
    } else {
      final trimmed = callerNumber.trim().toLowerCase();
      final isAnonymous = trimmed.isEmpty ||
          trimmed == 'unknown' ||
          trimmed == 'private' ||
          trimmed == 'restricted';
      if (isAnonymous && settings.skipUnknownNumbers) {
        return const ReplyDecision.skip('Unknown or private VoIP caller');
      }
    }

    // 5. Whitelist check
    if (isWhitelisted) {
      return const ReplyDecision.skip('Caller is in whitelist');
    }

    // 6. "Only reply to contacts" check
    if (settings.onlyReplyToContacts && !isCallerInContacts) {
      return const ReplyDecision.skip('Caller is not in saved contacts');
    }

    // 7. Anti-spam & Cooldown check
    if (lastLogForCaller != null &&
        lastLogForCaller.smsResult == SmsResult.sent) {
      final elapsedMinutes =
          callTime.difference(lastLogForCaller.callTime).inMinutes;

      // Cooldown rule
      if (elapsedMinutes < settings.cooldownMinutes) {
        return ReplyDecision.skip(
          'Cooldown active (last replied $elapsedMinutes min ago, cooldown is ${settings.cooldownMinutes} min)',
        );
      }

      // Once-per-session rule: same status title within recent window
      if (lastLogForCaller.activeStatusTitle == activeStatus.title &&
          elapsedMinutes < 60) {
        return const ReplyDecision.skip(
          'Already replied to this caller during the current busy session',
        );
      }
    }

    return const ReplyDecision.allow();
  }
}

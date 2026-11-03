import 'package:flutter_test/flutter_test.dart';
import 'package:auto_reply/core/utils/time_utils.dart';
import 'package:auto_reply/domain/entities/busy_status.dart';
import 'package:auto_reply/domain/usecases/format_reply_message_usecase.dart';

void main() {
  late FormatReplyMessageUseCase formatUseCase;

  setUp(() {
    formatUseCase = FormatReplyMessageUseCase();
  });

  group('FormatReplyMessageUseCase Tests', () {
    test('Correctly substitutes template variables in English', () {
      final status = BusyStatus(
        id: '1',
        title: 'Meeting',
        iconKey: 'meeting',
        colorValue: 0xFF3B82F6,
        startMinutes: 14 * 60, // 02:00 PM
        endMinutes: 14 * 60 + 30, // 02:30 PM (remaining 20 min from 02:10)
        messageTemplate:
            'Hello {caller_name}, I am in a {status}. Will call back in {duration} mins around {return_time}.',
        isEnabled: true,
      );

      final callTime = DateTime(2026, 11, 4, 14, 10);
      final formatted = formatUseCase.execute(
        status: status,
        callTime: callTime,
        callerName: 'Alex',
        isBangla: false,
      );

      expect(formatted, contains('Hello Alex'));
      expect(formatted, contains('Meeting'));
      expect(formatted, contains('20 mins'));
      expect(formatted, contains('02:30 PM'));
    });

    test('Correctly substitutes Bangla numerals and variables', () {
      final status = BusyStatus(
        id: '1',
        title: 'নামাজ',
        iconKey: 'mosque',
        colorValue: 0xFF0D9488,
        startMinutes: 13 * 60 + 15,
        endMinutes: 13 * 60 + 45, // 01:45 PM -> ০১:৪৫ PM
        messageTemplate:
            'আমি {status} এ আছি, {duration} মিনিট পর কল দিচ্ছি ({return_time})।',
        isEnabled: true,
      );

      // Call at 13:25 -> 20 minutes remaining -> ২০
      final callTime = DateTime(2026, 11, 4, 13, 25);
      final formatted = formatUseCase.execute(
        status: status,
        callTime: callTime,
        callerName: null,
        isBangla: true,
      );

      expect(formatted, contains('আমি নামাজ এ আছি'));
      expect(formatted, contains('২০ মিনিট পর'));
      expect(formatted, contains('০১:৪৫ PM'));
    });

    test('Duration calculation handles overnight schedule correctly', () {
      // 23:00 to 07:00 (end = 420 mins)
      final sleepStatus = BusyStatus(
        id: 'sleep_1',
        title: 'Sleep',
        iconKey: 'bed',
        colorValue: 0xFF6366F1,
        startMinutes: 23 * 60, // 1380
        endMinutes: 7 * 60,    // 420
        messageTemplate: 'I am in {status}, will wake up around {return_time}.',
        isEnabled: true,
      );

      // Call at 23:30 (1410 min) -> Remaining = (1440 - 1410) + 420 = 450 minutes
      final remaining = TimeUtils.calculateRemainingMinutes(
        currentMinutes: 23 * 60 + 30,
        startMinutes: sleepStatus.startMinutes,
        endMinutes: sleepStatus.endMinutes,
      );

      expect(remaining, 450);
    });

    test('Bengali digit conversion utility is accurate', () {
      expect(TimeUtils.toBanglaDigits('0123456789'), '০১২৩৪৫৬৭৮৯');
      expect(TimeUtils.toBanglaDigits('Call at 02:45 PM'), 'Call at ০২:৪৫ PM');
    });
  });
}


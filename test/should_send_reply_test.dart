import 'package:flutter_test/flutter_test.dart';
import 'package:auto_reply/domain/entities/app_settings.dart';
import 'package:auto_reply/domain/entities/busy_status.dart';
import 'package:auto_reply/domain/entities/call_log_entry.dart';
import 'package:auto_reply/domain/usecases/should_send_reply_usecase.dart';

void main() {
  late ShouldSendReplyUseCase shouldSendUseCase;
  late BusyStatus activeStatus;

  setUp(() {
    shouldSendUseCase = ShouldSendReplyUseCase();
    activeStatus = const BusyStatus(
      id: '1',
      title: 'Meeting',
      iconKey: 'meeting',
      colorValue: 0xFF3B82F6,
      startMinutes: 10 * 60,
      endMinutes: 11 * 60,
      messageTemplate: 'Busy',
    );
  });

  group('ShouldSendReplyUseCase Tests', () {
    test('Skips reply when Master Switch is OFF', () {
      const settings = AppSettings(isMasterEnabled: false);
      final decision = shouldSendUseCase.execute(
        settings: settings,
        activeStatus: activeStatus,
        callerNumber: '01712345678',
        isWhitelisted: false,
        isCallerInContacts: true,
        lastLogForCaller: null,
        callTime: DateTime.now(),
      );

      expect(decision.shouldSend, isFalse);
      expect(decision.skipReason, contains('Master auto-reply switch is OFF'));
    });

    test('Skips reply when there is no active busy status', () {
      const settings = AppSettings(isMasterEnabled: true);
      final decision = shouldSendUseCase.execute(
        settings: settings,
        activeStatus: null, // No active status
        callerNumber: '01712345678',
        isWhitelisted: false,
        isCallerInContacts: true,
        lastLogForCaller: null,
        callTime: DateTime.now(),
      );

      expect(decision.shouldSend, isFalse);
      expect(decision.skipReason, contains('No active busy status'));
    });

    test('Skips reply when caller is in whitelist', () {
      const settings = AppSettings(isMasterEnabled: true);
      final decision = shouldSendUseCase.execute(
        settings: settings,
        activeStatus: activeStatus,
        callerNumber: '01712345678',
        isWhitelisted: true, // Caller is in whitelist!
        isCallerInContacts: true,
        lastLogForCaller: null,
        callTime: DateTime.now(),
      );

      expect(decision.shouldSend, isFalse);
      expect(decision.skipReason, contains('Caller is in whitelist'));
    });

    test('Skips unknown or private caller when skipUnknownNumbers is enabled', () {
      const settings = AppSettings(
        isMasterEnabled: true,
        skipUnknownNumbers: true,
      );
      final decision = shouldSendUseCase.execute(
        settings: settings,
        activeStatus: activeStatus,
        callerNumber: 'Private',
        isWhitelisted: false,
        isCallerInContacts: false,
        lastLogForCaller: null,
        callTime: DateTime.now(),
      );

      expect(decision.shouldSend, isFalse);
      expect(decision.skipReason, contains('Unknown or private number'));
    });

    test('Skips reply when onlyReplyToContacts is true and caller is not in contacts', () {
      const settings = AppSettings(
        isMasterEnabled: true,
        onlyReplyToContacts: true,
      );
      final decision = shouldSendUseCase.execute(
        settings: settings,
        activeStatus: activeStatus,
        callerNumber: '01899999999',
        isWhitelisted: false,
        isCallerInContacts: false, // Not in contacts!
        lastLogForCaller: null,
        callTime: DateTime.now(),
      );

      expect(decision.shouldSend, isFalse);
      expect(decision.skipReason, contains('not in saved contacts'));
    });

    test('Cooldown: blocks repeated reply within cooldown window', () {
      const settings = AppSettings(
        isMasterEnabled: true,
        cooldownMinutes: 30,
      );
      final now = DateTime(2026, 11, 4, 10, 20);

      // Previous reply was sent 10 minutes ago
      final lastLog = CallLogEntry(
        id: 'log_1',
        callerNumber: '01712345678',
        callTime: DateTime(2026, 11, 4, 10, 10), // 10 min ago (< 30 min cooldown)
        activeStatusTitle: 'Meeting',
        messageSent: 'Busy in meeting',
        smsResult: SmsResult.sent,
      );

      final decision = shouldSendUseCase.execute(
        settings: settings,
        activeStatus: activeStatus,
        callerNumber: '01712345678',
        isWhitelisted: false,
        isCallerInContacts: true,
        lastLogForCaller: lastLog,
        callTime: now,
      );

      expect(decision.shouldSend, isFalse);
      expect(decision.skipReason, contains('Cooldown active'));
    });

    test('Allows reply when cooldown period has passed', () {
      const settings = AppSettings(
        isMasterEnabled: true,
        cooldownMinutes: 30,
      );
      final now = DateTime(2026, 11, 4, 11, 00);

      // Previous reply was sent 45 minutes ago
      final lastLog = CallLogEntry(
        id: 'log_1',
        callerNumber: '01712345678',
        callTime: DateTime(2026, 11, 4, 10, 15), // 45 min ago (> 30 min)
        activeStatusTitle: 'Old Session',
        messageSent: 'Busy in meeting',
        smsResult: SmsResult.sent,
      );

      final decision = shouldSendUseCase.execute(
        settings: settings,
        activeStatus: activeStatus,
        callerNumber: '01712345678',
        isWhitelisted: false,
        isCallerInContacts: true,
        lastLogForCaller: lastLog,
        callTime: now,
      );

      expect(decision.shouldSend, isTrue);
      expect(decision.skipReason, isNull);
    });

    // VoIP Call Tests
    test('Allows WhatsApp call when WhatsApp calls are enabled', () {
      const settings = AppSettings(
        isMasterEnabled: true,
        enableWhatsAppCalls: true,
      );
      final decision = shouldSendUseCase.execute(
        settings: settings,
        activeStatus: activeStatus,
        callerNumber: 'Abdur Rahim',
        isWhitelisted: false,
        isCallerInContacts: true,
        lastLogForCaller: null,
        callTime: DateTime.now(),
        callSource: 'whatsapp',
      );

      expect(decision.shouldSend, isTrue);
      expect(decision.skipReason, isNull);
    });

    test('Skips WhatsApp call when WhatsApp calls are disabled in settings', () {
      const settings = AppSettings(
        isMasterEnabled: true,
        enableWhatsAppCalls: false, // Disabled!
      );
      final decision = shouldSendUseCase.execute(
        settings: settings,
        activeStatus: activeStatus,
        callerNumber: 'Abdur Rahim',
        isWhitelisted: false,
        isCallerInContacts: true,
        lastLogForCaller: null,
        callTime: DateTime.now(),
        callSource: 'whatsapp',
      );

      expect(decision.shouldSend, isFalse);
      expect(decision.skipReason, contains('WhatsApp call auto-reply is disabled'));
    });

    test('Allows Messenger call when Messenger calls are enabled', () {
      const settings = AppSettings(
        isMasterEnabled: true,
        enableMessengerCalls: true,
      );
      final decision = shouldSendUseCase.execute(
        settings: settings,
        activeStatus: activeStatus,
        callerNumber: 'Tanvir Hossain',
        isWhitelisted: false,
        isCallerInContacts: true,
        lastLogForCaller: null,
        callTime: DateTime.now(),
        callSource: 'messenger',
      );

      expect(decision.shouldSend, isTrue);
      expect(decision.skipReason, isNull);
    });

    test('Skips Messenger call when Messenger calls are disabled in settings', () {
      const settings = AppSettings(
        isMasterEnabled: true,
        enableMessengerCalls: false, // Disabled!
      );
      final decision = shouldSendUseCase.execute(
        settings: settings,
        activeStatus: activeStatus,
        callerNumber: 'Tanvir Hossain',
        isWhitelisted: false,
        isCallerInContacts: true,
        lastLogForCaller: null,
        callTime: DateTime.now(),
        callSource: 'messenger',
      );

      expect(decision.shouldSend, isFalse);
      expect(decision.skipReason, contains('Messenger call auto-reply is disabled'));
    });

    test('Skips anonymous VoIP caller when skipUnknownNumbers is enabled', () {
      const settings = AppSettings(
        isMasterEnabled: true,
        skipUnknownNumbers: true,
      );
      final decision = shouldSendUseCase.execute(
        settings: settings,
        activeStatus: activeStatus,
        callerNumber: 'Unknown',
        isWhitelisted: false,
        isCallerInContacts: false,
        lastLogForCaller: null,
        callTime: DateTime.now(),
        callSource: 'whatsapp',
      );

      expect(decision.shouldSend, isFalse);
      expect(decision.skipReason, contains('Unknown or private VoIP caller'));
    });
  });
}

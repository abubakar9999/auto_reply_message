import 'package:flutter_test/flutter_test.dart';
import 'package:auto_reply/domain/entities/busy_status.dart';
import 'package:auto_reply/domain/usecases/match_busy_status_usecase.dart';

void main() {
  late MatchBusyStatusUseCase matchUseCase;

  setUp(() {
    matchUseCase = MatchBusyStatusUseCase();
  });

  group('MatchBusyStatusUseCase Tests', () {
    test('Matches normal daytime schedule on matching weekday', () {
      final status = BusyStatus(
        id: '1',
        title: 'Dhuhr Prayer',
        iconKey: 'mosque',
        colorValue: 0xFF0D9488,
        startMinutes: 13 * 60 + 15, // 13:15
        endMinutes: 13 * 60 + 55,   // 13:55
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        messageTemplate: 'In prayer',
        isEnabled: true,
        priority: 10,
      );

      // Call at 13:30 on a Wednesday (2026-11-04 is a Wednesday)
      final callTime = DateTime(2026, 11, 4, 13, 30);
      final match = matchUseCase.execute(
        allStatuses: [status],
        currentTime: callTime,
      );

      expect(match, isNotNull);
      expect(match!.title, 'Dhuhr Prayer');
    });

    test('Rejects when current time is outside start and end interval', () {
      final status = BusyStatus(
        id: '1',
        title: 'Meeting',
        iconKey: 'meeting',
        colorValue: 0xFF3B82F6,
        startMinutes: 10 * 60, // 10:00
        endMinutes: 11 * 60,   // 11:00
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        messageTemplate: 'In meeting',
        isEnabled: true,
      );

      final callTime = DateTime(2026, 11, 4, 11, 30); // 11:30 is outside
      final match = matchUseCase.execute(
        allStatuses: [status],
        currentTime: callTime,
      );

      expect(match, isNull);
    });

    test('Rejects when weekday is not selected in repeatDays', () {
      final status = BusyStatus(
        id: '1',
        title: 'Class',
        iconKey: 'study',
        colorValue: 0xFF3B82F6,
        startMinutes: 10 * 60,
        endMinutes: 12 * 60,
        repeatDays: const [7], // Friday only
        messageTemplate: 'In class',
        isEnabled: true,
      );

      // 2026-11-04 is Wednesday (not Friday)
      final callTime = DateTime(2026, 11, 4, 10, 30);
      final match = matchUseCase.execute(
        allStatuses: [status],
        currentTime: callTime,
      );

      expect(match, isNull);
    });

    test('Matches overnight schedule pre-midnight and post-midnight', () {
      final sleepStatus = BusyStatus(
        id: 'sleep_1',
        title: 'Sleep',
        iconKey: 'bed',
        colorValue: 0xFF6366F1,
        startMinutes: 23 * 60,      // 23:00 (11:00 PM)
        endMinutes: 6 * 60 + 30,    // 06:30 AM next morning
        repeatDays: const [1, 2, 3, 4, 5, 6, 7], // Every day
        messageTemplate: 'Sleeping',
        isEnabled: true,
        priority: 5,
      );

      // 1. Pre-midnight call at 23:45
      final preMidnight = DateTime(2026, 11, 4, 23, 45);
      final matchPre = matchUseCase.execute(
        allStatuses: [sleepStatus],
        currentTime: preMidnight,
      );
      expect(matchPre, isNotNull);
      expect(matchPre!.title, 'Sleep');

      // 2. Post-midnight call at 02:15 AM
      final postMidnight = DateTime(2026, 11, 5, 2, 15);
      final matchPost = matchUseCase.execute(
        allStatuses: [sleepStatus],
        currentTime: postMidnight,
      );
      expect(matchPost, isNotNull);
      expect(matchPost!.title, 'Sleep');

      // 3. Post-schedule call at 07:00 AM (after 06:30)
      final morningAfter = DateTime(2026, 11, 5, 7, 0);
      final matchAfter = matchUseCase.execute(
        allStatuses: [sleepStatus],
        currentTime: morningAfter,
      );
      expect(matchAfter, isNull);
    });

    test('Overlapping schedules: higher priority schedule wins', () {
      final meeting = BusyStatus(
        id: 'meet_1',
        title: 'Work Meeting',
        iconKey: 'meeting',
        colorValue: 0xFF3B82F6,
        startMinutes: 13 * 60, // 13:00 to 14:00
        endMinutes: 14 * 60,
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        messageTemplate: 'In meeting',
        isEnabled: true,
        priority: 5,
      );

      final prayer = BusyStatus(
        id: 'salat_1',
        title: 'Dhuhr Prayer',
        iconKey: 'mosque',
        colorValue: 0xFF0D9488,
        startMinutes: 13 * 60 + 15, // 13:15 to 13:50
        endMinutes: 13 * 60 + 50,
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        messageTemplate: 'In prayer',
        isEnabled: true,
        priority: 10, // Higher priority
      );

      final callTime = DateTime(2026, 11, 4, 13, 30);
      final match = matchUseCase.execute(
        allStatuses: [meeting, prayer],
        currentTime: callTime,
      );

      expect(match, isNotNull);
      expect(match!.title, 'Dhuhr Prayer'); // Priority 10 wins
    });

    test('Quick toggle takes precedence over regular schedules while active', () {
      final regularStatus = BusyStatus(
        id: 'regular_1',
        title: 'Regular Meeting',
        iconKey: 'meeting',
        colorValue: 0xFF3B82F6,
        startMinutes: 10 * 60,
        endMinutes: 12 * 60,
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        messageTemplate: 'In meeting',
        isEnabled: true,
        priority: 5,
      );

      final now = DateTime(2026, 11, 4, 10, 30);
      final quickToggle = BusyStatus(
        id: 'quick_1',
        title: 'Doctor Emergency',
        iconKey: 'sick',
        colorValue: 0xFFF59E0B,
        startMinutes: 10 * 60 + 15,
        endMinutes: 11 * 60 + 15,
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        messageTemplate: 'At doctor',
        isEnabled: true,
        priority: 999,
        isQuickToggle: true,
        quickToggleExpiresAt: DateTime(2026, 11, 4, 11, 15),
      );

      final match = matchUseCase.execute(
        allStatuses: [regularStatus, quickToggle],
        currentTime: now,
      );

      expect(match, isNotNull);
      expect(match!.title, 'Doctor Emergency');
    });

    test('Disabled status is ignored', () {
      final status = BusyStatus(
        id: '1',
        title: 'Gym',
        iconKey: 'gym',
        colorValue: 0xFF3B82F6,
        startMinutes: 17 * 60,
        endMinutes: 18 * 60,
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        messageTemplate: 'Gym',
        isEnabled: false, // Disabled
      );

      final callTime = DateTime(2026, 11, 4, 17, 30);
      final match = matchUseCase.execute(
        allStatuses: [status],
        currentTime: callTime,
      );

      expect(match, isNull);
    });
  });
}


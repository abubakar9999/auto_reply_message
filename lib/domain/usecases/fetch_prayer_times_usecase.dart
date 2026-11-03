import 'package:uuid/uuid.dart';
import '../../core/constants/preset_statuses.dart';
import '../../data/datasources/remote/aladhan_prayer_api.dart';
import '../entities/busy_status.dart';

class FetchPrayerTimesUseCase {
  final AladhanPrayerApi _api;

  FetchPrayerTimesUseCase([AladhanPrayerApi? api])
      : _api = api ?? AladhanPrayerApi();

  int _parseTimeToMinutes(String timeStr) {
    final parts = timeStr.trim().split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return hour * 60 + minute;
  }

  Future<List<BusyStatus>> execute({
    required String city,
    required String country,
    int method = 1,
    bool isBangla = true,
  }) async {
    final timings = await _api.fetchPrayerTimings(
      city: city,
      country: country,
      method: method,
    );

    const uuid = Uuid();

    // Salat prayer definitions: (NameEn, NameBn, BufferMinutes, Priority)
    final prayersConfig = [
      ('Fajr', 'Fajr Prayer', 'ফজর নামাজ', 40, 10),
      ('Dhuhr', 'Dhuhr Prayer', 'যোহর নামাজ', 45, 10),
      ('Asr', 'Asr Prayer', 'আসর নামাজ', 40, 10),
      ('Maghrib', 'Maghrib Prayer', 'মাগরিব নামাজ', 30, 10),
      ('Isha', 'Isha Prayer', 'ইশা নামাজ', 45, 10),
    ];

    final List<BusyStatus> result = [];

    for (final (key, titleEn, titleBn, bufferMins, priority) in prayersConfig) {
      int startMins;
      if (timings != null && timings.containsKey(key)) {
        startMins = _parseTimeToMinutes(timings[key]!);
      } else {
        // Offline default fallback
        final fallback = PresetStatuses.presets.firstWhere(
          (p) => p.titleEn.toLowerCase().contains(key.toLowerCase()),
        );
        startMins = fallback.defaultStartMinutes;
      }

      final endMins = (startMins + bufferMins) % (24 * 60);

      result.add(
        BusyStatus(
          id: 'salat_${key.toLowerCase()}_${uuid.v4().substring(0, 8)}',
          title: isBangla ? titleBn : titleEn,
          iconKey: 'mosque',
          colorValue: 0xFF0D9488,
          startMinutes: startMins,
          endMinutes: endMins,
          repeatDays: const [1, 2, 3, 4, 5, 6, 7],
          messageTemplate: isBangla
              ? 'আমি $titleBn-এ আছি। ইনশাআল্লাহ {return_time}-এ কল ব্যাক করব।'
              : 'I am performing $titleEn. Will call back around {return_time}.',
          isEnabled: true,
          priority: priority,
        ),
      );
    }

    return result;
  }
}


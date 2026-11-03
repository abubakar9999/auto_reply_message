import 'dart:convert';
import 'package:http/http.dart' as http;

class AladhanPrayerApi {
  Future<Map<String, String>?> fetchPrayerTimings({
    required String city,
    required String country,
    int method = 1, // 1 = University of Islamic Sciences, Karachi
  }) async {
    try {
      final uri = Uri.parse(
        'https://api.aladhan.com/v1/timingsByCity?city=${Uri.encodeComponent(city)}&country=${Uri.encodeComponent(country)}&method=$method',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['code'] == 200 && json['data'] != null) {
          final timings = json['data']['timings'] as Map<String, dynamic>;
          return {
            'Fajr': timings['Fajr'].toString().split(' ').first,
            'Dhuhr': timings['Dhuhr'].toString().split(' ').first,
            'Asr': timings['Asr'].toString().split(' ').first,
            'Maghrib': timings['Maghrib'].toString().split(' ').first,
            'Isha': timings['Isha'].toString().split(' ').first,
          };
        }
      }
    } catch (_) {
      // Return null on network error so caller can fallback to offline defaults
    }
    return null;
  }
}


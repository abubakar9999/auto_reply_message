class TimeUtils {
  /// Converts Dart DateTime.weekday (Mon=1..Sun=7) to App Weekday (Sat=1..Fri=7)
  static int dartWeekdayToAppWeekday(int dartWeekday) {
    switch (dartWeekday) {
      case DateTime.saturday:
        return 1;
      case DateTime.sunday:
        return 2;
      case DateTime.monday:
        return 3;
      case DateTime.tuesday:
        return 4;
      case DateTime.wednesday:
        return 5;
      case DateTime.thursday:
        return 6;
      case DateTime.friday:
        return 7;
      default:
        return 1;
    }
  }

  /// App Weekday (1..7) to short name
  static String appWeekdayName(int appWeekday, {bool isBangla = true}) {
    if (isBangla) {
      switch (appWeekday) {
        case 1:
          return 'শনি';
        case 2:
          return 'রবি';
        case 3:
          return 'সোম';
        case 4:
          return 'মঙ্গল';
        case 5:
          return 'বুধ';
        case 6:
          return 'বৃহঃ';
        case 7:
          return 'শুক্র';
        default:
          return '';
      }
    } else {
      switch (appWeekday) {
        case 1:
          return 'Sat';
        case 2:
          return 'Sun';
        case 3:
          return 'Mon';
        case 4:
          return 'Tue';
        case 5:
          return 'Wed';
        case 6:
          return 'Thu';
        case 7:
          return 'Fri';
        default:
          return '';
      }
    }
  }

  /// Converts English digits in a string to Bengali digits
  static String toBanglaDigits(String input) {
    const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const banglaDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    String result = input;
    for (int i = 0; i < englishDigits.length; i++) {
      result = result.replaceAll(englishDigits[i], banglaDigits[i]);
    }
    return result;
  }

  /// Formats minutes from midnight into 12-hour AM/PM string
  static String formatMinutesTo12Hour(int totalMinutes, {bool isBangla = true}) {
    int normalized = totalMinutes % (24 * 60);
    int hour24 = normalized ~/ 60;
    int minute = normalized % 60;

    String period = hour24 >= 12 ? 'PM' : 'AM';
    int hour12 = hour24 % 12;
    if (hour12 == 0) hour12 = 12;

    String minuteStr = minute.toString().padLeft(2, '0');
    String hourStr = hour12.toString().padLeft(2, '0');
    String formatted = '$hourStr:$minuteStr $period';

    if (isBangla) {
      return toBanglaDigits(formatted);
    }
    return formatted;
  }

  /// Calculates remaining minutes until end time
  static int calculateRemainingMinutes({
    required int currentMinutes,
    required int startMinutes,
    required int endMinutes,
  }) {
    if (endMinutes >= startMinutes) {
      // Normal same-day schedule (e.g. 13:00 to 14:00)
      if (currentMinutes >= startMinutes && currentMinutes <= endMinutes) {
        return endMinutes - currentMinutes;
      }
    } else {
      // Overnight schedule (e.g. 23:00 to 07:00)
      if (currentMinutes >= startMinutes) {
        // e.g. 23:30 -> remaining = (24*60 - 23:30) + 07:00 = 30 + 420 = 450
        return (24 * 60 - currentMinutes) + endMinutes;
      } else if (currentMinutes <= endMinutes) {
        // e.g. 05:00 -> remaining = 07:00 - 05:00 = 120
        return endMinutes - currentMinutes;
      }
    }
    return 0;
  }

  /// Formats duration in minutes into a friendly string (e.g. "20" or "২০")
  static String formatDurationMinutes(int minutes, {bool isBangla = true}) {
    if (isBangla) {
      return toBanglaDigits(minutes.toString());
    }
    return minutes.toString();
  }

  /// Checks if currentMinutes falls inside [startMinutes, endMinutes]
  static bool isTimeInside({
    required int currentMinutes,
    required int startMinutes,
    required int endMinutes,
  }) {
    if (endMinutes >= startMinutes) {
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    } else {
      // Overnight interval: e.g. 23:00 (1380) to 06:30 (390)
      // Active if current >= 1380 OR current <= 390
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }
  }
}

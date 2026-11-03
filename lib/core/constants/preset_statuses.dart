import 'package:flutter/material.dart';
import '../../domain/entities/busy_status.dart';

class StatusPreset {
  final String titleEn;
  final String titleBn;
  final String iconKey;
  final int colorValue;
  final int defaultStartMinutes;
  final int defaultEndMinutes;
  final String defaultTemplateBn;
  final String defaultTemplateEn;
  final int priority;

  const StatusPreset({
    required this.titleEn,
    required this.titleBn,
    required this.iconKey,
    required this.colorValue,
    required this.defaultStartMinutes,
    required this.defaultEndMinutes,
    required this.defaultTemplateBn,
    required this.defaultTemplateEn,
    required this.priority,
  });

  BusyStatus toBusyStatus({
    required String id,
    bool isBangla = true,
    List<int> repeatDays = const [1, 2, 3, 4, 5, 6, 7],
  }) {
    return BusyStatus(
      id: id,
      title: isBangla ? titleBn : titleEn,
      iconKey: iconKey,
      colorValue: colorValue,
      startMinutes: defaultStartMinutes,
      endMinutes: defaultEndMinutes,
      repeatDays: repeatDays,
      messageTemplate: isBangla ? defaultTemplateBn : defaultTemplateEn,
      isEnabled: true,
      priority: priority,
    );
  }
}

class PresetStatuses {
  static const List<StatusPreset> presets = [
    // Salat Presets
    StatusPreset(
      titleEn: 'Fajr Prayer',
      titleBn: 'ফজর নামাজ',
      iconKey: 'mosque',
      colorValue: 0xFF0D9488,
      defaultStartMinutes: 5 * 60 + 0, // 05:00
      defaultEndMinutes: 5 * 60 + 40,   // 05:40
      defaultTemplateBn: 'আমি ফজরের নামাজে আছি। ইনশাআল্লাহ {return_time}-এ কল ব্যাক করব।',
      defaultTemplateEn: 'I am in Fajr prayer. Will call back around {return_time}.',
      priority: 10,
    ),
    StatusPreset(
      titleEn: 'Dhuhr Prayer',
      titleBn: 'যোহর নামাজ',
      iconKey: 'mosque',
      colorValue: 0xFF0D9488,
      defaultStartMinutes: 13 * 60 + 15, // 13:15
      defaultEndMinutes: 13 * 60 + 55,   // 13:55
      defaultTemplateBn: 'আমি যোহরের নামাজে আছি। ইনশাআল্লাহ {return_time}-এ কল করব।',
      defaultTemplateEn: 'I am performing Dhuhr prayer. Will call back around {return_time}.',
      priority: 10,
    ),
    StatusPreset(
      titleEn: 'Asr Prayer',
      titleBn: 'আসর নামাজ',
      iconKey: 'mosque',
      colorValue: 0xFF0D9488,
      defaultStartMinutes: 16 * 60 + 30, // 16:30
      defaultEndMinutes: 17 * 60 + 05,   // 17:05
      defaultTemplateBn: 'আমি আসরের নামাজে আছি। ইনশাআল্লাহ {return_time}-এ কল করব।',
      defaultTemplateEn: 'I am performing Asr prayer. Will call back around {return_time}.',
      priority: 10,
    ),
    StatusPreset(
      titleEn: 'Maghrib Prayer',
      titleBn: 'মাগরিব নামাজ',
      iconKey: 'mosque',
      colorValue: 0xFF0D9488,
      defaultStartMinutes: 17 * 60 + 45, // 17:45
      defaultEndMinutes: 18 * 60 + 15,   // 18:15
      defaultTemplateBn: 'আমি মাগরিবের নামাজে আছি। ইনশাআল্লাহ {duration} মিনিট পর কল দিচ্ছি।',
      defaultTemplateEn: 'I am in Maghrib prayer. Will call you back in {duration} mins.',
      priority: 10,
    ),
    StatusPreset(
      titleEn: 'Isha Prayer',
      titleBn: 'ইশা নামাজ',
      iconKey: 'mosque',
      colorValue: 0xFF0D9488,
      defaultStartMinutes: 19 * 60 + 45, // 19:45
      defaultEndMinutes: 20 * 60 + 30,   // 20:30
      defaultTemplateBn: 'আমি ইশার নামাজে আছি। ইনশাআল্লাহ {return_time}-এ কল ব্যাক করব।',
      defaultTemplateEn: 'I am performing Isha prayer. Will call back around {return_time}.',
      priority: 10,
    ),
    // Sleep
    StatusPreset(
      titleEn: 'Sleep',
      titleBn: 'ঘুম',
      iconKey: 'bed',
      colorValue: 0xFF6366F1,
      defaultStartMinutes: 23 * 60 + 0, // 23:00
      defaultEndMinutes: 6 * 60 + 30,   // 06:30 (overnight)
      defaultTemplateBn: 'আমি এখন ঘুমাচ্ছি। সকালে কল ব্যাক করব। জরুরি হলে আবার কল দিন।',
      defaultTemplateEn: 'I am currently sleeping. Will get back to you in the morning.',
      priority: 5,
    ),
    // Meeting
    StatusPreset(
      titleEn: 'Meeting',
      titleBn: 'মিটিং',
      iconKey: 'meeting',
      colorValue: 0xFF3B82F6,
      defaultStartMinutes: 10 * 60 + 0, // 10:00
      defaultEndMinutes: 11 * 60 + 0,   // 11:00
      defaultTemplateBn: 'আমি এখন একটি জরুরি মিটিংয়ে আছি। {return_time}-এর পর কল ব্যাক করব।',
      defaultTemplateEn: 'I am in a meeting right now. Will return your call after {return_time}.',
      priority: 7,
    ),
    // Sick
    StatusPreset(
      titleEn: 'Sick / Resting',
      titleBn: 'অসুস্থ / বিশ্রাম',
      iconKey: 'sick',
      colorValue: 0xFFEF4444,
      defaultStartMinutes: 0,
      defaultEndMinutes: 23 * 60 + 59,
      defaultTemplateBn: 'আমি একটু অসুস্থ ও বিশ্রামে আছি। সুস্থ বোধ করলে শীঘ্রই যোগাযোগ করব।',
      defaultTemplateEn: 'I am currently unwell and resting. I will reach out as soon as I can.',
      priority: 8,
    ),
    // Driving
    StatusPreset(
      titleEn: 'Driving',
      titleBn: 'ড্রাইভিং',
      iconKey: 'car',
      colorValue: 0xFFF97316,
      defaultStartMinutes: 8 * 60 + 30,
      defaultEndMinutes: 9 * 60 + 30,
      defaultTemplateBn: 'আমি গাড়ি চালাচ্ছি। গন্তব্যে পৌঁছে {duration} মিনিট পর কল দিচ্ছি।',
      defaultTemplateEn: 'I am driving right now. Will call you back in {duration} minutes.',
      priority: 6,
    ),
  ];

  static IconData getIcon(String iconKey) {
    switch (iconKey.toLowerCase()) {
      case 'mosque':
        return Icons.mosque;
      case 'bed':
        return Icons.bedtime;
      case 'meeting':
        return Icons.business_center;
      case 'sick':
        return Icons.local_hospital;
      case 'car':
        return Icons.directions_car;
      case 'gym':
        return Icons.fitness_center;
      case 'study':
        return Icons.menu_book;
      case 'clock':
        return Icons.access_time_filled;
      case 'general':
      default:
        return Icons.notifications_off;
    }
  }
}


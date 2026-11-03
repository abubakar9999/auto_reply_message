import 'package:flutter/material.dart';

class BusyStatus {
  final String id;
  final String title;
  final String iconKey;
  final int colorValue;
  final int startMinutes; // 0..1439 (minutes from midnight)
  final int endMinutes;   // 0..1439 (minutes from midnight)
  final List<int> repeatDays; // 1=Sat, 2=Sun, 3=Mon, 4=Tue, 5=Wed, 6=Thu, 7=Fri
  final bool isOneTime;
  final DateTime? oneTimeDate;
  final String messageTemplate;
  final bool isEnabled;
  final int priority;
  final bool isQuickToggle;
  final DateTime? quickToggleExpiresAt;

  const BusyStatus({
    required this.id,
    required this.title,
    required this.iconKey,
    required this.colorValue,
    required this.startMinutes,
    required this.endMinutes,
    this.repeatDays = const [1, 2, 3, 4, 5, 6, 7],
    this.isOneTime = false,
    this.oneTimeDate,
    required this.messageTemplate,
    this.isEnabled = true,
    this.priority = 1,
    this.isQuickToggle = false,
    this.quickToggleExpiresAt,
  });

  TimeOfDay get startTime => TimeOfDay(
        hour: startMinutes ~/ 60,
        minute: startMinutes % 60,
      );

  TimeOfDay get endTime => TimeOfDay(
        hour: endMinutes ~/ 60,
        minute: endMinutes % 60,
      );

  Color get color => Color(colorValue);

  BusyStatus copyWith({
    String? id,
    String? title,
    String? iconKey,
    int? colorValue,
    int? startMinutes,
    int? endMinutes,
    List<int>? repeatDays,
    bool? isOneTime,
    DateTime? oneTimeDate,
    String? messageTemplate,
    bool? isEnabled,
    int? priority,
    bool? isQuickToggle,
    DateTime? quickToggleExpiresAt,
  }) {
    return BusyStatus(
      id: id ?? this.id,
      title: title ?? this.title,
      iconKey: iconKey ?? this.iconKey,
      colorValue: colorValue ?? this.colorValue,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      repeatDays: repeatDays ?? this.repeatDays,
      isOneTime: isOneTime ?? this.isOneTime,
      oneTimeDate: oneTimeDate ?? this.oneTimeDate,
      messageTemplate: messageTemplate ?? this.messageTemplate,
      isEnabled: isEnabled ?? this.isEnabled,
      priority: priority ?? this.priority,
      isQuickToggle: isQuickToggle ?? this.isQuickToggle,
      quickToggleExpiresAt: quickToggleExpiresAt ?? this.quickToggleExpiresAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'iconKey': iconKey,
      'colorValue': colorValue,
      'startMinutes': startMinutes,
      'endMinutes': endMinutes,
      'repeatDays': repeatDays.join(','),
      'isOneTime': isOneTime ? 1 : 0,
      'oneTimeDate': oneTimeDate?.toIso8601String(),
      'messageTemplate': messageTemplate,
      'isEnabled': isEnabled ? 1 : 0,
      'priority': priority,
      'isQuickToggle': isQuickToggle ? 1 : 0,
      'quickToggleExpiresAt': quickToggleExpiresAt?.toIso8601String(),
    };
  }

  factory BusyStatus.fromMap(Map<String, dynamic> map) {
    List<int> parsedDays = [];
    final daysStr = map['repeatDays'] as String?;
    if (daysStr != null && daysStr.isNotEmpty) {
      parsedDays = daysStr
          .split(',')
          .map((s) => int.tryParse(s.trim()))
          .whereType<int>()
          .toList();
    }
    return BusyStatus(
      id: map['id'] as String,
      title: map['title'] as String,
      iconKey: map['iconKey'] as String? ?? 'general',
      colorValue: map['colorValue'] as int? ?? 0xFF1E88E5,
      startMinutes: map['startMinutes'] as int,
      endMinutes: map['endMinutes'] as int,
      repeatDays: parsedDays,
      isOneTime: (map['isOneTime'] as int? ?? 0) == 1,
      oneTimeDate: map['oneTimeDate'] != null
          ? DateTime.tryParse(map['oneTimeDate'] as String)
          : null,
      messageTemplate: map['messageTemplate'] as String,
      isEnabled: (map['isEnabled'] as int? ?? 1) == 1,
      priority: map['priority'] as int? ?? 1,
      isQuickToggle: (map['isQuickToggle'] as int? ?? 0) == 1,
      quickToggleExpiresAt: map['quickToggleExpiresAt'] != null
          ? DateTime.tryParse(map['quickToggleExpiresAt'] as String)
          : null,
    );
  }
}


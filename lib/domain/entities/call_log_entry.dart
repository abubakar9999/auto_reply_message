enum SmsResult {
  sent,
  failed,
  skipped;

  String get displayName {
    switch (this) {
      case SmsResult.sent:
        return 'Sent';
      case SmsResult.failed:
        return 'Failed';
      case SmsResult.skipped:
        return 'Skipped';
    }
  }

  static SmsResult fromString(String value) {
    switch (value.toLowerCase()) {
      case 'sent':
        return SmsResult.sent;
      case 'failed':
        return SmsResult.failed;
      case 'skipped':
      default:
        return SmsResult.skipped;
    }
  }
}

class CallLogEntry {
  final String id;
  final String callerNumber;
  final String? contactName;
  final DateTime callTime;
  final String activeStatusTitle;
  final String messageSent;
  final SmsResult smsResult;
  final String? skipOrFailureReason;
  final String callSource; // 'cellular', 'whatsapp', 'messenger', 'telegram'

  const CallLogEntry({
    required this.id,
    required this.callerNumber,
    this.contactName,
    required this.callTime,
    required this.activeStatusTitle,
    required this.messageSent,
    required this.smsResult,
    this.skipOrFailureReason,
    this.callSource = 'cellular',
  });

  CallLogEntry copyWith({
    String? id,
    String? callerNumber,
    String? contactName,
    DateTime? callTime,
    String? activeStatusTitle,
    String? messageSent,
    SmsResult? smsResult,
    String? skipOrFailureReason,
    String? callSource,
  }) {
    return CallLogEntry(
      id: id ?? this.id,
      callerNumber: callerNumber ?? this.callerNumber,
      contactName: contactName ?? this.contactName,
      callTime: callTime ?? this.callTime,
      activeStatusTitle: activeStatusTitle ?? this.activeStatusTitle,
      messageSent: messageSent ?? this.messageSent,
      smsResult: smsResult ?? this.smsResult,
      skipOrFailureReason: skipOrFailureReason ?? this.skipOrFailureReason,
      callSource: callSource ?? this.callSource,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'callerNumber': callerNumber,
      'contactName': contactName,
      'callTime': callTime.toIso8601String(),
      'activeStatusTitle': activeStatusTitle,
      'messageSent': messageSent,
      'smsResult': smsResult.name,
      'skipOrFailureReason': skipOrFailureReason,
      'callSource': callSource,
    };
  }

  factory CallLogEntry.fromMap(Map<String, dynamic> map) {
    return CallLogEntry(
      id: map['id'] as String,
      callerNumber: map['callerNumber'] as String,
      contactName: map['contactName'] as String?,
      callTime: DateTime.parse(map['callTime'] as String),
      activeStatusTitle: map['activeStatusTitle'] as String? ?? 'None',
      messageSent: map['messageSent'] as String? ?? '',
      smsResult: SmsResult.fromString(map['smsResult'] as String? ?? 'skipped'),
      skipOrFailureReason: map['skipOrFailureReason'] as String?,
      callSource: map['callSource'] as String? ?? 'cellular',
    );
  }
}

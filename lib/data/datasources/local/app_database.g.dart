// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BusyStatusesTableTable extends BusyStatusesTable
    with TableInfo<$BusyStatusesTableTable, BusyStatusEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusyStatusesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('general'),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF1E88E5),
  );
  static const VerificationMeta _startMinutesMeta = const VerificationMeta(
    'startMinutes',
  );
  @override
  late final GeneratedColumn<int> startMinutes = GeneratedColumn<int>(
    'start_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMinutesMeta = const VerificationMeta(
    'endMinutes',
  );
  @override
  late final GeneratedColumn<int> endMinutes = GeneratedColumn<int>(
    'end_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatDaysMeta = const VerificationMeta(
    'repeatDays',
  );
  @override
  late final GeneratedColumn<String> repeatDays = GeneratedColumn<String>(
    'repeat_days',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1,2,3,4,5,6,7'),
  );
  static const VerificationMeta _isOneTimeMeta = const VerificationMeta(
    'isOneTime',
  );
  @override
  late final GeneratedColumn<bool> isOneTime = GeneratedColumn<bool>(
    'is_one_time',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_one_time" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _oneTimeDateMeta = const VerificationMeta(
    'oneTimeDate',
  );
  @override
  late final GeneratedColumn<DateTime> oneTimeDate = GeneratedColumn<DateTime>(
    'one_time_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageTemplateMeta = const VerificationMeta(
    'messageTemplate',
  );
  @override
  late final GeneratedColumn<String> messageTemplate = GeneratedColumn<String>(
    'message_template',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isQuickToggleMeta = const VerificationMeta(
    'isQuickToggle',
  );
  @override
  late final GeneratedColumn<bool> isQuickToggle = GeneratedColumn<bool>(
    'is_quick_toggle',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_quick_toggle" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _quickToggleExpiresAtMeta =
      const VerificationMeta('quickToggleExpiresAt');
  @override
  late final GeneratedColumn<DateTime> quickToggleExpiresAt =
      GeneratedColumn<DateTime>(
        'quick_toggle_expires_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    iconKey,
    colorValue,
    startMinutes,
    endMinutes,
    repeatDays,
    isOneTime,
    oneTimeDate,
    messageTemplate,
    isEnabled,
    priority,
    isQuickToggle,
    quickToggleExpiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'busy_statuses_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BusyStatusEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    }
    if (data.containsKey('start_minutes')) {
      context.handle(
        _startMinutesMeta,
        startMinutes.isAcceptableOrUnknown(
          data['start_minutes']!,
          _startMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinutesMeta);
    }
    if (data.containsKey('end_minutes')) {
      context.handle(
        _endMinutesMeta,
        endMinutes.isAcceptableOrUnknown(data['end_minutes']!, _endMinutesMeta),
      );
    } else if (isInserting) {
      context.missing(_endMinutesMeta);
    }
    if (data.containsKey('repeat_days')) {
      context.handle(
        _repeatDaysMeta,
        repeatDays.isAcceptableOrUnknown(data['repeat_days']!, _repeatDaysMeta),
      );
    }
    if (data.containsKey('is_one_time')) {
      context.handle(
        _isOneTimeMeta,
        isOneTime.isAcceptableOrUnknown(data['is_one_time']!, _isOneTimeMeta),
      );
    }
    if (data.containsKey('one_time_date')) {
      context.handle(
        _oneTimeDateMeta,
        oneTimeDate.isAcceptableOrUnknown(
          data['one_time_date']!,
          _oneTimeDateMeta,
        ),
      );
    }
    if (data.containsKey('message_template')) {
      context.handle(
        _messageTemplateMeta,
        messageTemplate.isAcceptableOrUnknown(
          data['message_template']!,
          _messageTemplateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_messageTemplateMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('is_quick_toggle')) {
      context.handle(
        _isQuickToggleMeta,
        isQuickToggle.isAcceptableOrUnknown(
          data['is_quick_toggle']!,
          _isQuickToggleMeta,
        ),
      );
    }
    if (data.containsKey('quick_toggle_expires_at')) {
      context.handle(
        _quickToggleExpiresAtMeta,
        quickToggleExpiresAt.isAcceptableOrUnknown(
          data['quick_toggle_expires_at']!,
          _quickToggleExpiresAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusyStatusEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusyStatusEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      startMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minutes'],
      )!,
      endMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minutes'],
      )!,
      repeatDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_days'],
      )!,
      isOneTime: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_one_time'],
      )!,
      oneTimeDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}one_time_date'],
      ),
      messageTemplate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_template'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      isQuickToggle: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_quick_toggle'],
      )!,
      quickToggleExpiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}quick_toggle_expires_at'],
      ),
    );
  }

  @override
  $BusyStatusesTableTable createAlias(String alias) {
    return $BusyStatusesTableTable(attachedDatabase, alias);
  }
}

class BusyStatusEntry extends DataClass implements Insertable<BusyStatusEntry> {
  final String id;
  final String title;
  final String iconKey;
  final int colorValue;
  final int startMinutes;
  final int endMinutes;
  final String repeatDays;
  final bool isOneTime;
  final DateTime? oneTimeDate;
  final String messageTemplate;
  final bool isEnabled;
  final int priority;
  final bool isQuickToggle;
  final DateTime? quickToggleExpiresAt;
  const BusyStatusEntry({
    required this.id,
    required this.title,
    required this.iconKey,
    required this.colorValue,
    required this.startMinutes,
    required this.endMinutes,
    required this.repeatDays,
    required this.isOneTime,
    this.oneTimeDate,
    required this.messageTemplate,
    required this.isEnabled,
    required this.priority,
    required this.isQuickToggle,
    this.quickToggleExpiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['icon_key'] = Variable<String>(iconKey);
    map['color_value'] = Variable<int>(colorValue);
    map['start_minutes'] = Variable<int>(startMinutes);
    map['end_minutes'] = Variable<int>(endMinutes);
    map['repeat_days'] = Variable<String>(repeatDays);
    map['is_one_time'] = Variable<bool>(isOneTime);
    if (!nullToAbsent || oneTimeDate != null) {
      map['one_time_date'] = Variable<DateTime>(oneTimeDate);
    }
    map['message_template'] = Variable<String>(messageTemplate);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['priority'] = Variable<int>(priority);
    map['is_quick_toggle'] = Variable<bool>(isQuickToggle);
    if (!nullToAbsent || quickToggleExpiresAt != null) {
      map['quick_toggle_expires_at'] = Variable<DateTime>(quickToggleExpiresAt);
    }
    return map;
  }

  BusyStatusesTableCompanion toCompanion(bool nullToAbsent) {
    return BusyStatusesTableCompanion(
      id: Value(id),
      title: Value(title),
      iconKey: Value(iconKey),
      colorValue: Value(colorValue),
      startMinutes: Value(startMinutes),
      endMinutes: Value(endMinutes),
      repeatDays: Value(repeatDays),
      isOneTime: Value(isOneTime),
      oneTimeDate: oneTimeDate == null && nullToAbsent
          ? const Value.absent()
          : Value(oneTimeDate),
      messageTemplate: Value(messageTemplate),
      isEnabled: Value(isEnabled),
      priority: Value(priority),
      isQuickToggle: Value(isQuickToggle),
      quickToggleExpiresAt: quickToggleExpiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(quickToggleExpiresAt),
    );
  }

  factory BusyStatusEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusyStatusEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      startMinutes: serializer.fromJson<int>(json['startMinutes']),
      endMinutes: serializer.fromJson<int>(json['endMinutes']),
      repeatDays: serializer.fromJson<String>(json['repeatDays']),
      isOneTime: serializer.fromJson<bool>(json['isOneTime']),
      oneTimeDate: serializer.fromJson<DateTime?>(json['oneTimeDate']),
      messageTemplate: serializer.fromJson<String>(json['messageTemplate']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      priority: serializer.fromJson<int>(json['priority']),
      isQuickToggle: serializer.fromJson<bool>(json['isQuickToggle']),
      quickToggleExpiresAt: serializer.fromJson<DateTime?>(
        json['quickToggleExpiresAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'iconKey': serializer.toJson<String>(iconKey),
      'colorValue': serializer.toJson<int>(colorValue),
      'startMinutes': serializer.toJson<int>(startMinutes),
      'endMinutes': serializer.toJson<int>(endMinutes),
      'repeatDays': serializer.toJson<String>(repeatDays),
      'isOneTime': serializer.toJson<bool>(isOneTime),
      'oneTimeDate': serializer.toJson<DateTime?>(oneTimeDate),
      'messageTemplate': serializer.toJson<String>(messageTemplate),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'priority': serializer.toJson<int>(priority),
      'isQuickToggle': serializer.toJson<bool>(isQuickToggle),
      'quickToggleExpiresAt': serializer.toJson<DateTime?>(
        quickToggleExpiresAt,
      ),
    };
  }

  BusyStatusEntry copyWith({
    String? id,
    String? title,
    String? iconKey,
    int? colorValue,
    int? startMinutes,
    int? endMinutes,
    String? repeatDays,
    bool? isOneTime,
    Value<DateTime?> oneTimeDate = const Value.absent(),
    String? messageTemplate,
    bool? isEnabled,
    int? priority,
    bool? isQuickToggle,
    Value<DateTime?> quickToggleExpiresAt = const Value.absent(),
  }) => BusyStatusEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    iconKey: iconKey ?? this.iconKey,
    colorValue: colorValue ?? this.colorValue,
    startMinutes: startMinutes ?? this.startMinutes,
    endMinutes: endMinutes ?? this.endMinutes,
    repeatDays: repeatDays ?? this.repeatDays,
    isOneTime: isOneTime ?? this.isOneTime,
    oneTimeDate: oneTimeDate.present ? oneTimeDate.value : this.oneTimeDate,
    messageTemplate: messageTemplate ?? this.messageTemplate,
    isEnabled: isEnabled ?? this.isEnabled,
    priority: priority ?? this.priority,
    isQuickToggle: isQuickToggle ?? this.isQuickToggle,
    quickToggleExpiresAt: quickToggleExpiresAt.present
        ? quickToggleExpiresAt.value
        : this.quickToggleExpiresAt,
  );
  BusyStatusEntry copyWithCompanion(BusyStatusesTableCompanion data) {
    return BusyStatusEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      startMinutes: data.startMinutes.present
          ? data.startMinutes.value
          : this.startMinutes,
      endMinutes: data.endMinutes.present
          ? data.endMinutes.value
          : this.endMinutes,
      repeatDays: data.repeatDays.present
          ? data.repeatDays.value
          : this.repeatDays,
      isOneTime: data.isOneTime.present ? data.isOneTime.value : this.isOneTime,
      oneTimeDate: data.oneTimeDate.present
          ? data.oneTimeDate.value
          : this.oneTimeDate,
      messageTemplate: data.messageTemplate.present
          ? data.messageTemplate.value
          : this.messageTemplate,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      priority: data.priority.present ? data.priority.value : this.priority,
      isQuickToggle: data.isQuickToggle.present
          ? data.isQuickToggle.value
          : this.isQuickToggle,
      quickToggleExpiresAt: data.quickToggleExpiresAt.present
          ? data.quickToggleExpiresAt.value
          : this.quickToggleExpiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusyStatusEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorValue: $colorValue, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('repeatDays: $repeatDays, ')
          ..write('isOneTime: $isOneTime, ')
          ..write('oneTimeDate: $oneTimeDate, ')
          ..write('messageTemplate: $messageTemplate, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('priority: $priority, ')
          ..write('isQuickToggle: $isQuickToggle, ')
          ..write('quickToggleExpiresAt: $quickToggleExpiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    iconKey,
    colorValue,
    startMinutes,
    endMinutes,
    repeatDays,
    isOneTime,
    oneTimeDate,
    messageTemplate,
    isEnabled,
    priority,
    isQuickToggle,
    quickToggleExpiresAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusyStatusEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.iconKey == this.iconKey &&
          other.colorValue == this.colorValue &&
          other.startMinutes == this.startMinutes &&
          other.endMinutes == this.endMinutes &&
          other.repeatDays == this.repeatDays &&
          other.isOneTime == this.isOneTime &&
          other.oneTimeDate == this.oneTimeDate &&
          other.messageTemplate == this.messageTemplate &&
          other.isEnabled == this.isEnabled &&
          other.priority == this.priority &&
          other.isQuickToggle == this.isQuickToggle &&
          other.quickToggleExpiresAt == this.quickToggleExpiresAt);
}

class BusyStatusesTableCompanion extends UpdateCompanion<BusyStatusEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> iconKey;
  final Value<int> colorValue;
  final Value<int> startMinutes;
  final Value<int> endMinutes;
  final Value<String> repeatDays;
  final Value<bool> isOneTime;
  final Value<DateTime?> oneTimeDate;
  final Value<String> messageTemplate;
  final Value<bool> isEnabled;
  final Value<int> priority;
  final Value<bool> isQuickToggle;
  final Value<DateTime?> quickToggleExpiresAt;
  final Value<int> rowid;
  const BusyStatusesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.repeatDays = const Value.absent(),
    this.isOneTime = const Value.absent(),
    this.oneTimeDate = const Value.absent(),
    this.messageTemplate = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.priority = const Value.absent(),
    this.isQuickToggle = const Value.absent(),
    this.quickToggleExpiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BusyStatusesTableCompanion.insert({
    required String id,
    required String title,
    this.iconKey = const Value.absent(),
    this.colorValue = const Value.absent(),
    required int startMinutes,
    required int endMinutes,
    this.repeatDays = const Value.absent(),
    this.isOneTime = const Value.absent(),
    this.oneTimeDate = const Value.absent(),
    required String messageTemplate,
    this.isEnabled = const Value.absent(),
    this.priority = const Value.absent(),
    this.isQuickToggle = const Value.absent(),
    this.quickToggleExpiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       startMinutes = Value(startMinutes),
       endMinutes = Value(endMinutes),
       messageTemplate = Value(messageTemplate);
  static Insertable<BusyStatusEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? iconKey,
    Expression<int>? colorValue,
    Expression<int>? startMinutes,
    Expression<int>? endMinutes,
    Expression<String>? repeatDays,
    Expression<bool>? isOneTime,
    Expression<DateTime>? oneTimeDate,
    Expression<String>? messageTemplate,
    Expression<bool>? isEnabled,
    Expression<int>? priority,
    Expression<bool>? isQuickToggle,
    Expression<DateTime>? quickToggleExpiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (iconKey != null) 'icon_key': iconKey,
      if (colorValue != null) 'color_value': colorValue,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (endMinutes != null) 'end_minutes': endMinutes,
      if (repeatDays != null) 'repeat_days': repeatDays,
      if (isOneTime != null) 'is_one_time': isOneTime,
      if (oneTimeDate != null) 'one_time_date': oneTimeDate,
      if (messageTemplate != null) 'message_template': messageTemplate,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (priority != null) 'priority': priority,
      if (isQuickToggle != null) 'is_quick_toggle': isQuickToggle,
      if (quickToggleExpiresAt != null)
        'quick_toggle_expires_at': quickToggleExpiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BusyStatusesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? iconKey,
    Value<int>? colorValue,
    Value<int>? startMinutes,
    Value<int>? endMinutes,
    Value<String>? repeatDays,
    Value<bool>? isOneTime,
    Value<DateTime?>? oneTimeDate,
    Value<String>? messageTemplate,
    Value<bool>? isEnabled,
    Value<int>? priority,
    Value<bool>? isQuickToggle,
    Value<DateTime?>? quickToggleExpiresAt,
    Value<int>? rowid,
  }) {
    return BusyStatusesTableCompanion(
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (startMinutes.present) {
      map['start_minutes'] = Variable<int>(startMinutes.value);
    }
    if (endMinutes.present) {
      map['end_minutes'] = Variable<int>(endMinutes.value);
    }
    if (repeatDays.present) {
      map['repeat_days'] = Variable<String>(repeatDays.value);
    }
    if (isOneTime.present) {
      map['is_one_time'] = Variable<bool>(isOneTime.value);
    }
    if (oneTimeDate.present) {
      map['one_time_date'] = Variable<DateTime>(oneTimeDate.value);
    }
    if (messageTemplate.present) {
      map['message_template'] = Variable<String>(messageTemplate.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (isQuickToggle.present) {
      map['is_quick_toggle'] = Variable<bool>(isQuickToggle.value);
    }
    if (quickToggleExpiresAt.present) {
      map['quick_toggle_expires_at'] = Variable<DateTime>(
        quickToggleExpiresAt.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusyStatusesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorValue: $colorValue, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('repeatDays: $repeatDays, ')
          ..write('isOneTime: $isOneTime, ')
          ..write('oneTimeDate: $oneTimeDate, ')
          ..write('messageTemplate: $messageTemplate, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('priority: $priority, ')
          ..write('isQuickToggle: $isQuickToggle, ')
          ..write('quickToggleExpiresAt: $quickToggleExpiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CallLogsTableTable extends CallLogsTable
    with TableInfo<$CallLogsTableTable, CallLogDbEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CallLogsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _callerNumberMeta = const VerificationMeta(
    'callerNumber',
  );
  @override
  late final GeneratedColumn<String> callerNumber = GeneratedColumn<String>(
    'caller_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactNameMeta = const VerificationMeta(
    'contactName',
  );
  @override
  late final GeneratedColumn<String> contactName = GeneratedColumn<String>(
    'contact_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _callTimeMeta = const VerificationMeta(
    'callTime',
  );
  @override
  late final GeneratedColumn<DateTime> callTime = GeneratedColumn<DateTime>(
    'call_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeStatusTitleMeta = const VerificationMeta(
    'activeStatusTitle',
  );
  @override
  late final GeneratedColumn<String> activeStatusTitle =
      GeneratedColumn<String>(
        'active_status_title',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _messageSentMeta = const VerificationMeta(
    'messageSent',
  );
  @override
  late final GeneratedColumn<String> messageSent = GeneratedColumn<String>(
    'message_sent',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _smsResultMeta = const VerificationMeta(
    'smsResult',
  );
  @override
  late final GeneratedColumn<String> smsResult = GeneratedColumn<String>(
    'sms_result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skipOrFailureReasonMeta =
      const VerificationMeta('skipOrFailureReason');
  @override
  late final GeneratedColumn<String> skipOrFailureReason =
      GeneratedColumn<String>(
        'skip_or_failure_reason',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _callSourceMeta = const VerificationMeta(
    'callSource',
  );
  @override
  late final GeneratedColumn<String> callSource = GeneratedColumn<String>(
    'call_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('cellular'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    callerNumber,
    contactName,
    callTime,
    activeStatusTitle,
    messageSent,
    smsResult,
    skipOrFailureReason,
    callSource,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'call_logs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CallLogDbEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('caller_number')) {
      context.handle(
        _callerNumberMeta,
        callerNumber.isAcceptableOrUnknown(
          data['caller_number']!,
          _callerNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_callerNumberMeta);
    }
    if (data.containsKey('contact_name')) {
      context.handle(
        _contactNameMeta,
        contactName.isAcceptableOrUnknown(
          data['contact_name']!,
          _contactNameMeta,
        ),
      );
    }
    if (data.containsKey('call_time')) {
      context.handle(
        _callTimeMeta,
        callTime.isAcceptableOrUnknown(data['call_time']!, _callTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_callTimeMeta);
    }
    if (data.containsKey('active_status_title')) {
      context.handle(
        _activeStatusTitleMeta,
        activeStatusTitle.isAcceptableOrUnknown(
          data['active_status_title']!,
          _activeStatusTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activeStatusTitleMeta);
    }
    if (data.containsKey('message_sent')) {
      context.handle(
        _messageSentMeta,
        messageSent.isAcceptableOrUnknown(
          data['message_sent']!,
          _messageSentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_messageSentMeta);
    }
    if (data.containsKey('sms_result')) {
      context.handle(
        _smsResultMeta,
        smsResult.isAcceptableOrUnknown(data['sms_result']!, _smsResultMeta),
      );
    } else if (isInserting) {
      context.missing(_smsResultMeta);
    }
    if (data.containsKey('skip_or_failure_reason')) {
      context.handle(
        _skipOrFailureReasonMeta,
        skipOrFailureReason.isAcceptableOrUnknown(
          data['skip_or_failure_reason']!,
          _skipOrFailureReasonMeta,
        ),
      );
    }
    if (data.containsKey('call_source')) {
      context.handle(
        _callSourceMeta,
        callSource.isAcceptableOrUnknown(data['call_source']!, _callSourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CallLogDbEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CallLogDbEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      callerNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caller_number'],
      )!,
      contactName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_name'],
      ),
      callTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}call_time'],
      )!,
      activeStatusTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_status_title'],
      )!,
      messageSent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_sent'],
      )!,
      smsResult: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sms_result'],
      )!,
      skipOrFailureReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skip_or_failure_reason'],
      ),
      callSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}call_source'],
      )!,
    );
  }

  @override
  $CallLogsTableTable createAlias(String alias) {
    return $CallLogsTableTable(attachedDatabase, alias);
  }
}

class CallLogDbEntry extends DataClass implements Insertable<CallLogDbEntry> {
  final String id;
  final String callerNumber;
  final String? contactName;
  final DateTime callTime;
  final String activeStatusTitle;
  final String messageSent;
  final String smsResult;
  final String? skipOrFailureReason;
  final String callSource;
  const CallLogDbEntry({
    required this.id,
    required this.callerNumber,
    this.contactName,
    required this.callTime,
    required this.activeStatusTitle,
    required this.messageSent,
    required this.smsResult,
    this.skipOrFailureReason,
    required this.callSource,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['caller_number'] = Variable<String>(callerNumber);
    if (!nullToAbsent || contactName != null) {
      map['contact_name'] = Variable<String>(contactName);
    }
    map['call_time'] = Variable<DateTime>(callTime);
    map['active_status_title'] = Variable<String>(activeStatusTitle);
    map['message_sent'] = Variable<String>(messageSent);
    map['sms_result'] = Variable<String>(smsResult);
    if (!nullToAbsent || skipOrFailureReason != null) {
      map['skip_or_failure_reason'] = Variable<String>(skipOrFailureReason);
    }
    map['call_source'] = Variable<String>(callSource);
    return map;
  }

  CallLogsTableCompanion toCompanion(bool nullToAbsent) {
    return CallLogsTableCompanion(
      id: Value(id),
      callerNumber: Value(callerNumber),
      contactName: contactName == null && nullToAbsent
          ? const Value.absent()
          : Value(contactName),
      callTime: Value(callTime),
      activeStatusTitle: Value(activeStatusTitle),
      messageSent: Value(messageSent),
      smsResult: Value(smsResult),
      skipOrFailureReason: skipOrFailureReason == null && nullToAbsent
          ? const Value.absent()
          : Value(skipOrFailureReason),
      callSource: Value(callSource),
    );
  }

  factory CallLogDbEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CallLogDbEntry(
      id: serializer.fromJson<String>(json['id']),
      callerNumber: serializer.fromJson<String>(json['callerNumber']),
      contactName: serializer.fromJson<String?>(json['contactName']),
      callTime: serializer.fromJson<DateTime>(json['callTime']),
      activeStatusTitle: serializer.fromJson<String>(json['activeStatusTitle']),
      messageSent: serializer.fromJson<String>(json['messageSent']),
      smsResult: serializer.fromJson<String>(json['smsResult']),
      skipOrFailureReason: serializer.fromJson<String?>(
        json['skipOrFailureReason'],
      ),
      callSource: serializer.fromJson<String>(json['callSource']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'callerNumber': serializer.toJson<String>(callerNumber),
      'contactName': serializer.toJson<String?>(contactName),
      'callTime': serializer.toJson<DateTime>(callTime),
      'activeStatusTitle': serializer.toJson<String>(activeStatusTitle),
      'messageSent': serializer.toJson<String>(messageSent),
      'smsResult': serializer.toJson<String>(smsResult),
      'skipOrFailureReason': serializer.toJson<String?>(skipOrFailureReason),
      'callSource': serializer.toJson<String>(callSource),
    };
  }

  CallLogDbEntry copyWith({
    String? id,
    String? callerNumber,
    Value<String?> contactName = const Value.absent(),
    DateTime? callTime,
    String? activeStatusTitle,
    String? messageSent,
    String? smsResult,
    Value<String?> skipOrFailureReason = const Value.absent(),
    String? callSource,
  }) => CallLogDbEntry(
    id: id ?? this.id,
    callerNumber: callerNumber ?? this.callerNumber,
    contactName: contactName.present ? contactName.value : this.contactName,
    callTime: callTime ?? this.callTime,
    activeStatusTitle: activeStatusTitle ?? this.activeStatusTitle,
    messageSent: messageSent ?? this.messageSent,
    smsResult: smsResult ?? this.smsResult,
    skipOrFailureReason: skipOrFailureReason.present
        ? skipOrFailureReason.value
        : this.skipOrFailureReason,
    callSource: callSource ?? this.callSource,
  );
  CallLogDbEntry copyWithCompanion(CallLogsTableCompanion data) {
    return CallLogDbEntry(
      id: data.id.present ? data.id.value : this.id,
      callerNumber: data.callerNumber.present
          ? data.callerNumber.value
          : this.callerNumber,
      contactName: data.contactName.present
          ? data.contactName.value
          : this.contactName,
      callTime: data.callTime.present ? data.callTime.value : this.callTime,
      activeStatusTitle: data.activeStatusTitle.present
          ? data.activeStatusTitle.value
          : this.activeStatusTitle,
      messageSent: data.messageSent.present
          ? data.messageSent.value
          : this.messageSent,
      smsResult: data.smsResult.present ? data.smsResult.value : this.smsResult,
      skipOrFailureReason: data.skipOrFailureReason.present
          ? data.skipOrFailureReason.value
          : this.skipOrFailureReason,
      callSource: data.callSource.present
          ? data.callSource.value
          : this.callSource,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CallLogDbEntry(')
          ..write('id: $id, ')
          ..write('callerNumber: $callerNumber, ')
          ..write('contactName: $contactName, ')
          ..write('callTime: $callTime, ')
          ..write('activeStatusTitle: $activeStatusTitle, ')
          ..write('messageSent: $messageSent, ')
          ..write('smsResult: $smsResult, ')
          ..write('skipOrFailureReason: $skipOrFailureReason, ')
          ..write('callSource: $callSource')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    callerNumber,
    contactName,
    callTime,
    activeStatusTitle,
    messageSent,
    smsResult,
    skipOrFailureReason,
    callSource,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CallLogDbEntry &&
          other.id == this.id &&
          other.callerNumber == this.callerNumber &&
          other.contactName == this.contactName &&
          other.callTime == this.callTime &&
          other.activeStatusTitle == this.activeStatusTitle &&
          other.messageSent == this.messageSent &&
          other.smsResult == this.smsResult &&
          other.skipOrFailureReason == this.skipOrFailureReason &&
          other.callSource == this.callSource);
}

class CallLogsTableCompanion extends UpdateCompanion<CallLogDbEntry> {
  final Value<String> id;
  final Value<String> callerNumber;
  final Value<String?> contactName;
  final Value<DateTime> callTime;
  final Value<String> activeStatusTitle;
  final Value<String> messageSent;
  final Value<String> smsResult;
  final Value<String?> skipOrFailureReason;
  final Value<String> callSource;
  final Value<int> rowid;
  const CallLogsTableCompanion({
    this.id = const Value.absent(),
    this.callerNumber = const Value.absent(),
    this.contactName = const Value.absent(),
    this.callTime = const Value.absent(),
    this.activeStatusTitle = const Value.absent(),
    this.messageSent = const Value.absent(),
    this.smsResult = const Value.absent(),
    this.skipOrFailureReason = const Value.absent(),
    this.callSource = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CallLogsTableCompanion.insert({
    required String id,
    required String callerNumber,
    this.contactName = const Value.absent(),
    required DateTime callTime,
    required String activeStatusTitle,
    required String messageSent,
    required String smsResult,
    this.skipOrFailureReason = const Value.absent(),
    this.callSource = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       callerNumber = Value(callerNumber),
       callTime = Value(callTime),
       activeStatusTitle = Value(activeStatusTitle),
       messageSent = Value(messageSent),
       smsResult = Value(smsResult);
  static Insertable<CallLogDbEntry> custom({
    Expression<String>? id,
    Expression<String>? callerNumber,
    Expression<String>? contactName,
    Expression<DateTime>? callTime,
    Expression<String>? activeStatusTitle,
    Expression<String>? messageSent,
    Expression<String>? smsResult,
    Expression<String>? skipOrFailureReason,
    Expression<String>? callSource,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (callerNumber != null) 'caller_number': callerNumber,
      if (contactName != null) 'contact_name': contactName,
      if (callTime != null) 'call_time': callTime,
      if (activeStatusTitle != null) 'active_status_title': activeStatusTitle,
      if (messageSent != null) 'message_sent': messageSent,
      if (smsResult != null) 'sms_result': smsResult,
      if (skipOrFailureReason != null)
        'skip_or_failure_reason': skipOrFailureReason,
      if (callSource != null) 'call_source': callSource,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CallLogsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? callerNumber,
    Value<String?>? contactName,
    Value<DateTime>? callTime,
    Value<String>? activeStatusTitle,
    Value<String>? messageSent,
    Value<String>? smsResult,
    Value<String?>? skipOrFailureReason,
    Value<String>? callSource,
    Value<int>? rowid,
  }) {
    return CallLogsTableCompanion(
      id: id ?? this.id,
      callerNumber: callerNumber ?? this.callerNumber,
      contactName: contactName ?? this.contactName,
      callTime: callTime ?? this.callTime,
      activeStatusTitle: activeStatusTitle ?? this.activeStatusTitle,
      messageSent: messageSent ?? this.messageSent,
      smsResult: smsResult ?? this.smsResult,
      skipOrFailureReason: skipOrFailureReason ?? this.skipOrFailureReason,
      callSource: callSource ?? this.callSource,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (callerNumber.present) {
      map['caller_number'] = Variable<String>(callerNumber.value);
    }
    if (contactName.present) {
      map['contact_name'] = Variable<String>(contactName.value);
    }
    if (callTime.present) {
      map['call_time'] = Variable<DateTime>(callTime.value);
    }
    if (activeStatusTitle.present) {
      map['active_status_title'] = Variable<String>(activeStatusTitle.value);
    }
    if (messageSent.present) {
      map['message_sent'] = Variable<String>(messageSent.value);
    }
    if (smsResult.present) {
      map['sms_result'] = Variable<String>(smsResult.value);
    }
    if (skipOrFailureReason.present) {
      map['skip_or_failure_reason'] = Variable<String>(
        skipOrFailureReason.value,
      );
    }
    if (callSource.present) {
      map['call_source'] = Variable<String>(callSource.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CallLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('callerNumber: $callerNumber, ')
          ..write('contactName: $contactName, ')
          ..write('callTime: $callTime, ')
          ..write('activeStatusTitle: $activeStatusTitle, ')
          ..write('messageSent: $messageSent, ')
          ..write('smsResult: $smsResult, ')
          ..write('skipOrFailureReason: $skipOrFailureReason, ')
          ..write('callSource: $callSource, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WhitelistTableTable extends WhitelistTable
    with TableInfo<$WhitelistTableTable, WhitelistDbEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WhitelistTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, phoneNumber, displayName, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'whitelist_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WhitelistDbEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WhitelistDbEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WhitelistDbEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $WhitelistTableTable createAlias(String alias) {
    return $WhitelistTableTable(attachedDatabase, alias);
  }
}

class WhitelistDbEntry extends DataClass
    implements Insertable<WhitelistDbEntry> {
  final String id;
  final String phoneNumber;
  final String displayName;
  final DateTime addedAt;
  const WhitelistDbEntry({
    required this.id,
    required this.phoneNumber,
    required this.displayName,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['display_name'] = Variable<String>(displayName);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  WhitelistTableCompanion toCompanion(bool nullToAbsent) {
    return WhitelistTableCompanion(
      id: Value(id),
      phoneNumber: Value(phoneNumber),
      displayName: Value(displayName),
      addedAt: Value(addedAt),
    );
  }

  factory WhitelistDbEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WhitelistDbEntry(
      id: serializer.fromJson<String>(json['id']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      displayName: serializer.fromJson<String>(json['displayName']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'displayName': serializer.toJson<String>(displayName),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  WhitelistDbEntry copyWith({
    String? id,
    String? phoneNumber,
    String? displayName,
    DateTime? addedAt,
  }) => WhitelistDbEntry(
    id: id ?? this.id,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    displayName: displayName ?? this.displayName,
    addedAt: addedAt ?? this.addedAt,
  );
  WhitelistDbEntry copyWithCompanion(WhitelistTableCompanion data) {
    return WhitelistDbEntry(
      id: data.id.present ? data.id.value : this.id,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WhitelistDbEntry(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('displayName: $displayName, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, phoneNumber, displayName, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WhitelistDbEntry &&
          other.id == this.id &&
          other.phoneNumber == this.phoneNumber &&
          other.displayName == this.displayName &&
          other.addedAt == this.addedAt);
}

class WhitelistTableCompanion extends UpdateCompanion<WhitelistDbEntry> {
  final Value<String> id;
  final Value<String> phoneNumber;
  final Value<String> displayName;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const WhitelistTableCompanion({
    this.id = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.displayName = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WhitelistTableCompanion.insert({
    required String id,
    required String phoneNumber,
    required String displayName,
    required DateTime addedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       phoneNumber = Value(phoneNumber),
       displayName = Value(displayName),
       addedAt = Value(addedAt);
  static Insertable<WhitelistDbEntry> custom({
    Expression<String>? id,
    Expression<String>? phoneNumber,
    Expression<String>? displayName,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (displayName != null) 'display_name': displayName,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WhitelistTableCompanion copyWith({
    Value<String>? id,
    Value<String>? phoneNumber,
    Value<String>? displayName,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return WhitelistTableCompanion(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WhitelistTableCompanion(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('displayName: $displayName, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BusyStatusesTableTable busyStatusesTable =
      $BusyStatusesTableTable(this);
  late final $CallLogsTableTable callLogsTable = $CallLogsTableTable(this);
  late final $WhitelistTableTable whitelistTable = $WhitelistTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    busyStatusesTable,
    callLogsTable,
    whitelistTable,
  ];
}

typedef $$BusyStatusesTableTableCreateCompanionBuilder =
    BusyStatusesTableCompanion Function({
      required String id,
      required String title,
      Value<String> iconKey,
      Value<int> colorValue,
      required int startMinutes,
      required int endMinutes,
      Value<String> repeatDays,
      Value<bool> isOneTime,
      Value<DateTime?> oneTimeDate,
      required String messageTemplate,
      Value<bool> isEnabled,
      Value<int> priority,
      Value<bool> isQuickToggle,
      Value<DateTime?> quickToggleExpiresAt,
      Value<int> rowid,
    });
typedef $$BusyStatusesTableTableUpdateCompanionBuilder =
    BusyStatusesTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> iconKey,
      Value<int> colorValue,
      Value<int> startMinutes,
      Value<int> endMinutes,
      Value<String> repeatDays,
      Value<bool> isOneTime,
      Value<DateTime?> oneTimeDate,
      Value<String> messageTemplate,
      Value<bool> isEnabled,
      Value<int> priority,
      Value<bool> isQuickToggle,
      Value<DateTime?> quickToggleExpiresAt,
      Value<int> rowid,
    });

class $$BusyStatusesTableTableFilterComposer
    extends Composer<_$AppDatabase, $BusyStatusesTableTable> {
  $$BusyStatusesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOneTime => $composableBuilder(
    column: $table.isOneTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get oneTimeDate => $composableBuilder(
    column: $table.oneTimeDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageTemplate => $composableBuilder(
    column: $table.messageTemplate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isQuickToggle => $composableBuilder(
    column: $table.isQuickToggle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get quickToggleExpiresAt => $composableBuilder(
    column: $table.quickToggleExpiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BusyStatusesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BusyStatusesTableTable> {
  $$BusyStatusesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOneTime => $composableBuilder(
    column: $table.isOneTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get oneTimeDate => $composableBuilder(
    column: $table.oneTimeDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageTemplate => $composableBuilder(
    column: $table.messageTemplate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isQuickToggle => $composableBuilder(
    column: $table.isQuickToggle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get quickToggleExpiresAt => $composableBuilder(
    column: $table.quickToggleExpiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BusyStatusesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BusyStatusesTableTable> {
  $$BusyStatusesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOneTime =>
      $composableBuilder(column: $table.isOneTime, builder: (column) => column);

  GeneratedColumn<DateTime> get oneTimeDate => $composableBuilder(
    column: $table.oneTimeDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get messageTemplate => $composableBuilder(
    column: $table.messageTemplate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isQuickToggle => $composableBuilder(
    column: $table.isQuickToggle,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get quickToggleExpiresAt => $composableBuilder(
    column: $table.quickToggleExpiresAt,
    builder: (column) => column,
  );
}

class $$BusyStatusesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BusyStatusesTableTable,
          BusyStatusEntry,
          $$BusyStatusesTableTableFilterComposer,
          $$BusyStatusesTableTableOrderingComposer,
          $$BusyStatusesTableTableAnnotationComposer,
          $$BusyStatusesTableTableCreateCompanionBuilder,
          $$BusyStatusesTableTableUpdateCompanionBuilder,
          (
            BusyStatusEntry,
            BaseReferences<
              _$AppDatabase,
              $BusyStatusesTableTable,
              BusyStatusEntry
            >,
          ),
          BusyStatusEntry,
          PrefetchHooks Function()
        > {
  $$BusyStatusesTableTableTableManager(
    _$AppDatabase db,
    $BusyStatusesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusyStatusesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BusyStatusesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusyStatusesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<int> startMinutes = const Value.absent(),
                Value<int> endMinutes = const Value.absent(),
                Value<String> repeatDays = const Value.absent(),
                Value<bool> isOneTime = const Value.absent(),
                Value<DateTime?> oneTimeDate = const Value.absent(),
                Value<String> messageTemplate = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> isQuickToggle = const Value.absent(),
                Value<DateTime?> quickToggleExpiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BusyStatusesTableCompanion(
                id: id,
                title: title,
                iconKey: iconKey,
                colorValue: colorValue,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                repeatDays: repeatDays,
                isOneTime: isOneTime,
                oneTimeDate: oneTimeDate,
                messageTemplate: messageTemplate,
                isEnabled: isEnabled,
                priority: priority,
                isQuickToggle: isQuickToggle,
                quickToggleExpiresAt: quickToggleExpiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> iconKey = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                required int startMinutes,
                required int endMinutes,
                Value<String> repeatDays = const Value.absent(),
                Value<bool> isOneTime = const Value.absent(),
                Value<DateTime?> oneTimeDate = const Value.absent(),
                required String messageTemplate,
                Value<bool> isEnabled = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> isQuickToggle = const Value.absent(),
                Value<DateTime?> quickToggleExpiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BusyStatusesTableCompanion.insert(
                id: id,
                title: title,
                iconKey: iconKey,
                colorValue: colorValue,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                repeatDays: repeatDays,
                isOneTime: isOneTime,
                oneTimeDate: oneTimeDate,
                messageTemplate: messageTemplate,
                isEnabled: isEnabled,
                priority: priority,
                isQuickToggle: isQuickToggle,
                quickToggleExpiresAt: quickToggleExpiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BusyStatusesTableTable, BusyStatusEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BusyStatusesTableTable,
                    BusyStatusEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BusyStatusesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BusyStatusesTableTable,
      BusyStatusEntry,
      $$BusyStatusesTableTableFilterComposer,
      $$BusyStatusesTableTableOrderingComposer,
      $$BusyStatusesTableTableAnnotationComposer,
      $$BusyStatusesTableTableCreateCompanionBuilder,
      $$BusyStatusesTableTableUpdateCompanionBuilder,
      (
        BusyStatusEntry,
        BaseReferences<_$AppDatabase, $BusyStatusesTableTable, BusyStatusEntry>,
      ),
      BusyStatusEntry,
      PrefetchHooks Function()
    >;
typedef $$CallLogsTableTableCreateCompanionBuilder =
    CallLogsTableCompanion Function({
      required String id,
      required String callerNumber,
      Value<String?> contactName,
      required DateTime callTime,
      required String activeStatusTitle,
      required String messageSent,
      required String smsResult,
      Value<String?> skipOrFailureReason,
      Value<String> callSource,
      Value<int> rowid,
    });
typedef $$CallLogsTableTableUpdateCompanionBuilder =
    CallLogsTableCompanion Function({
      Value<String> id,
      Value<String> callerNumber,
      Value<String?> contactName,
      Value<DateTime> callTime,
      Value<String> activeStatusTitle,
      Value<String> messageSent,
      Value<String> smsResult,
      Value<String?> skipOrFailureReason,
      Value<String> callSource,
      Value<int> rowid,
    });

class $$CallLogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CallLogsTableTable> {
  $$CallLogsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get callerNumber => $composableBuilder(
    column: $table.callerNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get callTime => $composableBuilder(
    column: $table.callTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeStatusTitle => $composableBuilder(
    column: $table.activeStatusTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageSent => $composableBuilder(
    column: $table.messageSent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get smsResult => $composableBuilder(
    column: $table.smsResult,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skipOrFailureReason => $composableBuilder(
    column: $table.skipOrFailureReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get callSource => $composableBuilder(
    column: $table.callSource,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CallLogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CallLogsTableTable> {
  $$CallLogsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get callerNumber => $composableBuilder(
    column: $table.callerNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get callTime => $composableBuilder(
    column: $table.callTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeStatusTitle => $composableBuilder(
    column: $table.activeStatusTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageSent => $composableBuilder(
    column: $table.messageSent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smsResult => $composableBuilder(
    column: $table.smsResult,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skipOrFailureReason => $composableBuilder(
    column: $table.skipOrFailureReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get callSource => $composableBuilder(
    column: $table.callSource,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CallLogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CallLogsTableTable> {
  $$CallLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get callerNumber => $composableBuilder(
    column: $table.callerNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get callTime =>
      $composableBuilder(column: $table.callTime, builder: (column) => column);

  GeneratedColumn<String> get activeStatusTitle => $composableBuilder(
    column: $table.activeStatusTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get messageSent => $composableBuilder(
    column: $table.messageSent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get smsResult =>
      $composableBuilder(column: $table.smsResult, builder: (column) => column);

  GeneratedColumn<String> get skipOrFailureReason => $composableBuilder(
    column: $table.skipOrFailureReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get callSource => $composableBuilder(
    column: $table.callSource,
    builder: (column) => column,
  );
}

class $$CallLogsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CallLogsTableTable,
          CallLogDbEntry,
          $$CallLogsTableTableFilterComposer,
          $$CallLogsTableTableOrderingComposer,
          $$CallLogsTableTableAnnotationComposer,
          $$CallLogsTableTableCreateCompanionBuilder,
          $$CallLogsTableTableUpdateCompanionBuilder,
          (
            CallLogDbEntry,
            BaseReferences<_$AppDatabase, $CallLogsTableTable, CallLogDbEntry>,
          ),
          CallLogDbEntry,
          PrefetchHooks Function()
        > {
  $$CallLogsTableTableTableManager(_$AppDatabase db, $CallLogsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CallLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CallLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CallLogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> callerNumber = const Value.absent(),
                Value<String?> contactName = const Value.absent(),
                Value<DateTime> callTime = const Value.absent(),
                Value<String> activeStatusTitle = const Value.absent(),
                Value<String> messageSent = const Value.absent(),
                Value<String> smsResult = const Value.absent(),
                Value<String?> skipOrFailureReason = const Value.absent(),
                Value<String> callSource = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CallLogsTableCompanion(
                id: id,
                callerNumber: callerNumber,
                contactName: contactName,
                callTime: callTime,
                activeStatusTitle: activeStatusTitle,
                messageSent: messageSent,
                smsResult: smsResult,
                skipOrFailureReason: skipOrFailureReason,
                callSource: callSource,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String callerNumber,
                Value<String?> contactName = const Value.absent(),
                required DateTime callTime,
                required String activeStatusTitle,
                required String messageSent,
                required String smsResult,
                Value<String?> skipOrFailureReason = const Value.absent(),
                Value<String> callSource = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CallLogsTableCompanion.insert(
                id: id,
                callerNumber: callerNumber,
                contactName: contactName,
                callTime: callTime,
                activeStatusTitle: activeStatusTitle,
                messageSent: messageSent,
                smsResult: smsResult,
                skipOrFailureReason: skipOrFailureReason,
                callSource: callSource,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CallLogsTableTable, CallLogDbEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CallLogsTableTable,
                    CallLogDbEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CallLogsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CallLogsTableTable,
      CallLogDbEntry,
      $$CallLogsTableTableFilterComposer,
      $$CallLogsTableTableOrderingComposer,
      $$CallLogsTableTableAnnotationComposer,
      $$CallLogsTableTableCreateCompanionBuilder,
      $$CallLogsTableTableUpdateCompanionBuilder,
      (
        CallLogDbEntry,
        BaseReferences<_$AppDatabase, $CallLogsTableTable, CallLogDbEntry>,
      ),
      CallLogDbEntry,
      PrefetchHooks Function()
    >;
typedef $$WhitelistTableTableCreateCompanionBuilder =
    WhitelistTableCompanion Function({
      required String id,
      required String phoneNumber,
      required String displayName,
      required DateTime addedAt,
      Value<int> rowid,
    });
typedef $$WhitelistTableTableUpdateCompanionBuilder =
    WhitelistTableCompanion Function({
      Value<String> id,
      Value<String> phoneNumber,
      Value<String> displayName,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });

class $$WhitelistTableTableFilterComposer
    extends Composer<_$AppDatabase, $WhitelistTableTable> {
  $$WhitelistTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WhitelistTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WhitelistTableTable> {
  $$WhitelistTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WhitelistTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WhitelistTableTable> {
  $$WhitelistTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$WhitelistTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WhitelistTableTable,
          WhitelistDbEntry,
          $$WhitelistTableTableFilterComposer,
          $$WhitelistTableTableOrderingComposer,
          $$WhitelistTableTableAnnotationComposer,
          $$WhitelistTableTableCreateCompanionBuilder,
          $$WhitelistTableTableUpdateCompanionBuilder,
          (
            WhitelistDbEntry,
            BaseReferences<
              _$AppDatabase,
              $WhitelistTableTable,
              WhitelistDbEntry
            >,
          ),
          WhitelistDbEntry,
          PrefetchHooks Function()
        > {
  $$WhitelistTableTableTableManager(
    _$AppDatabase db,
    $WhitelistTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WhitelistTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WhitelistTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WhitelistTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WhitelistTableCompanion(
                id: id,
                phoneNumber: phoneNumber,
                displayName: displayName,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String phoneNumber,
                required String displayName,
                required DateTime addedAt,
                Value<int> rowid = const Value.absent(),
              }) => WhitelistTableCompanion.insert(
                id: id,
                phoneNumber: phoneNumber,
                displayName: displayName,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WhitelistTableTable, WhitelistDbEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WhitelistTableTable,
                    WhitelistDbEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WhitelistTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WhitelistTableTable,
      WhitelistDbEntry,
      $$WhitelistTableTableFilterComposer,
      $$WhitelistTableTableOrderingComposer,
      $$WhitelistTableTableAnnotationComposer,
      $$WhitelistTableTableCreateCompanionBuilder,
      $$WhitelistTableTableUpdateCompanionBuilder,
      (
        WhitelistDbEntry,
        BaseReferences<_$AppDatabase, $WhitelistTableTable, WhitelistDbEntry>,
      ),
      WhitelistDbEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BusyStatusesTableTableTableManager get busyStatusesTable =>
      $$BusyStatusesTableTableTableManager(_db, _db.busyStatusesTable);
  $$CallLogsTableTableTableManager get callLogsTable =>
      $$CallLogsTableTableTableManager(_db, _db.callLogsTable);
  $$WhitelistTableTableTableManager get whitelistTable =>
      $$WhitelistTableTableTableManager(_db, _db.whitelistTable);
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/preset_statuses.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/utils/time_utils.dart';
import '../../../domain/entities/busy_status.dart';
import '../../providers/busy_status_provider.dart';
import '../../providers/database_provider.dart';

class AddEditStatusScreen extends ConsumerStatefulWidget {
  final BusyStatus? existingStatus;

  const AddEditStatusScreen({super.key, this.existingStatus});

  @override
  ConsumerState<AddEditStatusScreen> createState() =>
      _AddEditStatusScreenState();
}

class _AddEditStatusScreenState extends ConsumerState<AddEditStatusScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _templateController;

  late int _startMinutes;
  late int _endMinutes;
  late List<int> _repeatDays;
  late bool _isOneTime;
  DateTime? _oneTimeDate;
  late String _iconKey;
  late int _colorValue;
  late int _priority;

  @override
  void initState() {
    super.initState();
    final s = widget.existingStatus;
    if (s != null) {
      _titleController = TextEditingController(text: s.title);
      _templateController = TextEditingController(text: s.messageTemplate);
      _startMinutes = s.startMinutes;
      _endMinutes = s.endMinutes;
      _repeatDays = List.from(s.repeatDays);
      _isOneTime = s.isOneTime;
      _oneTimeDate = s.oneTimeDate;
      _iconKey = s.iconKey;
      _colorValue = s.colorValue;
      _priority = s.priority;
    } else {
      _titleController = TextEditingController();
      _templateController = TextEditingController(
        text: 'Ami {status} a aci, {duration} min por call divo.',
      );
      _startMinutes = 13 * 60 + 0; // 01:00 PM
      _endMinutes = 14 * 60 + 0;   // 02:00 PM
      _repeatDays = [1, 2, 3, 4, 5, 6, 7];
      _isOneTime = false;
      _oneTimeDate = null;
      _iconKey = 'general';
      _colorValue = AppColors.presetColors.first;
      _priority = 5;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _templateController.dispose();
    super.dispose();
  }

  void _applyPreset(StatusPreset preset) {
    final isBn = context.isBangla;
    setState(() {
      _titleController.text = isBn ? preset.titleBn : preset.titleEn;
      _templateController.text =
          isBn ? preset.defaultTemplateBn : preset.defaultTemplateEn;
      _iconKey = preset.iconKey;
      _colorValue = preset.colorValue;
      _startMinutes = preset.defaultStartMinutes;
      _endMinutes = preset.defaultEndMinutes;
      _priority = preset.priority;
    });
  }

  void _insertVariable(String variable) {
    final text = _templateController.text;
    final selection = _templateController.selection;
    if (selection.start >= 0 && selection.end >= 0) {
      final newText = text.replaceRange(selection.start, selection.end, variable);
      _templateController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
            offset: selection.start + variable.length),
      );
    } else {
      _templateController.text = '$text $variable';
    }
    setState(() {});
  }

  Future<void> _pickStartTime() async {
    final initial = TimeOfDay(
      hour: _startMinutes ~/ 60,
      minute: _startMinutes % 60,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() {
        _startMinutes = picked.hour * 60 + picked.minute;
      });
    }
  }

  Future<void> _pickEndTime() async {
    final initial = TimeOfDay(
      hour: _endMinutes ~/ 60,
      minute: _endMinutes % 60,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() {
        _endMinutes = picked.hour * 60 + picked.minute;
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _oneTimeDate ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _oneTimeDate = picked;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.existingStatus?.id ?? const Uuid().v4();
    final status = BusyStatus(
      id: id,
      title: _titleController.text.trim(),
      iconKey: _iconKey,
      colorValue: _colorValue,
      startMinutes: _startMinutes,
      endMinutes: _endMinutes,
      repeatDays: _repeatDays,
      isOneTime: _isOneTime,
      oneTimeDate: _isOneTime ? (_oneTimeDate ?? DateTime.now()) : null,
      messageTemplate: _templateController.text.trim(),
      isEnabled: widget.existingStatus?.isEnabled ?? true,
      priority: _priority,
    );

    final notifier = ref.read(busyStatusNotifierProvider.notifier);
    if (widget.existingStatus != null) {
      notifier.updateStatus(status);
    } else {
      notifier.addStatus(status);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isBn = context.isBangla;
    final isEditing = widget.existingStatus != null;

    final iconsList = [
      ('mosque', Icons.mosque),
      ('bed', Icons.bedtime),
      ('meeting', Icons.business_center),
      ('sick', Icons.local_hospital),
      ('car', Icons.directions_car),
      ('gym', Icons.fitness_center),
      ('study', Icons.menu_book),
      ('clock', Icons.access_time_filled),
      ('general', Icons.notifications_off),
    ];

    // Compute live preview string
    final dummyStatus = BusyStatus(
      id: 'preview',
      title: _titleController.text.trim().isNotEmpty
          ? _titleController.text.trim()
          : (isBn ? 'নামাজ' : 'Prayer'),
      iconKey: _iconKey,
      colorValue: _colorValue,
      startMinutes: _startMinutes,
      endMinutes: _endMinutes,
      messageTemplate: _templateController.text,
    );

    final previewMessage = ref.watch(formatReplyMessageUseCaseProvider).execute(
          status: dummyStatus,
          callTime: DateTime.now(),
          callerName: isBn ? 'রহিম' : 'John',
          isBangla: isBn,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing
            ? context.tr('edit_status')
            : context.tr('add_status')),
        actions: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.check_rounded),
            tooltip: context.tr('save_button'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Presets selector
              if (!isEditing) ...[
                Text(
                  context.tr('presets_button'),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: PresetStatuses.presets.map((preset) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          avatar: Icon(
                            PresetStatuses.getIcon(preset.iconKey),
                            size: 16,
                            color: Color(preset.colorValue),
                          ),
                          label: Text(
                            isBn ? preset.titleBn : preset.titleEn,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () => _applyPreset(preset),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Title input
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: context.tr('title_label'),
                  hintText: context.tr('title_hint'),
                  prefixIcon: const Icon(Icons.edit_rounded),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),

              // Icon & Color Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Picker
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Icon',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.withAlpha(40)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _iconKey,
                              isExpanded: true,
                              items: iconsList.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item.$1,
                                  child: Row(
                                    children: [
                                      Icon(item.$2,
                                          size: 20, color: Color(_colorValue)),
                                      const SizedBox(width: 8),
                                      Text(
                                        item.$1,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _iconKey = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Color Picker
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Color',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: AppColors.presetColors.map((c) {
                              final isSelected = _colorValue == c;
                              return GestureDetector(
                                onTap: () => setState(() => _colorValue = c),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Color(c),
                                    shape: BoxShape.circle,
                                    border: isSelected
                                        ? Border.all(
                                            color: Colors.white, width: 2)
                                        : null,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Color(c).withAlpha(120),
                                              blurRadius: 6,
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check,
                                          color: Colors.white, size: 16)
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Time Selection (Start & End Time)
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: _pickStartTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.grey.withAlpha(40)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr('start_time'),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded,
                                    size: 18, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  TimeUtils.formatMinutesTo12Hour(_startMinutes,
                                      isBangla: isBn),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: _pickEndTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.grey.withAlpha(40)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr('end_time'),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.access_time_filled_rounded,
                                    size: 18, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  TimeUtils.formatMinutesTo12Hour(_endMinutes,
                                      isBangla: isBn),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // One-Time toggle
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  context.tr('is_one_time'),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                value: _isOneTime,
                onChanged: (val) {
                  setState(() {
                    _isOneTime = val;
                    if (val && _oneTimeDate == null) {
                      _oneTimeDate = DateTime.now();
                    }
                  });
                },
                activeThumbColor: AppColors.primary,
              ),

              if (_isOneTime) ...[
                const SizedBox(height: 6),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: Colors.grey.withAlpha(40)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded,
                            size: 20, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Text(
                          _oneTimeDate != null
                              ? '${_oneTimeDate!.day}/${_oneTimeDate!.month}/${_oneTimeDate!.year}'
                              : 'Select Date',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right_rounded,
                            color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ] else ...[
                // Repeat Days selector (Saturday to Friday)
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('repeat_days'),
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() => _repeatDays = [1, 2, 3, 4, 5, 6, 7]);
                          },
                          child: Text(context.tr('all_days'),
                              style: const TextStyle(fontSize: 11)),
                        ),
                        TextButton(
                          onPressed: () {
                            // Weekdays: Sat to Wed in BD, or Mon to Fri
                            setState(() => _repeatDays = [1, 2, 3, 4, 5]);
                          },
                          child: Text(context.tr('weekdays'),
                              style: const TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [1, 2, 3, 4, 5, 6, 7].map((day) {
                    final isSelected = _repeatDays.contains(day);
                    return FilterChip(
                      label: Text(
                        TimeUtils.appWeekdayName(day, isBangla: isBn),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : null,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _repeatDays.add(day);
                          } else {
                            if (_repeatDays.length > 1) {
                              _repeatDays.remove(day);
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],

              // Message Template Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('message_template'),
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _templateController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: context.tr('template_hint'),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Message template is required';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),

              // Interactive Variable Chips
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    context.tr('insert_variable'),
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600),
                  ),
                  ActionChip(
                    label: const Text('{status}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () => _insertVariable('{status}'),
                  ),
                  ActionChip(
                    label: const Text('{duration}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () => _insertVariable('{duration}'),
                  ),
                  ActionChip(
                    label: const Text('{return_time}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () => _insertVariable('{return_time}'),
                  ),
                  ActionChip(
                    label: const Text('{caller_name}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () => _insertVariable('{caller_name}'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Live SMS Preview Card
              Text(
                context.tr('preview_label'),
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.primary.withAlpha(50)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.chat_bubble_outline_rounded,
                        size: 20, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        previewMessage,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Priority Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('priority_label'),
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<int>(
                    value: _priority >= 10 ? 10 : 5,
                    items: [
                      DropdownMenuItem(
                        value: 5,
                        child: Text(context.tr('priority_normal')),
                      ),
                      DropdownMenuItem(
                        value: 10,
                        child: Text(context.tr('priority_high')),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _priority = val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save Button
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_rounded),
                label: Text(context.tr('save_button')),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/event.dart';
import '../utils/date_utils.dart';

const List<int> kEventColors = <int>[
  0xFF6750A4,
  0xFF1B72E8,
  0xFF1E8E3E,
  0xFFE8710A,
  0xFFD93025,
  0xFF8E24AA,
];

/// Bottom sheet used for both creating and editing an event.
/// Returns the edited [Event] via `Navigator.pop`, or null if cancelled.
class EventEditorSheet extends StatefulWidget {
  const EventEditorSheet({super.key, required this.day, this.existing, required this.idBuilder});

  final DateTime day;
  final Event? existing;
  final String Function() idBuilder;

  @override
  State<EventEditorSheet> createState() => _EventEditorSheetState();
}

class _EventEditorSheetState extends State<EventEditorSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _date;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late bool _allDay;
  late int _colorValue;

  @override
  void initState() {
    super.initState();
    final Event? existing = widget.existing;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _descriptionController = TextEditingController(text: existing?.description ?? '');
    _date = dateOnly(existing?.start ?? widget.day);
    _startTime = TimeOfDay.fromDateTime(existing?.start ?? _defaultStart());
    _endTime = TimeOfDay.fromDateTime(existing?.end ?? _defaultStart().add(const Duration(hours: 1)));
    _allDay = existing?.allDay ?? false;
    _colorValue = existing?.colorValue ?? kEventColors.first;
  }

  DateTime _defaultStart() {
    final DateTime now = DateTime.now();
    return DateTime(_date.year, _date.month, _date.day, now.hour + 1);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  DateTime _combine(TimeOfDay time) =>
      DateTime(_date.year, _date.month, _date.day, time.hour, time.minute);

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = dateOnly(picked));
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked == null) {
      return;
    }
    setState(() {
      if (isStart) {
        _startTime = picked;
        if (_combine(_endTime).isBefore(_combine(picked))) {
          _endTime = TimeOfDay(hour: (picked.hour + 1) % 24, minute: picked.minute);
        }
      } else {
        _endTime = picked;
      }
    });
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final DateTime start = _allDay
        ? DateTime(_date.year, _date.month, _date.day)
        : _combine(_startTime);
    final DateTime end = _allDay
        ? DateTime(_date.year, _date.month, _date.day, 23, 59)
        : _combine(_endTime);

    if (end.isBefore(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after the start time')),
      );
      return;
    }

    Navigator.of(context).pop(
      Event(
        id: widget.existing?.id ?? widget.idBuilder(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        start: start,
        end: end,
        allDay: _allDay,
        colorValue: _colorValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.existing != null;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              isEditing ? 'Edit event' : 'New event',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              autofocus: !isEditing,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (String? value) =>
                  (value == null || value.trim().isEmpty) ? 'Title is required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(formatFullDate(_date)),
              trailing: TextButton(onPressed: _pickDate, child: const Text('Change')),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _allDay,
              title: const Text('All day'),
              onChanged: (bool value) => setState(() => _allDay = value),
            ),
            if (!_allDay)
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickTime(isStart: true),
                      icon: const Icon(Icons.schedule),
                      label: Text(_startTime.format(context)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickTime(isStart: false),
                      icon: const Icon(Icons.schedule_outlined),
                      label: Text(_endTime.format(context)),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Row(
              children: kEventColors.map((int value) {
                final bool selected = value == _colorValue;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => setState(() => _colorValue = value),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(value),
                        shape: BoxShape.circle,
                        border: selected
                            ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 2)
                            : null,
                      ),
                    ),
                  ),
                );
              }).toList(growable: false),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _submit,
              child: Text(isEditing ? 'Save changes' : 'Add event'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

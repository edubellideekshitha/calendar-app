import 'package:flutter/foundation.dart';

import '../models/event.dart';
import '../services/event_repository.dart';
import '../utils/date_utils.dart';

/// Single source of truth for the calendar screen.
///
/// Holds the focused month, the selected day and every event, and keeps a
/// day-keyed index so the month grid can look up a day's events in O(1).
class CalendarController extends ChangeNotifier {
  CalendarController(this._repository, {DateTime? initialDate}) {
    final DateTime now = initialDate ?? DateTime.now();
    _focusedMonth = firstDayOfMonth(now);
    _selectedDay = dateOnly(now);
  }

  final EventRepository _repository;

  final List<Event> _events = <Event>[];
  final Map<String, List<Event>> _index = <String, List<Event>>{};

  late DateTime _focusedMonth;
  late DateTime _selectedDay;
  bool _isLoading = true;

  DateTime get focusedMonth => _focusedMonth;
  DateTime get selectedDay => _selectedDay;
  bool get isLoading => _isLoading;
  List<Event> get allEvents => List<Event>.unmodifiable(_events);

  List<DateTime> get monthGrid => buildMonthGrid(_focusedMonth);

  /// Events on [day], sorted by start time.
  List<Event> eventsOn(DateTime day) =>
      List<Event>.unmodifiable(_index[_keyFor(day)] ?? const <Event>[]);

  List<Event> get selectedDayEvents => eventsOn(_selectedDay);

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _events
      ..clear()
      ..addAll(await _repository.loadAll());
    _rebuildIndex();
    _isLoading = false;
    notifyListeners();
  }

  void selectDay(DateTime day) {
    _selectedDay = dateOnly(day);
    if (!isSameMonth(_selectedDay, _focusedMonth)) {
      _focusedMonth = firstDayOfMonth(_selectedDay);
    }
    notifyListeners();
  }

  void focusMonth(DateTime month) {
    _focusedMonth = firstDayOfMonth(month);
    notifyListeners();
  }

  void nextMonth() => focusMonth(addMonths(_focusedMonth, 1));

  void previousMonth() => focusMonth(addMonths(_focusedMonth, -1));

  void goToToday() => selectDay(DateTime.now());

  /// Inserts a new event or replaces the existing one with the same id.
  Future<void> upsert(Event event) async {
    final int existing = _events.indexWhere((Event e) => e.id == event.id);
    if (existing >= 0) {
      _events[existing] = event;
    } else {
      _events.add(event);
    }
    _rebuildIndex();
    notifyListeners();
    await _repository.saveAll(_events);
  }

  Future<void> delete(String id) async {
    _events.removeWhere((Event e) => e.id == id);
    _rebuildIndex();
    notifyListeners();
    await _repository.saveAll(_events);
  }

  /// Generates an id that is unique enough for a local-only store.
  String newId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${_events.length}';

  String _keyFor(DateTime day) =>
      '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

  void _rebuildIndex() {
    _index.clear();
    for (final Event event in _events) {
      _index.putIfAbsent(_keyFor(event.day), () => <Event>[]).add(event);
    }
    for (final List<Event> bucket in _index.values) {
      bucket.sort((Event a, Event b) => a.start.compareTo(b.start));
    }
  }
}

import 'package:shared_preferences/shared_preferences.dart';

import '../models/event.dart';

/// Storage contract for events. Swap the implementation to move from local
/// storage to a REST API or SQLite without touching the UI or state layer.
abstract class EventRepository {
  Future<List<Event>> loadAll();
  Future<void> saveAll(List<Event> events);
}

/// Persists events as a single JSON string in SharedPreferences.
/// Fine for hundreds of events; move to SQLite (drift/sqflite) beyond that.
class SharedPrefsEventRepository implements EventRepository {
  SharedPrefsEventRepository({this.storageKey = 'calendar.events.v1'});

  final String storageKey;

  @override
  Future<List<Event>> loadAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) {
      return <Event>[];
    }
    try {
      return Event.decodeList(raw);
    } on FormatException {
      // Corrupted payload: start clean rather than crash on launch.
      await prefs.remove(storageKey);
      return <Event>[];
    }
  }

  @override
  Future<void> saveAll(List<Event> events) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, Event.encodeList(events));
  }
}

/// In-memory implementation used by tests and previews.
class InMemoryEventRepository implements EventRepository {
  InMemoryEventRepository([List<Event>? seed]) : _events = <Event>[...?seed];

  List<Event> _events;

  @override
  Future<List<Event>> loadAll() async => List<Event>.unmodifiable(_events);

  @override
  Future<void> saveAll(List<Event> events) async {
    _events = <Event>[...events];
  }
}

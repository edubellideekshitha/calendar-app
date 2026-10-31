import 'dart:convert';

import '../utils/date_utils.dart';

/// A single calendar entry. Immutable: edits produce a new instance via
/// [copyWith] so the state layer can diff cheaply.
class Event {
  const Event({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.description = '',
    this.allDay = false,
    this.colorValue = 0xFF6750A4,
  });

  final String id;
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;
  final bool allDay;
  final int colorValue;

  /// The calendar day this event is filed under.
  DateTime get day => dateOnly(start);

  Duration get duration => end.difference(start);

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? start,
    DateTime? end,
    bool? allDay,
    int? colorValue,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      allDay: allDay ?? this.allDay,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'description': description,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'allDay': allDay,
        'colorValue': colorValue,
      };

  factory Event.fromJson(Map<String, dynamic> json) {
    final DateTime start = DateTime.parse(json['start'] as String);
    return Event(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      start: start,
      end: json['end'] == null ? start : DateTime.parse(json['end'] as String),
      allDay: json['allDay'] as bool? ?? false,
      colorValue: json['colorValue'] as int? ?? 0xFF6750A4,
    );
  }

  static String encodeList(List<Event> events) =>
      jsonEncode(events.map((Event e) => e.toJson()).toList());

  static List<Event> decodeList(String source) {
    final List<dynamic> raw = jsonDecode(source) as List<dynamic>;
    return raw
        .map((dynamic e) => Event.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  bool operator ==(Object other) => other is Event && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Event($id, $title, $start)';
}

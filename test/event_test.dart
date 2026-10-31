import 'package:flutter_calendar/models/event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Event sample = Event(
    id: 'e1',
    title: 'Standup',
    description: 'Daily sync',
    start: DateTime(2026, 9, 17, 9, 30),
    end: DateTime(2026, 9, 17, 10),
  );

  test('round-trips through JSON', () {
    final Event decoded = Event.fromJson(sample.toJson());
    expect(decoded.id, sample.id);
    expect(decoded.title, sample.title);
    expect(decoded.start, sample.start);
    expect(decoded.end, sample.end);
    expect(decoded.colorValue, sample.colorValue);
  });

  test('encodes and decodes a list', () {
    final String encoded = Event.encodeList(<Event>[sample]);
    expect(Event.decodeList(encoded).single, sample);
  });

  test('copyWith replaces only the given fields', () {
    final Event updated = sample.copyWith(title: 'Retro');
    expect(updated.title, 'Retro');
    expect(updated.start, sample.start);
  });

  test('day strips the time component', () {
    expect(sample.day, DateTime(2026, 9, 17));
  });
}

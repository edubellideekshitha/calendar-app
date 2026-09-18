import 'package:flutter_calendar/models/event.dart';
import 'package:flutter_calendar/services/event_repository.dart';
import 'package:flutter_calendar/state/calendar_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemoryEventRepository repository;
  late CalendarController controller;

  setUp(() async {
    repository = InMemoryEventRepository();
    controller = CalendarController(repository, initialDate: DateTime(2026, 9, 17));
    await controller.load();
  });

  test('starts with no events', () {
    expect(controller.selectedDayEvents, isEmpty);
    expect(controller.isLoading, isFalse);
  });

  test('upsert adds then updates an event', () async {
    final Event event = Event(
      id: 'a',
      title: 'Dentist',
      start: DateTime(2026, 9, 17, 11),
      end: DateTime(2026, 9, 17, 12),
    );
    await controller.upsert(event);
    expect(controller.selectedDayEvents.single.title, 'Dentist');

    await controller.upsert(event.copyWith(title: 'Dentist (moved)'));
    expect(controller.selectedDayEvents.length, 1);
    expect(controller.selectedDayEvents.single.title, 'Dentist (moved)');
  });

  test('events are sorted by start time', () async {
    await controller.upsert(Event(
      id: 'late',
      title: 'Late',
      start: DateTime(2026, 9, 17, 16),
      end: DateTime(2026, 9, 17, 17),
    ));
    await controller.upsert(Event(
      id: 'early',
      title: 'Early',
      start: DateTime(2026, 9, 17, 8),
      end: DateTime(2026, 9, 17, 9),
    ));
    expect(
      controller.selectedDayEvents.map((Event e) => e.id).toList(),
      <String>['early', 'late'],
    );
  });

  test('delete removes the event and persists', () async {
    await controller.upsert(Event(
      id: 'a',
      title: 'Gone',
      start: DateTime(2026, 9, 17, 9),
      end: DateTime(2026, 9, 17, 10),
    ));
    await controller.delete('a');
    expect(controller.selectedDayEvents, isEmpty);
    expect(await repository.loadAll(), isEmpty);
  });

  test('selecting a day in another month moves the focused month', () {
    controller.selectDay(DateTime(2026, 11, 3));
    expect(controller.focusedMonth, DateTime(2026, 11, 1));
  });

  test('nextMonth and previousMonth are symmetric', () {
    controller.nextMonth();
    expect(controller.focusedMonth, DateTime(2026, 10, 1));
    controller.previousMonth();
    expect(controller.focusedMonth, DateTime(2026, 9, 1));
  });
}

# Architecture

## Layers

```
UI widgets  ->  CalendarController (ChangeNotifier)  ->  EventRepository  ->  storage
```

1. **UI** (`screens/`, `widgets/`) is stateless apart from local form state in the
   editor sheet. It reads state with `context.watch<CalendarController>()` and
   fires intents with `context.read<CalendarController>()`.
2. **State** (`state/calendar_controller.dart`) owns the focused month, the
   selected day and the event list. It keeps a `Map<String, List<Event>>` index
   keyed by `yyyy-MM-dd` so the grid can ask "what's on this day?" 42 times per
   build without scanning the list.
3. **Data** (`services/event_repository.dart`) is an interface with two
   implementations: `SharedPrefsEventRepository` (production) and
   `InMemoryEventRepository` (tests). Adding Firebase or REST sync means writing
   a third implementation — no UI changes.

## Why `provider` and not Bloc/Riverpod

The app has one screen and one piece of shared state. `ChangeNotifier` keeps the
dependency footprint small and the code readable. If you add week/day views,
filters and sync, Riverpod or Bloc becomes worth the extra ceremony.

## Data model

```dart
Event(id, title, description, start, end, allDay, colorValue)
```

- `start`/`end` are full `DateTime`s. An all-day event is stored as
  00:00 -> 23:59 on the same day with `allDay: true`.
- `day` (derived) is `start` with the time stripped; it's the grid bucket key.
- Equality is by `id` only, so `List.remove` and `Dismissible` keys behave.

## Month grid maths

`buildMonthGrid` always returns 42 dates (6 weeks x 7 days), so the grid height
never jumps between months. The leading offset is
`(firstOfMonth.weekday - firstWeekday + 7) % 7`. Dates are built with
`DateTime(year, month, day + i)` rather than `Duration(days: i)` so daylight
saving transitions cannot shift a cell into the wrong day.

`addMonths` clamps the day to the target month length, so 31 January + 1 month
is 28 February rather than 3 March.

## Persistence format

All events are serialized to one JSON array under the key
`calendar.events.v1`. A corrupted payload is discarded on read instead of
crashing at launch. The key carries a version suffix so a future migration can
read `v1`, transform and write `v2`.

This is fine into the hundreds of events. Past that, switch to `sqflite` or
`drift` and implement `EventRepository` against it.

## Testing strategy

- `date_utils_test.dart` — grid shape, leap years, month arithmetic
- `event_test.dart` — JSON round-trip and `copyWith`
- `calendar_controller_test.dart` — CRUD, sorting, selection side effects
- `widget_test.dart` — renders the month, shows events, month navigation

All state tests run against `InMemoryEventRepository`, so they need no plugin
mocks and run on any CI machine.

## Known limits

- Multi-day events are filed under their start day only.
- No recurrence, no reminders, no time zone handling beyond device local time.
- Storage is per-device with no sync or backup.

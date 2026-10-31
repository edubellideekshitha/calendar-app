import 'package:flutter_calendar/utils/date_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildMonthGrid', () {
    test('returns 42 cells', () {
      expect(buildMonthGrid(DateTime(2026, 9)).length, 42);
    });

    test('starts on the configured first weekday', () {
      final List<DateTime> grid = buildMonthGrid(DateTime(2026, 9));
      expect(grid.first.weekday, DateTime.monday);
    });

    test('includes leading days from the previous month', () {
      // 1 Sep 2026 is a Tuesday, so the grid starts on 31 Aug.
      final List<DateTime> grid = buildMonthGrid(DateTime(2026, 9));
      expect(grid.first, DateTime(2026, 8, 31));
    });
  });

  group('addMonths', () {
    test('clamps the day to the target month length', () {
      expect(addMonths(DateTime(2026, 1, 31), 1), DateTime(2026, 2, 28));
    });

    test('rolls the year over', () {
      expect(addMonths(DateTime(2026, 12, 5), 1), DateTime(2027, 1, 5));
      expect(addMonths(DateTime(2026, 1, 5), -1), DateTime(2025, 12, 5));
    });
  });

  test('daysInMonth handles leap years', () {
    expect(daysInMonth(2024, 2), 29);
    expect(daysInMonth(2026, 2), 28);
  });

  test('isSameDay ignores the time component', () {
    expect(isSameDay(DateTime(2026, 9, 17, 9), DateTime(2026, 9, 17, 23)), isTrue);
    expect(isSameDay(DateTime(2026, 9, 17), DateTime(2026, 9, 18)), isFalse);
  });
}

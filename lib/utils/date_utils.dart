import 'package:intl/intl.dart';

/// Number of cells in a month grid: 6 rows x 7 columns.
const int kMonthGridCellCount = 42;

/// Strips the time component so two dates can be compared by calendar day.
DateTime dateOnly(DateTime value) => DateTime(value.year, value.month, value.day);

/// First day of the month that [value] falls in.
DateTime firstDayOfMonth(DateTime value) => DateTime(value.year, value.month, 1);

/// Adds [delta] months, clamping the day so 31 Jan + 1 month => 28/29 Feb.
DateTime addMonths(DateTime value, int delta) {
  final int totalMonths = value.year * 12 + (value.month - 1) + delta;
  final int year = totalMonths ~/ 12;
  final int month = totalMonths % 12 + 1;
  final int lastDay = daysInMonth(year, month);
  return DateTime(year, month, value.day > lastDay ? lastDay : value.day);
}

/// Number of days in the given month.
int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

bool isSameMonth(DateTime a, DateTime b) => a.year == b.year && a.month == b.month;

bool isToday(DateTime value) => isSameDay(value, DateTime.now());

/// Builds the 42 dates shown in a month view, including the leading and
/// trailing days that belong to the neighbouring months.
List<DateTime> buildMonthGrid(DateTime month, {int firstWeekday = DateTime.monday}) {
  final DateTime first = firstDayOfMonth(month);
  final int offset = (first.weekday - firstWeekday + 7) % 7;
  final DateTime start = DateTime(first.year, first.month, first.day - offset);
  return List<DateTime>.generate(
    kMonthGridCellCount,
    (int i) => DateTime(start.year, start.month, start.day + i),
  );
}

/// Short weekday labels ("Mon", "Tue", ...) ordered from [firstWeekday].
List<String> weekdayLabels({int firstWeekday = DateTime.monday, String? locale}) {
  // 2024-01-01 was a Monday; use it as a stable reference week.
  final DateTime reference = DateTime(2024, 1, 1);
  final DateFormat format = DateFormat.E(locale);
  return List<String>.generate(7, (int i) {
    final int weekday = (firstWeekday - DateTime.monday + i) % 7;
    return format.format(DateTime(reference.year, reference.month, reference.day + weekday));
  });
}

String formatMonthYear(DateTime value, {String? locale}) =>
    DateFormat.yMMMM(locale).format(value);

String formatFullDate(DateTime value, {String? locale}) =>
    DateFormat.yMMMMEEEEd(locale).format(value);

String formatTime(DateTime value, {String? locale}) => DateFormat.jm(locale).format(value);

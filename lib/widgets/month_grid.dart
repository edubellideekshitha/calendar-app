import 'package:flutter/material.dart';

import '../models/event.dart';
import '../utils/date_utils.dart';
import 'day_cell.dart';

/// 6x7 grid of [DayCell]s for the focused month.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    super.key,
    required this.month,
    required this.selectedDay,
    required this.eventsForDay,
    required this.onDaySelected,
  });

  final DateTime month;
  final DateTime selectedDay;
  final List<Event> Function(DateTime day) eventsForDay;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final List<DateTime> days = buildMonthGrid(month);
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: days.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (BuildContext context, int index) {
        final DateTime date = days[index];
        return DayCell(
          date: date,
          isSelected: isSameDay(date, selectedDay),
          isOutsideMonth: !isSameMonth(date, month),
          events: eventsForDay(date),
          onTap: () => onDaySelected(date),
        );
      },
    );
  }
}

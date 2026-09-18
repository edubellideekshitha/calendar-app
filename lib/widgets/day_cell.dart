import 'package:flutter/material.dart';

import '../models/event.dart';
import '../utils/date_utils.dart';

/// One square in the month grid: the day number plus up to three event dots.
class DayCell extends StatelessWidget {
  const DayCell({
    super.key,
    required this.date,
    required this.isSelected,
    required this.isOutsideMonth,
    required this.events,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool isOutsideMonth;
  final List<Event> events;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final bool today = isToday(date);

    Color labelColor = colors.onSurface;
    if (isOutsideMonth) {
      labelColor = colors.onSurfaceVariant.withOpacity(0.45);
    }
    if (isSelected) {
      labelColor = colors.onPrimary;
    } else if (today) {
      labelColor = colors.primary;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Semantics(
        selected: isSelected,
        label: formatFullDate(date),
        button: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? colors.primary : Colors.transparent,
                border: today && !isSelected
                    ? Border.all(color: colors.primary, width: 1.5)
                    : null,
              ),
              child: Text(
                '${date.day}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: labelColor,
                  fontWeight: today || isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: events.take(3).map((Event event) {
                  return Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? colors.onPrimary : Color(event.colorValue),
                    ),
                  );
                }).toList(growable: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

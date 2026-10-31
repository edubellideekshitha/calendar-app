import 'package:flutter/material.dart';

import '../utils/date_utils.dart';

/// Row of short weekday names above the month grid.
class WeekdayStrip extends StatelessWidget {
  const WeekdayStrip({super.key, this.firstWeekday = DateTime.monday});

  final int firstWeekday;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<String> labels = weekdayLabels(firstWeekday: firstWeekday);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: labels
            .map(
              (String label) => Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/event.dart';
import '../utils/date_utils.dart';

/// Agenda for the selected day, shown under the month grid.
class EventListPanel extends StatelessWidget {
  const EventListPanel({
    super.key,
    required this.day,
    required this.events,
    required this.onEdit,
    required this.onDelete,
  });

  final DateTime day;
  final List<Event> events;
  final ValueChanged<Event> onEdit;
  final ValueChanged<Event> onDelete;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(formatFullDate(day), style: theme.textTheme.titleMedium),
        ),
        const Divider(height: 1),
        Expanded(
          child: events.isEmpty
              ? _EmptyState(theme: theme)
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
                  itemBuilder: (BuildContext context, int index) {
                    final Event event = events[index];
                    return Dismissible(
                      key: ValueKey<String>(event.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        color: theme.colorScheme.errorContainer,
                        child: Icon(Icons.delete_outline,
                            color: theme.colorScheme.onErrorContainer),
                      ),
                      onDismissed: (_) => onDelete(event),
                      child: ListTile(
                        leading: Container(
                          width: 6,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(event.colorValue),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        title: Text(event.title),
                        subtitle: Text(
                          event.allDay
                              ? 'All day'
                              : '${formatTime(event.start)} – ${formatTime(event.end)}'
                                  '${event.description.isEmpty ? '' : '\n${event.description}'}',
                        ),
                        isThreeLine: !event.allDay && event.description.isNotEmpty,
                        onTap: () => onEdit(event),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.event_available_outlined,
              size: 40, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 8),
          Text('No events', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            'Tap + to add one',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

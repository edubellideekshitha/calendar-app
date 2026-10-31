import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../state/calendar_controller.dart';
import '../utils/date_utils.dart';
import '../widgets/event_editor_sheet.dart';
import '../widgets/event_list_panel.dart';
import '../widgets/month_grid.dart';
import '../widgets/month_header.dart';
import '../widgets/weekday_strip.dart';

/// Month view on top, agenda for the selected day below.
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  Future<void> _openEditor(BuildContext context, {Event? existing}) async {
    final CalendarController controller = context.read<CalendarController>();
    final Event? result = await showModalBottomSheet<Event>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext sheetContext) => EventEditorSheet(
        day: controller.selectedDay,
        existing: existing,
        idBuilder: controller.newId,
      ),
    );
    if (result != null) {
      await controller.upsert(result);
      controller.selectDay(result.day);
    }
  }

  Future<void> _delete(BuildContext context, Event event) async {
    final CalendarController controller = context.read<CalendarController>();
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    await controller.delete(event.id);
    messenger.showSnackBar(
      SnackBar(
        content: Text('Deleted "${event.title}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => controller.upsert(event),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CalendarController controller = context.watch<CalendarController>();

    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            MonthHeader(
              month: controller.focusedMonth,
              onPrevious: controller.previousMonth,
              onNext: controller.nextMonth,
              onToday: controller.goToToday,
            ),
            const WeekdayStrip(),
            GestureDetector(
              onHorizontalDragEnd: (DragEndDetails details) {
                final double velocity = details.primaryVelocity ?? 0;
                if (velocity < -200) {
                  controller.nextMonth();
                } else if (velocity > 200) {
                  controller.previousMonth();
                }
              },
              child: MonthGrid(
                month: controller.focusedMonth,
                selectedDay: controller.selectedDay,
                eventsForDay: controller.eventsOn,
                onDaySelected: controller.selectDay,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: EventListPanel(
                day: controller.selectedDay,
                events: controller.selectedDayEvents,
                onEdit: (Event event) => _openEditor(context, existing: event),
                onDelete: (Event event) => _delete(context, event),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add),
        label: Text(isToday(controller.selectedDay) ? 'Add today' : 'Add event'),
      ),
    );
  }
}

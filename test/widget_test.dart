import 'package:flutter/material.dart';
import 'package:flutter_calendar/app.dart';
import 'package:flutter_calendar/models/event.dart';
import 'package:flutter_calendar/services/event_repository.dart';
import 'package:flutter_calendar/state/calendar_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Future<void> pumpApp(WidgetTester tester, CalendarController controller) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<CalendarController>.value(
      value: controller,
      child: const CalendarApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders the month grid and empty agenda', (WidgetTester tester) async {
    final CalendarController controller = CalendarController(
      InMemoryEventRepository(),
      initialDate: DateTime(2026, 9, 17),
    );
    await controller.load();
    await pumpApp(tester, controller);

    expect(find.text('September 2026'), findsOneWidget);
    expect(find.text('No events'), findsOneWidget);
  });

  testWidgets('shows an existing event for the selected day', (WidgetTester tester) async {
    final CalendarController controller = CalendarController(
      InMemoryEventRepository(<Event>[
        Event(
          id: 'a',
          title: 'Team sync',
          start: DateTime(2026, 9, 17, 10),
          end: DateTime(2026, 9, 17, 11),
        ),
      ]),
      initialDate: DateTime(2026, 9, 17),
    );
    await controller.load();
    await pumpApp(tester, controller);

    expect(find.text('Team sync'), findsOneWidget);
  });

  testWidgets('the next-month button advances the header', (WidgetTester tester) async {
    final CalendarController controller = CalendarController(
      InMemoryEventRepository(),
      initialDate: DateTime(2026, 9, 17),
    );
    await controller.load();
    await pumpApp(tester, controller);

    await tester.tap(find.byTooltip('Next month'));
    await tester.pumpAndSettle();
    expect(find.text('October 2026'), findsOneWidget);
  });
}

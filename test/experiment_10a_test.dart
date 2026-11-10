
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class CalendarEventCard extends StatelessWidget {
  final String title;
  final String date;

  const CalendarEventCard({
    super.key,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.event),
        title: Text(title),
        subtitle: Text(date),
      ),
    );
  }
}

void main() {
  testWidgets('Calendar event title is displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CalendarEventCard(
            title: 'Project Meeting',
            date: '11 November 2026',
          ),
        ),
      ),
    );

    expect(find.text('Project Meeting'), findsOneWidget);
  });

  testWidgets('Calendar event date is displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CalendarEventCard(
            title: 'College Event',
            date: '15 November 2026',
          ),
        ),
      ),
    );

    expect(find.text('15 November 2026'), findsOneWidget);
  });

  testWidgets('Calendar event icon is displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CalendarEventCard(
            title: 'Exam',
            date: '20 November 2026',
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.event), findsOneWidget);
  });
}

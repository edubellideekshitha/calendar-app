
import 'package:flutter/material.dart';

void main() {
  runApp(const CalendarDebugApp());
}

class CalendarDebugApp extends StatelessWidget {
  const CalendarDebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Calendar Debugging',
      home: const CalendarDebugScreen(),
    );
  }
}

class CalendarDebugScreen extends StatefulWidget {
  const CalendarDebugScreen({super.key});

  @override
  State<CalendarDebugScreen> createState() =>
      _CalendarDebugScreenState();
}

class _CalendarDebugScreenState
    extends State<CalendarDebugScreen> {
  int eventCount = 0;

  void addEvent() {
    setState(() {
      eventCount++;
    });

    debugPrint('Calendar event added successfully');
    debugPrint('Total events: $eventCount');
  }

  @override
  Widget build(BuildContext context) {
    assert(eventCount >= 0, 'Event count cannot be negative');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Debugging'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_month,
              size: 70,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Calendar App Debugging',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 15),
            Text(
              'Total Events: $eventCount',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addEvent,
              child: const Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}

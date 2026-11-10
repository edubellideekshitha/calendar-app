
import 'package:flutter/material.dart';

void main() {
  runApp(const CalendarAnimationApp());
}

class CalendarAnimationApp extends StatelessWidget {
  const CalendarAnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar Animations',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const CalendarAnimationScreen(),
    );
  }
}

class CalendarAnimationScreen extends StatefulWidget {
  const CalendarAnimationScreen({super.key});

  @override
  State<CalendarAnimationScreen> createState() =>
      _CalendarAnimationScreenState();
}

class _CalendarAnimationScreenState
    extends State<CalendarAnimationScreen> {
  bool showEvents = false;

  final List<String> events = [
    'Project Review - November 15',
    'College Assignment - November 20',
    'Team Meeting - November 25',
  ];

  void showCalendarEvents() {
    setState(() {
      showEvents = !showEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Animations'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.calendar_month,
              size: 75,
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 15),

            const Text(
              'November 2026',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: showCalendarEvents,
              child: Text(
                showEvents ? 'Hide Events' : 'Show Events',
              ),
            ),

            const SizedBox(height: 20),

            // Fade Animation
            AnimatedOpacity(
              opacity: showEvents ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              child: const Text(
                'Upcoming Calendar Events',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Slide Animation
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return AnimatedSlide(
                    offset: showEvents
                        ? Offset.zero
                        : const Offset(1, 0),
                    duration: Duration(
                      milliseconds: 500 + (index * 200),
                    ),
                    curve: Curves.easeInOut,
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(
                          Icons.event,
                          color: Colors.deepPurple,
                        ),
                        title: Text(events[index]),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

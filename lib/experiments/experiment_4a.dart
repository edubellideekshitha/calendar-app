
import 'package:flutter/material.dart';

void main() {
  runApp(const CalendarNavigationApp());
}

class CalendarNavigationApp extends StatelessWidget {
  const CalendarNavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar Navigation',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const CalendarHomeScreen(),
    );
  }
}

class CalendarHomeScreen extends StatelessWidget {
  const CalendarHomeScreen({super.key});

  final List<Map<String, String>> events = const [
    {
      'title': 'Project Review',
      'date': 'November 15, 2026',
      'description': 'Review the Flutter Calendar App project.'
    },
    {
      'title': 'College Assignment',
      'date': 'November 20, 2026',
      'description': 'Complete the college assignment.'
    },
    {
      'title': 'Team Meeting',
      'date': 'November 25, 2026',
      'description': 'Discuss project progress with team members.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Calendar'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];

          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.event,
                color: Colors.deepPurple,
              ),
              title: Text(event['title']!),
              subtitle: Text(event['date']!),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailsScreen(
                      title: event['title']!,
                      date: event['date']!,
                      description: event['description']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class EventDetailsScreen extends StatelessWidget {
  final String title;
  final String date;
  final String description;

  const EventDetailsScreen({
    super.key,
    required this.title,
    required this.date,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.calendar_month,
              size: 70,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Date: $date',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              'Description: $description',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Calendar'),
            ),
          ],
        ),
      ),
    );
  }
}

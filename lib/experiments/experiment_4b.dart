
import 'package:flutter/material.dart';

void main() {
  runApp(const CalendarNamedRoutesApp());
}

class CalendarNamedRoutesApp extends StatelessWidget {
  const CalendarNamedRoutesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar Named Routes',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CalendarHomePage(),
        '/details': (context) => const EventDetailsPage(),
        '/about': (context) => const AboutCalendarPage(),
      },
    );
  }
}

// Calendar Home Screen
class CalendarHomePage extends StatelessWidget {
  const CalendarHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      {
        'title': 'Project Review',
        'date': '15 November 2026',
        'description': 'Review the Flutter Calendar App project.',
      },
      {
        'title': 'College Assignment',
        'date': '20 November 2026',
        'description': 'Complete the Flutter assignment.',
      },
      {
        'title': 'Team Meeting',
        'date': '25 November 2026',
        'description': 'Discuss project progress.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Calendar App'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 60,
                  color: Colors.deepPurple,
                ),
                SizedBox(height: 10),
                Text(
                  'November 2026',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Navigate using named routes
          for (final event in events)
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.event,
                  color: Colors.deepPurple,
                ),
                title: Text(event['title']!),
                subtitle: Text(event['date']!),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/details',
                    arguments: event,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// Event Details Screen
class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!
        .settings
        .arguments as Map<String, String>;

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
              Icons.event_note,
              size: 70,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            Text(
              event['title']!,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Date: ${event['date']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 15),
            Text(
              'Description: ${event['description']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
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

// About Screen
class AboutCalendarPage extends StatelessWidget {
  const AboutCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Calendar'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month,
              size: 80,
              color: Colors.deepPurple,
            ),
            SizedBox(height: 20),
            Text(
              'Flutter Calendar App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Navigation using Named Routes',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

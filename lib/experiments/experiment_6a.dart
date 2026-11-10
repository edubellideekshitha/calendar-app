
import 'package:flutter/material.dart';

void main() {
  runApp(const CustomCalendarApp());
}

class CustomCalendarApp extends StatelessWidget {
  const CustomCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Calendar Widgets',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const CustomCalendarScreen(),
    );
  }
}

// Custom widget for calendar heading
class CalendarHeading extends StatelessWidget {
  const CalendarHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'November 2026',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }
}

// Custom widget for calendar date
class CalendarDate extends StatelessWidget {
  final int date;
  final bool isSelected;

  const CalendarDate({
    super.key,
    required this.date,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.deepPurple
            : Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        '$date',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

// Custom widget for event card
class EventCard extends StatelessWidget {
  final String title;
  final String date;

  const EventCard({
    super.key,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.event,
          color: Colors.deepPurple,
        ),
        title: Text(title),
        subtitle: Text(date),
      ),
    );
  }
}

// Main calendar screen
class CustomCalendarScreen extends StatelessWidget {
  const CustomCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Calendar App'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CalendarHeading(),
            ),
            const SizedBox(height: 20),

            // Reusing custom date widgets
            Expanded(
              child: GridView.builder(
                itemCount: 30,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final date = index + 1;

                  return CalendarDate(
                    date: date,
                    isSelected: date == 10,
                  );
                },
              ),
            ),

            const Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const EventCard(
              title: 'Project Review',
              date: 'November 15, 2026',
            ),

            const EventCard(
              title: 'College Assignment',
              date: 'November 20, 2026',
            ),
          ],
        ),
      ),
    );
  }
}

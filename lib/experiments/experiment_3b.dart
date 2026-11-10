
import 'package:flutter/material.dart';

void main() {
  runApp(const CalendarResponsiveApp());
}

class CalendarResponsiveApp extends StatelessWidget {
  const CalendarResponsiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar Responsive App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const CalendarResponsiveScreen(),
    );
  }
}

class CalendarResponsiveScreen extends StatelessWidget {
  const CalendarResponsiveScreen({super.key});

  Widget calendarSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'November 2026',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Row(
              children: [
                'Sun', 'Mon', 'Tue', 'Wed',
                'Thu', 'Fri', 'Sat'
              ].map((day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: 30,
              itemBuilder: (context, index) {
                final day = index + 1;
                return Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: day == 10
                        ? Colors.deepPurple
                        : Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: day == 10 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget eventSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: Icon(Icons.event, color: Colors.deepPurple),
              title: Text('Project Review'),
              subtitle: Text('November 15, 2026'),
            ),
            ListTile(
              leading: Icon(Icons.school, color: Colors.deepPurple),
              title: Text('College Assignment'),
              subtitle: Text('November 20, 2026'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Calendar'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;

          // Mobile breakpoint: less than 600 pixels
          if (screenWidth < 600) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  calendarSection(),
                  const SizedBox(height: 10),
                  eventSection(),
                ],
              ),
            );
          }

          // Tablet breakpoint: 600 to 999 pixels
          else if (screenWidth < 1000) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  calendarSection(),
                  const SizedBox(height: 20),
                  eventSection(),
                ],
              ),
            );
          }

          // Desktop breakpoint: 1000 pixels and above
          else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: calendarSection(),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: eventSection(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}


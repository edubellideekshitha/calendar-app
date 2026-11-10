
import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveCalendarApp());
}

class ResponsiveCalendarApp extends StatelessWidget {
  const ResponsiveCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const ResponsiveCalendarScreen(),
    );
  }
}

class ResponsiveCalendarScreen extends StatelessWidget {
  const ResponsiveCalendarScreen({super.key});

  Widget buildCalendar() {
    final days = List.generate(30, (index) => index + 1);

    return Card(
      elevation: 3,
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
            const SizedBox(height: 20),

            const Row(
              children: [
                'Sun', 'Mon', 'Tue', 'Wed',
                'Thu', 'Fri', 'Sat'
              ].map((day) {
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: 35,
              itemBuilder: (context, index) {
                final day = index - 5;

                if (day < 1 || day > 30) {
                  return const SizedBox();
                }

                return Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: day == 10
                        ? Colors.deepPurple
                        : Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: day == 10
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
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

  Widget buildEvents() {
    return Card(
      elevation: 3,
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
            ListTile(
              leading: Icon(Icons.groups, color: Colors.deepPurple),
              title: Text('Team Meeting'),
              subtitle: Text('November 25, 2026'),
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
        title: const Text('Responsive Calendar App'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          if (width < 600) {
            // Mobile layout
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  buildCalendar(),
                  const SizedBox(height: 16),
                  buildEvents(),
                ],
              ),
            );
          } else if (width < 1000) {
            // Tablet layout
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  buildCalendar(),
                  const SizedBox(height: 20),
                  buildEvents(),
                ],
              ),
            );
          } else {
            // Desktop layout
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: buildCalendar(),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: buildEvents(),
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

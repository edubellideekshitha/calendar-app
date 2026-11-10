
import 'package:flutter/material.dart';

void main() {
  runApp(const CalendarWidgetApp());
}

class CalendarWidgetApp extends StatelessWidget {
  const CalendarWidgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar Widgets',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const CalendarWidgetScreen(),
    );
  }
}

// Stateless Widget
class CalendarHeader extends StatelessWidget {
  const CalendarHeader({super.key});

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

// Stateful Widget
class CalendarWidgetScreen extends StatefulWidget {
  const CalendarWidgetScreen({super.key});

  @override
  State<CalendarWidgetScreen> createState() =>
      _CalendarWidgetScreenState();
}

class _CalendarWidgetScreenState extends State<CalendarWidgetScreen> {
  int selectedDate = 10;
  int eventCount = 2;

  void selectDate(int date) {
    setState(() {
      selectedDate = date;
    });
  }

  void addEvent() {
    setState(() {
      eventCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar App'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CalendarHeader(),
            const SizedBox(height: 20),

            // Calendar dates
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
                  final isSelected = selectedDate == date;

                  return GestureDetector(
                    onTap: () => selectDate(date),
                    child: Container(
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
                          color: isSelected
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Text(
              'Selected Date: $selectedDate November 2026',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Total Events: $eventCount',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: addEvent,
              icon: const Icon(Icons.add),
              label: const Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}

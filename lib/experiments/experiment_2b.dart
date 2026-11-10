
import 'package:flutter/material.dart';

void main() {
  runApp(const CalendarLayoutApp());
}

class CalendarLayoutApp extends StatelessWidget {
  const CalendarLayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarLayoutScreen(),
    );
  }
}

class CalendarLayoutScreen extends StatelessWidget {
  const CalendarLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final days = List.generate(35, (index) => index + 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Layout'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row widget
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'November 2026',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Column and Row widgets
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      for (final day in [
                        'Sun', 'Mon', 'Tue', 'Wed',
                        'Thu', 'Fri', 'Sat'
                      ])
                        Expanded(
                          child: Center(
                            child: Text(
                              day,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  for (int week = 0; week < 5; week++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          for (int i = 0; i < 7; i++)
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: Center(
                                  child: days[week * 7 + i] <= 30
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            if (days[week * 7 + i] == 10)
                                              const CircleAvatar(
                                                radius: 17,
                                                backgroundColor:
                                                    Colors.deepPurple,
                                              ),
                                            Text(
                                              '${days[week * 7 + i]}',
                                              style: TextStyle(
                                                color: days[week * 7 + i] == 10
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if ([5, 15, 20].contains(
                                                days[week * 7 + i]))
                                              const Positioned(
                                                bottom: 0,
                                                child: CircleAvatar(
                                                  radius: 2,
                                                  backgroundColor: Colors.red,
                                                ),
                                              ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Column widget
            const Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Row widget
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.event,
                  color: Colors.deepPurple,
                ),
                title: const Text('Project Review'),
                subtitle: const Text('November 15, 2026'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

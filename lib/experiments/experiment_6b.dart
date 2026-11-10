
import 'package:flutter/material.dart';

void main() {
  runApp(const ThemedCalendarApp());
}

class ThemedCalendarApp extends StatelessWidget {
  const ThemedCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Themed Calendar App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F2FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
      ),
      home: const ThemedCalendarScreen(),
    );
  }
}

class ThemedCalendarScreen extends StatefulWidget {
  const ThemedCalendarScreen({super.key});

  @override
  State<ThemedCalendarScreen> createState() =>
      _ThemedCalendarScreenState();
}

class _ThemedCalendarScreenState
    extends State<ThemedCalendarScreen> {
  int selectedDate = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Calendar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'November 2026',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),

            // Calendar card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 30,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final date = index + 1;
                    final selected = date == selectedDate;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.deepPurple
                              : Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selected
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 10),

            const Card(
              child: ListTile(
                leading: Icon(
                  Icons.event,
                  color: Colors.deepPurple,
                ),
                title: Text('Project Review'),
                subtitle: Text('November 15, 2026'),
              ),
            ),

            const Card(
              child: ListTile(
                leading: Icon(
                  Icons.school,
                  color: Colors.deepPurple,
                ),
                title: Text('College Assignment'),
                subtitle: Text('November 20, 2026'),
              ),
            ),

            const Spacer(),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Selected Date: $selectedDate November 2026',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.check),
                label: const Text('Confirm Date'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

void main() {
  runApp(const AnimatedCalendarApp());
}

class AnimatedCalendarApp extends StatelessWidget {
  const AnimatedCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animated Calendar App',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const AnimatedCalendarScreen(),
    );
  }
}

class AnimatedCalendarScreen extends StatefulWidget {
  const AnimatedCalendarScreen({super.key});

  @override
  State<AnimatedCalendarScreen> createState() =>
      _AnimatedCalendarScreenState();
}

class _AnimatedCalendarScreenState
    extends State<AnimatedCalendarScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> scaleAnimation;

  int selectedDate = 10;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void selectDate(int date) {
    setState(() {
      selectedDate = date;
    });

    controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Calendar'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'November 2026',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 20),

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
                  final isSelected = date == selectedDate;

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
                      child: isSelected
                          ? ScaleTransition(
                              scale: scaleAnimation,
                              child: Text(
                                '$date',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            )
                          : Text(
                              '$date',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            ScaleTransition(
              scale: scaleAnimation,
              child: Card(
                color: Colors.deepPurple.shade50,
                child: ListTile(
                  leading: const Icon(
                    Icons.event,
                    color: Colors.deepPurple,
                  ),
                  title: const Text('Selected Calendar Date'),
                  subtitle: Text(
                    '$selectedDate November 2026',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: () {
                controller.forward(from: 0);
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Animation'),
            ),
          ],
        ),
      ),
    );
  }
}

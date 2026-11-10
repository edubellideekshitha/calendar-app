
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CalendarProvider(),
      child: const CalendarProviderApp(),
    ),
  );
}

// State management class
class CalendarProvider extends ChangeNotifier {
  final List<String> events = [
    'Project Review',
    'College Assignment',
  ];

  void addEvent(String event) {
    events.add(event);
    notifyListeners();
  }

  void deleteEvent(int index) {
    events.removeAt(index);
    notifyListeners();
  }
}

// Main application
class CalendarProviderApp extends StatelessWidget {
  const CalendarProviderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar Provider App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const CalendarProviderScreen(),
    );
  }
}

// Calendar screen
class CalendarProviderScreen extends StatelessWidget {
  const CalendarProviderScreen({super.key});

  void showAddEventDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Calendar Event'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter event name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final event = controller.text.trim();

                if (event.isNotEmpty) {
                  context.read<CalendarProvider>().addEvent(event);
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar App'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Consumer<CalendarProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.calendar_month,
                size: 65,
                color: Colors.deepPurple,
              ),
              const Text(
                'Upcoming Calendar Events',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Total Events: ${provider.events.length}'),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.events.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: const Icon(
                          Icons.event,
                          color: Colors.deepPurple,
                        ),
                        title: Text(provider.events[index]),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            context
                                .read<CalendarProvider>()
                                .deleteEvent(index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed: () => showAddEventDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

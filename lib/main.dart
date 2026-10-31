
import 'package:flutter/material.dart';

void main() {
  runApp(const CalendarApp());
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const CalendarHomePage(),
    );
  }
}

class CalendarHomePage extends StatefulWidget {
  const CalendarHomePage({super.key});

  @override
  State<CalendarHomePage> createState() =>
      _CalendarHomePageState();
}

class _CalendarHomePageState extends State<CalendarHomePage> {
  DateTime selectedDate = DateUtils.dateOnly(DateTime.now());

  final Map<DateTime, List<String>> events = {};

  List<String> get selectedEvents =>
      events[selectedDate] ?? [];

  void addEvent() {
    final TextEditingController controller =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Event'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter event name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String eventName = controller.text.trim();

                if (eventName.isNotEmpty) {
                  setState(() {
                    events.putIfAbsent(
                      selectedDate,
                      () => [],
                    );
                    events[selectedDate]!.add(eventName);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void deleteEvent(int index) {
    setState(() {
      events[selectedDate]!.removeAt(index);

      if (events[selectedDate]!.isEmpty) {
        events.remove(selectedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Calendar'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),

          const Text(
            'Select a Date',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          CalendarDatePicker(
            initialDate: selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime(2035),
            onDateChanged: (date) {
              setState(() {
                selectedDate = DateUtils.dateOnly(date);
              });
            },
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Events on ${selectedDate.day}/'
              '${selectedDate.month}/${selectedDate.year}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: selectedEvents.isEmpty
                ? const Center(
                    child: Text(
                      'No events for this date',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 5,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.event,
                            color: Colors.deepPurple,
                          ),
                          title: Text(selectedEvents[index]),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => deleteEvent(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addEvent,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
=======
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/event_repository.dart';
import 'state/calendar_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final CalendarController controller =
      CalendarController(SharedPrefsEventRepository());
  await controller.load();

  runApp(
    ChangeNotifierProvider<CalendarController>.value(
      value: controller,
      child: const CalendarApp(),
    ),
  );
>>>>>>> origin/master
}

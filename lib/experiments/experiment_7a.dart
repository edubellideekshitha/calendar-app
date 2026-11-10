
import 'package:flutter/material.dart';

void main() {
  runApp(const CalendarFormApp());
}

class CalendarFormApp extends StatelessWidget {
  const CalendarFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar Event Form',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const EventFormScreen(),
    );
  }
}

class EventFormScreen extends StatefulWidget {
  const EventFormScreen({super.key});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime selectedDate = DateTime(2026, 11, 15);
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);

  String selectedCategory = 'Personal';

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> chooseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2030, 12, 31),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> chooseTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  void saveEvent() {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter event title')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Event Saved'),
        content: Text(
          'Title: ${titleController.text}\n'
          'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}\n'
          'Category: $selectedCategory',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Calendar Event'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.calendar_month,
                size: 65,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Event Title',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Enter event title',
                prefixIcon: Icon(Icons.event),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter event description',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Select Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              ),
              trailing: const Icon(Icons.edit_calendar),
              onTap: chooseDate,
            ),

            const Text(
              'Select Time',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(selectedTime.format(context)),
              trailing: const Icon(Icons.schedule),
              onTap: chooseTime,
            ),

            const SizedBox(height: 10),

            const Text(
              'Event Category',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: ['Personal', 'College', 'Work', 'Other']
                  .map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: saveEvent,
                icon: const Icon(Icons.save),
                label: const Text('Save Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

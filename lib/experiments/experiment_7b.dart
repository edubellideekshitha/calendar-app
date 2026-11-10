
import 'package:flutter/material.dart';

void main() {
  runApp(const CalendarValidationApp());
}

class CalendarValidationApp extends StatelessWidget {
  const CalendarValidationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar Form Validation',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const EventValidationScreen(),
    );
  }
}

class EventValidationScreen extends StatefulWidget {
  const EventValidationScreen({super.key});

  @override
  State<EventValidationScreen> createState() =>
      _EventValidationScreenState();
}

class _EventValidationScreenState
    extends State<EventValidationScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime selectedDate = DateTime(2026, 11, 15);

  String selectedCategory = 'Personal';

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
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

  void saveEvent() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Event Details'),
          content: Text(
            'Title: ${titleController.text}\n'
            'Description: ${descriptionController.text}\n'
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Form Validation'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(
                  Icons.event_available,
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

              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter event title',
                  prefixIcon: Icon(Icons.event),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter event title';
                  }

                  if (value.trim().length < 3) {
                    return 'Title must contain at least 3 characters';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Event Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter event description',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter event description';
                  }

                  return null;
                },
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
                onTap: selectDate,
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
                items: [
                  'Personal',
                  'College',
                  'Work',
                  'Other',
                ].map((category) {
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
      ),
    );
  }
}

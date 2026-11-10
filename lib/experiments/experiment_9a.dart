
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const CalendarApiApp());
}

class CalendarApiApp extends StatelessWidget {
  const CalendarApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar REST API',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const CalendarApiScreen(),
    );
  }
}

class CalendarApiScreen extends StatefulWidget {
  const CalendarApiScreen({super.key});

  @override
  State<CalendarApiScreen> createState() =>
      _CalendarApiScreenState();
}

class _CalendarApiScreenState extends State<CalendarApiScreen> {
  List<dynamic> events = [];
  bool isLoading = false;
  String errorMessage = '';

  // Fetch events from REST API
  Future<void> fetchEvents() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://jsonplaceholder.typicode.com/posts?_limit=5',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          events = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load events');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Unable to fetch events. Please try again.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar API Events'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.calendar_month,
              size: 65,
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 10),

            const Text(
              'Events from REST API',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: isLoading ? null : fetchEvents,
              icon: const Icon(Icons.refresh),
              label: const Text('Fetch Events'),
            ),

            const SizedBox(height: 15),

            if (isLoading)
              const CircularProgressIndicator(),

            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),

            if (!isLoading && events.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple.shade100,
                          child: Text('${event['id']}'),
                        ),
                        title: Text(
                          event['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          event['body'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

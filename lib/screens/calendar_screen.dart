
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/calendar_event.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  Map<DateTime, List<CalendarEvent>> events = {};

  bool isLoading = true;

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    selectedDay = normalizeDate(DateTime.now());
    loadEvents();
  }

  // Load events from local storage
  Future<void> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('calendar_events');

    Map<DateTime, List<CalendarEvent>> loaded = {};

    if (data != null) {
      try {
        final List decoded = jsonDecode(data);

        for (var item in decoded) {
          final event = CalendarEvent.fromJson(
            Map<String, dynamic>.from(item),
          );

          final date = normalizeDate(event.date);

          loaded.putIfAbsent(date, () => []);
          loaded[date]!.add(event);
        }
      } catch (e) {
        debugPrint('Error loading events: $e');
      }
    }

    if (!mounted) return;

    setState(() {
      events = loaded;
      isLoading = false;
    });
  }

  // Save events
  Future<void> saveEvents() async {
    final prefs = await SharedPreferences.getInstance();

    final allEvents = events.values
        .expand((list) => list)
        .map((event) => event.toJson())
        .toList();

    await prefs.setString(
      'calendar_events',
      jsonEncode(allEvents),
    );
  }

  // Get events for a particular date
  List<CalendarEvent> getEvents(DateTime day) {
    return events[normalizeDate(day)] ?? [];
  }

  // Add or edit event
  Future<CalendarEvent?> eventDialog({
    CalendarEvent? oldEvent,
  }) async {
    final titleController = TextEditingController(
      text: oldEvent?.title ?? '',
    );

    final descriptionController = TextEditingController(
      text: oldEvent?.description ?? '',
    );

    final formKey = GlobalKey<FormState>();

    final result = await showDialog<CalendarEvent>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            oldEvent == null ? 'Add New Event' : 'Edit Event',
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Event Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter event title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newEvent = CalendarEvent(
                    id: oldEvent?.id ??
                        DateTime.now()
                            .microsecondsSinceEpoch
                            .toString(),
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    date: normalizeDate(
                      oldEvent?.date ?? selectedDay,
                    ),
                  );

                  Navigator.pop(dialogContext, newEvent);
                }
              },
              child: Text(
                oldEvent == null ? 'Add' : 'Update',
              ),
            ),
          ],
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();

    return result;
  }

  // Add event
  Future<void> addEvent() async {
    final event = await eventDialog();

    if (event == null) return;

    setState(() {
      final date = normalizeDate(event.date);
      events.putIfAbsent(date, () => []);
      events[date]!.add(event);
    });

    await saveEvents();
  }

  // Edit event
  Future<void> editEvent(CalendarEvent event) async {
    final updated = await eventDialog(oldEvent: event);

    if (updated == null) return;

    setState(() {
      final date = normalizeDate(event.date);
      final list = events[date]!;

      final index = list.indexWhere(
        (item) => item.id == event.id,
      );

      if (index != -1) {
        list[index] = updated;
      }
    });

    await saveEvents();
  }

  // Delete event
  Future<void> deleteEvent(CalendarEvent event) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: Text('Delete "${event.title}"?'),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() {
      final date = normalizeDate(event.date);

      events[date]?.removeWhere(
        (item) => item.id == event.id,
      );

      if (events[date]?.isEmpty ?? false) {
        events.remove(date);
      }
    });

    await saveEvents();
  }

  // Display events
  Widget eventList() {
    final dayEvents = getEvents(selectedDay);

    if (dayEvents.isEmpty) {
      return const Center(
        child: Text(
          'No events for this day',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: dayEvents.length,
      itemBuilder: (context, index) {
        final event = dayEvents[index];

        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFEDE7F6),
              child: Icon(
                Icons.event,
                color: Colors.deepPurple,
              ),
            ),
            title: Text(
              event.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              event.description.isEmpty
                  ? 'No description'
                  : event.description,
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  editEvent(event);
                } else if (value == 'delete') {
                  deleteEvent(event);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Calendar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TableCalendar<CalendarEvent>(
                      firstDay: DateTime.utc(2000, 1, 1),
                      lastDay: DateTime.utc(2100, 12, 31),
                      focusedDay: focusedDay,

                      selectedDayPredicate: (day) {
                        return isSameDay(selectedDay, day);
                      },

                      onDaySelected: (selected, focused) {
                        setState(() {
                          selectedDay = normalizeDate(selected);
                          focusedDay = focused;
                        });
                      },

                      onPageChanged: (focused) {
                        focusedDay = focused;
                      },

                      eventLoader: getEvents,

                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.deepPurple,
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),

                      headerStyle: const HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Events',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${getEvents(selectedDay).length} Events',
                        style: const TextStyle(
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(child: eventList()),
              ],
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: addEvent,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Event'),
      ),
    );
  }
}

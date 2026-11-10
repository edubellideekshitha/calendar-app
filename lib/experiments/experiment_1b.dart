
class CalendarEvent {
  String title;
  String description;
  DateTime date;

  CalendarEvent({
    required this.title,
    required this.description,
    required this.date,
  });

  void displayEvent() {
    print("Event: $title");
    print("Description: $description");
    print("Date: ${date.day}/${date.month}/${date.year}");
  }
}

void main() {
  String appName = "Flutter Calendar App";
  int totalEvents = 2;
  bool isCalendarActive = true;

  print(appName);
  print("Total Events: $totalEvents");
  print("Calendar Active: $isCalendarActive");

  List<CalendarEvent> events = [
    CalendarEvent(
      title: "College Assignment",
      description: "Complete Flutter assignment",
      date: DateTime(2026, 11, 12),
    ),
    CalendarEvent(
      title: "Project Review",
      description: "Calendar App review",
      date: DateTime(2026, 11, 15),
    ),
  ];

  print("\nCalendar Events:");

  for (var event in events) {
    event.displayEvent();
    print("----------------");
  }
}

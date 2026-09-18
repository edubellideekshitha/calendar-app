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
}

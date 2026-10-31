# Flutter Calendar

A month-view calendar app built with Flutter. Tap a day to see its agenda, add
events with a time range, colour and notes, and everything is stored locally on
the device so it survives a restart.

![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-blue)
![Flutter](https://img.shields.io/badge/flutter-3.19%2B-02569B)
![License](https://img.shields.io/badge/license-MIT-green)

## Features

- Month grid with leading/trailing days, today marker and event dots
- Swipe left/right or use the arrows to change month; "Today" jumps back
- Day agenda with create, edit, swipe-to-delete and undo
- All-day events, start/end times, notes and six event colours
- Local persistence via `shared_preferences` behind a swappable repository
- Material 3 theming with automatic light/dark mode
- Unit and widget tests, lint config and a GitHub Actions CI pipeline

## Project layout

```
lib/
  main.dart                     app entrypoint, wiring and startup load
  app.dart                      MaterialApp, theme, routes
  models/event.dart             Event model + JSON serialization
  services/event_repository.dart storage contract + SharedPreferences/in-memory impls
  state/calendar_controller.dart ChangeNotifier: focused month, selection, CRUD
  screens/calendar_screen.dart  month view + agenda composition
  utils/date_utils.dart         grid building, month math, formatting
  widgets/                      month_header, weekday_strip, month_grid,
                                day_cell, event_list_panel, event_editor_sheet
test/                           unit + widget tests
docs/                           architecture and deployment notes
.github/workflows/ci.yml        analyze, test, build
```

## Requirements

- Flutter SDK 3.19 or newer (Dart 3.3+) — `flutter --version`
- Android Studio / Xcode if you want to build for mobile
- Git

## Getting started

This repo ships the cross-platform Dart code only. Generate the native platform
folders once on your machine, then run:

```bash
# 1. from inside the project folder, create android/ ios/ web/ etc.
flutter create . --project-name flutter_calendar --platforms=android,ios,web

# 2. install dependencies
flutter pub get

# 3. run it
flutter run                 # first connected device
flutter run -d chrome       # web
```

`flutter create .` will not overwrite the files in this repo — it only adds the
platform scaffolding that is intentionally gitignored-free but not checked in.

## Tests and analysis

```bash
flutter analyze
flutter test
flutter test --coverage
```

## Release builds

```bash
flutter build apk --release          # Android APK
flutter build appbundle --release    # Play Store bundle
flutter build ios --release          # iOS (needs a Mac + signing)
flutter build web --release          # static site in build/web
```

## Push to GitHub

See [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) for the full walkthrough, or the
short version:

```bash
git init
git add .
git commit -m "feat: Flutter calendar app with local event storage"
git branch -M main
git remote add origin https://github.com/<your-username>/flutter-calendar.git
git push -u origin main
```

## Roadmap

- Week and day views
- Recurring events (RRULE)
- Local notifications / reminders
- Cloud sync (Firebase or a REST backend) by adding a new `EventRepository`
- Device calendar import/export (`.ics`)

## License

MIT — see [LICENSE](LICENSE).

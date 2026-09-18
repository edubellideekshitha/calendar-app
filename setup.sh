#!/usr/bin/env bash
# One-shot local bootstrap: platform folders, deps, analysis, tests.
set -euo pipefail

command -v flutter >/dev/null || { echo "Flutter SDK not found on PATH"; exit 1; }

echo "==> Generating platform folders"
flutter create . --project-name flutter_calendar --platforms=android,ios,web

echo "==> Fetching dependencies"
flutter pub get

echo "==> Analyzing"
flutter analyze

echo "==> Testing"
flutter test

echo
echo "Done. Run the app with:  flutter run"

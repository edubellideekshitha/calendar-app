# Deployment

## 1. Push to GitHub

### Option A — GitHub CLI (fastest)

```bash
cd flutter_calendar
git init
git add .
git commit -m "feat: Flutter calendar app with local event storage"
git branch -M main

gh repo create flutter-calendar --public --source=. --remote=origin --push
```

### Option B — web UI + plain git

1. Create an empty repo at <https://github.com/new> named `flutter-calendar`.
   Do **not** add a README, .gitignore or license — this project has them.
2. Then:

```bash
cd flutter_calendar
git init
git add .
git commit -m "feat: Flutter calendar app with local event storage"
git branch -M main
git remote add origin https://github.com/<your-username>/flutter-calendar.git
git push -u origin main
```

If HTTPS asks for a password, use a personal access token
(Settings -> Developer settings -> Tokens) or switch to SSH:

```bash
git remote set-url origin git@github.com:<your-username>/flutter-calendar.git
```

### Day-to-day flow

```bash
git checkout -b feature/week-view
# ...edit...
flutter analyze && flutter test
git add .
git commit -m "feat: add week view"
git push -u origin feature/week-view
# open a pull request on GitHub
```

Commit messages follow Conventional Commits: `feat:`, `fix:`, `docs:`,
`refactor:`, `test:`, `chore:`.

## 2. Continuous integration

`.github/workflows/ci.yml` runs on every push and pull request to `main`:
format check, `flutter analyze`, `flutter test`, and a release web build. The
first run appears under the repo's **Actions** tab.

## 3. Publish the web build to GitHub Pages

The `deploy` job in the workflow publishes `build/web` to Pages on pushes to
`main`. Enable it once:

1. Repo **Settings -> Pages -> Build and deployment -> Source: GitHub Actions**.
2. Push to `main`. The site lands at
   `https://<your-username>.github.io/flutter-calendar/`.

The workflow passes `--base-href "/flutter-calendar/"`; change that if your repo
name differs, or the page will load a blank screen.

## 4. Android release

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias upload
```

Create `android/key.properties` (keep it out of git):

```
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=/Users/you/upload-keystore.jks
```

Wire it up in `android/app/build.gradle`, then:

```bash
flutter build appbundle --release
```

Upload `build/app/outputs/bundle/release/app-release.aab` to the Play Console.

To attach an APK to a GitHub Release instead:

```bash
flutter build apk --release
gh release create v1.0.0 build/app/outputs/flutter-apk/app-release.apk \
  --title "v1.0.0" --notes "First release"
```

## 5. iOS release

Needs macOS, Xcode and an Apple Developer account.

```bash
flutter build ipa --release
open build/ios/archive/Runner.xcarchive
```

Distribute from Xcode Organizer or upload with `xcrun altool`.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| `No pubspec.yaml found` | You're not in the project folder. |
| `Target of URI doesn't exist` | Run `flutter pub get`. |
| No `android/` or `ios/` folder | Run `flutter create . --project-name flutter_calendar`. |
| Blank GitHub Pages site | `--base-href` must match the repo name, with slashes. |
| CI fails on formatting | Run `dart format .` and commit. |

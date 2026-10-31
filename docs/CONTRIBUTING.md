# Contributing

1. Fork and branch from `main`: `git checkout -b feature/<name>`.
2. Keep `flutter analyze` clean and `flutter test` green.
3. Run `dart format .` before committing.
4. Use Conventional Commit messages (`feat:`, `fix:`, `docs:`, `test:`, `chore:`).
5. Add or update tests for any behaviour change.
6. Open a pull request describing what changed and why, with a screenshot for
   UI changes.

## Adding a new storage backend

Implement `EventRepository` (`loadAll`, `saveAll`), then pass your class into
`CalendarController` in `lib/main.dart`. Nothing else needs to change.

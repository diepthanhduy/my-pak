Replace the in-memory data layer with a drift database. Follow CLAUDE.md, docs/architecture.md §5 and docs/requirements.md §4.

## Step 0 — Plan first
Read CLAUDE.md, docs/architecture.md, docs/requirements.md and the current `lib/domain`, `lib/data`, `lib/core/di` code. Reply in Vietnamese with: tables + indexes, file list, how `CallTask` (with its patients and last contact) is assembled from the tables, and the DI/environment plan. Wait for my OK before writing code.

## Scope
- `lib/data/local/`:
  - `app_database.dart` (`@DriftDatabase`, `schemaVersion = 1`), one file per table under `tables/`: `patients`, `appointments`, `call_tasks`, `contact_attempts`, `import_batches` exactly as docs/architecture.md §5.
  - Constraints: `patients.medicalCode` unique; `call_tasks (date, phoneNormalized)` unique; FKs with `PRAGMA foreign_keys = ON` in `beforeOpen`.
  - Store dates as day-only (`DateTime` at local midnight) consistently; put the helper in `core/utils/date_utils.dart` if missing.
  - Enums stored with `textEnum` (readable in DB browser).
  - DAOs: `CallTaskDao` (watch by date with joined patients/appointments + latest contact attempt), `ContactAttemptDao`, `ImportDao` (used by prompt 04).
  - Mappers row ↔ domain entity in `mappers/`. Drift types never leave `data/`.
- `lib/data/repositories/drift_call_task_repository.dart` implementing the existing `CallTaskRepository` (keep its current API; extend only if needed and say so in the plan).
- Settings persistence: implement `SettingsRepository` with a `settings` key-value table or a single-row table (propose which). Default values from `reminder_settings.dart`.
- DI: a `@module` provides `AppDatabase` (single place to open DB — SQLCipher later). Drift repos registered for `Environment.prod`; in-memory repos stay for `Environment.dev`. `main.dart` picks env via `--dart-define=ENV=dev|prod` (default prod). Add a dev-only "seed synthetic data" helper so the prod DB can be filled for manual testing (behind `kDebugMode`).
- Do not change UI except what is needed for empty state when DB is empty.

## Rules
- Watch queries must emit when attempts / statuses change, so Home updates live.
- Latest contact = contact attempt with max `startedAt` per call task.
- Never log patient names or phones.

## Tests
- `NativeDatabase.memory()`: unique constraints, watchByDate emits on insert/update, latest-contact selection, mapper round-trip.
- Repository test: `recordContactStarted` creates an attempt and Home stream re-emits.

## Done when
`dart run build_runner build`, `flutter analyze`, `flutter test` pass; app runs with `ENV=dev` (fake data) and `ENV=prod` (empty DB → empty state). Short Vietnamese summary. Do not commit.

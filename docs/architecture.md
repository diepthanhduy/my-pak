# Architecture

Single Flutter package, Clean Architecture organized **by layer**.

## 1. Layers & dependency rule

```text
presentation ──► domain ◄── data
      │                       │
      └──────── core ◄────────┘      (core is usable by every layer; core/di wires data → domain)
```

| Layer | May import | Must NOT import |
| --- | --- | --- |
| `domain` | Dart SDK, `equatable`, `core/error`, `core/utils` (pure Dart parts) | Flutter, `data`, `presentation`, drift, pdfrx, platform plugins |
| `data` | `domain`, `core`, drift, pdfrx, plugins, platform channels | `presentation` |
| `presentation` | `domain`, `core`, Flutter, `flutter_bloc`, `go_router` | `data` (resolve implementations through DI only) |
| `app` | everything needed to compose the app (router, DI bootstrap) | — |

`injectable` annotations on `data` classes (`@LazySingleton(as: CallTaskRepository)`) are what bind implementations to domain interfaces.

## 2. Folder map

```text
lib/
  main.dart                   # ensureInitialized → configureDependencies → runApp
  app/
    app.dart                  # MaterialApp.router, theme
    router.dart               # go_router routes
  core/
    di/                       # injection.dart (+ generated injection.config.dart), @module registrations
    error/                    # Failure sealed classes, exceptions
    utils/                    # phone_normalizer.dart, date helpers (pure Dart)
    theme/
  domain/
    entities/                 # Patient, Appointment, CallTask, ContactAttempt, ImportBatch, enums
    repositories/             # abstract interfaces
    services/                 # platform capability interfaces (PhoneLauncher, later CallLogService, SmsService)
    usecases/                 # one public method each (call()), e.g. ImportAppointmentList, RecordContactResult
  data/
    local/                    # drift AppDatabase, tables/, daos/, mappers to domain entities
    pdf/                      # PdfTextExtractor (pdfrx), PositionedText, AppointmentListParser (pure Dart)
    repositories/             # implementations of domain/repositories
    services/                 # PhoneCallService, SmsService, CallLogService (platform channels / url_launcher)
  presentation/
    import/                   # pick/share PDF, review screen
    call_list/                # daily list grouped by phone, result bottom sheet
    settings/                 # SMS template, retry limit, clinic info, SIM
    common/                   # shared widgets, effect listener helpers
test/                         # mirrors lib/
```

## 3. State management — Bloc, MVI style

- **State**: immutable, `Equatable`, `copyWith`. Represents what the screen renders; derived values computed in the bloc or as getters.
- **Event**: `sealed class` hierarchy; one class per user intent / system signal.
- **Effect**: one-off side effects (navigate, show snackbar, launch call, open SMS composer, show result sheet). Emitted on a **separate stream**, never stored in State (State must be safe to rebuild / replay).

```dart
// Pattern sketch — adapt naming per feature.
sealed class CallListEvent {}
final class CallListStarted extends CallListEvent {}
final class CallTapped extends CallListEvent {
  CallTapped(this.callTaskId);
  final int callTaskId;
}

sealed class CallListEffect {}
final class LaunchCall extends CallListEffect {
  LaunchCall(this.phone);
  final String phone;
}
final class ShowResultSheet extends CallListEffect { /* ... */ }

class CallListBloc extends Bloc<CallListEvent, CallListState> {
  CallListBloc(this._getDailyList) : super(const CallListState.initial()) {
    on<CallListStarted>(_onStarted);
    on<CallTapped>(_onCallTapped);
  }

  final GetDailyCallList _getDailyList;
  final _effects = StreamController<CallListEffect>.broadcast();
  Stream<CallListEffect> get effects => _effects.stream;

  @override
  Future<void> close() async {
    await _effects.close();
    return super.close();
  }
  // handlers: emit(state.copyWith(...)) for state, _effects.add(...) for effects
}
```

- UI subscribes to `effects` in a `StatefulWidget` (or a shared `EffectListener` widget in `presentation/common/`) and cancels on dispose.
- Blocs depend on **use cases / repository interfaces**, never on drift or platform services directly.
- Prefer `Bloc` for screens with multiple intents; `Cubit` is acceptable for trivial settings forms.

### Call → result flow

1. `CallTapped` → bloc records `ContactAttempt(startedAt)` → effect `LaunchCall`.
2. App goes to background (phone app). On `AppLifecycleState.resumed`, the page dispatches `AppResumed`.
3. Bloc sees a pending attempt → (P1: query call log / `CXCallObserver` for suggestion) → effect `ShowResultSheet`.
4. `ResultSubmitted` → use case updates `ContactAttempt`, `CallTask.status/attemptCount`, `Appointment.status`.

## 4. Dependency injection

- `get_it` + `injectable`. Entry: `lib/core/di/injection.dart` → `configureDependencies()`.
- Annotations: `@injectable` (factory, blocs/use cases), `@lazySingleton` (repositories, services, database), `@module` for third-party objects (drift `AppDatabase`, clocks).
- Register implementations as interfaces: `@LazySingleton(as: CallTaskRepository) class CallTaskRepositoryImpl ...`.
- Regenerate after changing annotations: `dart run build_runner build --delete-conflicting-outputs`.

## 5. Database — drift

| Table | Key fields | Constraints / notes |
| --- | --- | --- |
| `patients` | medicalCode, name, dob, address, phoneNormalized | `medicalCode` unique |
| `appointments` | id, patientId, date, content, status, importBatchId | status: pending / confirmed / rescheduled / skipped |
| `call_tasks` | id, date, phoneNormalized, status, attemptCount, nextRetryAt | unique `(date, phoneNormalized)`; status: pending / retry / done / unreachable |
| `contact_attempts` | id, callTaskId, channel, startedAt, returnedAt, result, durationSec?, source, note, smsBody? | channel: call / sms; source: manual / callLog / callKit |
| `import_batches` | id, date, sourceType, sourceFilePath, expectedCount, parsedCount, createdAt | |

Rules:

- `CallTask.status` derives from the latest `ContactAttempt` (and `attemptCount` vs max retries). Compute it in one place (domain use case), persist the result.
- `Appointment.status` follows its `CallTask` unless overridden per patient.
- Re-import same date: upsert patients by `medicalCode`; keep existing `CallTask` / `ContactAttempt` rows; add new appointments; never wipe history.
- Map drift rows ↔ domain entities in `data/local/` mappers; drift types never leak into `domain` or `presentation`.
- Schema changes bump `schemaVersion` with an explicit migration.
- Encryption (SQLCipher) is planned later — keep DB opening in one `@module` so it can be swapped.

## 6. Platform services

Domain defines interfaces; `data/services/` implements them per platform.

| Interface | Android | iOS |
| --- | --- | --- |
| `PhoneCallService.call(phone)` | Platform channel → `ACTION_CALL` (`CALL_PHONE`) | `url_launcher` `tel:` (system confirm) |
| `CallLogService.lastCallTo(phone, since)` (P1) | `READ_CALL_LOG` via platform channel | `CXCallObserver` (no number) |
| `SmsService.send(phones, body)` | `SmsManager` (`SEND_SMS`) | Prefilled composer, user taps Send |
| `SimService` (P1) | `SubscriptionManager` / `PhoneAccountHandle` | Unsupported → hidden |

Services return capability flags so presentation can adapt UI (e.g. hide SIM picker on iOS).

## 7. Privacy in code

- No `print` (lint `avoid_print`). Use a logger wrapper that never receives names / phone numbers — log IDs and counts.
- No analytics / crash SDK sends patient fields.
- Source PDFs are copied into app storage and auto-deleted after X days (setting).

## 8. Testing strategy

| Layer | Tooling | Focus |
| --- | --- | --- |
| `core/utils` | `test` | phone normalization, date parsing |
| `data/pdf` parser | `test` + synthetic `PositionedText` fixtures | all scenarios in [pdf-format.md §7](pdf-format.md#7-test-scenarios-synthetic-fixtures) |
| `domain/usecases` | `test` + `mocktail` | status derivation, retry rules, re-import dedupe |
| `data/local` | drift in-memory DB (`NativeDatabase.memory()`) | DAOs, constraints, migrations |
| `presentation` blocs | `bloc_test` + `mocktail` | states **and** effects |
| widgets | `flutter_test` | key screens (review, call list, result sheet) |

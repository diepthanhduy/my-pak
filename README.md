# Assistant PAK

Internal app (Android + iOS) for calling and SMS-reminding patients about vaccination / follow-up appointments, using the clinic's daily "Danh sách hẹn tái khám" PDF as the data source.

## Stack

- Flutter, Clean Architecture (layer-based folders in a single package)
- State: flutter_bloc (Bloc/Cubit, MVI-style state + effects)
- DI: get_it + injectable
- Local DB: drift
- PDF text with coordinates: pdfrx
- Routing: go_router

## Setup

```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

The script runs `flutter create` (generates `android/`, `ios/`), adds dependencies, then runs `build_runner`.

## Structure

```
lib/
  main.dart
  app/                 # App widget, router, app-level config
  core/
    di/                # get_it + injectable setup
    error/             # Failure types
    utils/             # Phone normalization, date helpers
    theme/
  domain/              # Pure Dart, no Flutter / data imports
    entities/          # Patient, Appointment, CallTask, ContactAttempt, ImportBatch
    repositories/      # Abstract repositories
    usecases/
  data/
    local/             # drift database, tables, DAOs
    pdf/               # PDF extractor (pdfrx) + appointment list parser
    repositories/      # Repository implementations
    services/          # Phone call / SMS launchers, platform channels
  presentation/
    import/            # Import PDF + review screen
    call_list/         # Daily call list, result bottom sheet
    settings/          # SMS template, retry limit, SIM
    common/            # Shared widgets
test/
```

Dependency rule: `presentation → domain ← data`; `domain` imports nothing from `data` or Flutter.

## Codegen

```bash
dart run build_runner watch --delete-conflicting-outputs
```

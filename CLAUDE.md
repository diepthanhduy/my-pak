# CLAUDE.md — Assistant PAK

Internal Flutter app (Android + iOS) that helps one clinic staff member remind patients (often parents of young children) about vaccination / follow-up appointments by **phone call**, with **SMS as backup**. The data source is the clinic software's daily PDF "DANH SÁCH HẸN TÁI KHÁM".

Detailed docs (read the relevant one before working in that area):

- [docs/requirements.md](docs/requirements.md) — MVP scope, priorities (P0/P1/P2), platform constraints, roadmap, open questions
- [docs/architecture.md](docs/architecture.md) — layers, folder map, bloc state/effect pattern, DI, drift data model
- [docs/pdf-format.md](docs/pdf-format.md) — input PDF layout + coordinate-based parser design

## Product in one screen

- Single user, no login, no backend, offline-first. Sideloaded on Android first; iOS later (Ad Hoc).
- Import one PDF = one day's list → mandatory review screen → call list.
- Patients sharing a phone number are **grouped**: one call / one SMS reminds the whole group (sample: 26 patients → 21 phone groups).
- Calls are normal SIM voice calls (no VoIP, no auto-call/TTS). Goal: 1 tap to start a call.
- After returning from a call → result bottom sheet → unreachable numbers go to "Retry" (max N attempts, default 3).

## Communication rules

- Talk to the user in **Vietnamese**; keep technical terms in English. Code, identifiers, code comments, commit messages, file names: **English**.
- Peer-to-peer tone, straight to the point. No 101 explanations.
- When several solutions exist: list options with trade-offs, then state a recommendation.

## Working rules

- **Before modifying code**: review and propose; apply only after the user agrees. Typos / formatting / naming fixes can be applied freely.
- **Ask first** before:
  - changing architecture or folder structure
  - adding / removing / upgrading a dependency
  - editing `pubspec.yaml`, `analysis_options.yaml`, build configs, Gradle, `AndroidManifest.xml`, Xcode / `Info.plist` settings
- Do not write feature code outside the scope that was agreed.
- Run `flutter analyze` and the relevant tests after changes; report failures honestly.

## Hard rules (never break)

- **Git**: NEVER run `git push` (any form) or any destructive / delete operation: `git branch -d/-D`, `git rm`, `git reset --hard`, `git clean`, `--force` anything. The user does those. Do not commit unless asked.
- **Patient data**: never put real patient data (names, phones, medical codes, DOB, addresses) in code, tests, logs, commits, docs or prompts. Use obviously fake data (e.g. `Nguyễn Văn A`, `0900000001`, `YT000001`).
- **`/samples/`** holds real PDFs (git-ignored). Never read, copy, parse or quote them. Tests use synthetic fixtures only.
- **Logging**: never log phone numbers or patient names — not to console, crash reports or analytics. Log IDs / counts instead.
- PDFs are parsed on-device and never uploaded anywhere. No network calls for patient data.

## Architecture (summary — see docs/architecture.md)

```text
lib/
  app/            # App widget, go_router config
  core/           # di/, error/, utils/ (phone + date helpers), theme/
  domain/         # Pure Dart: entities/, repositories/ (abstract), usecases/
  data/           # local/ (drift), pdf/ (extractor + parser), repositories/ (impl), services/ (call/SMS/platform channels)
  presentation/   # import/, call_list/, settings/, common/
```

- Dependency rule: `presentation → domain ← data`. `domain` imports neither Flutter nor `data`. `presentation` never imports `data` directly (only via DI).
- State: `flutter_bloc`, MVI style:
  - immutable `State` (equatable / `copyWith`), `Event` as `sealed class`
  - one-off side effects (navigation, snackbar, launch call/SMS, show bottom sheet) go through a **separate effect stream**, never stored in `State`
- DI: `get_it` + `injectable` (annotate with `@injectable` / `@lazySingleton` / `@module`).
- DB: `drift`. Routing: `go_router`. PDF: `pdfrx`. Tests: `flutter_test`, `bloc_test`, `mocktail`.
- PDF pipeline: `PdfTextExtractor` (pdfrx, data layer) → `List<PositionedText>` → `AppointmentListParser` (pure Dart, no Flutter/pdfrx imports, fully unit-tested).
- Bundle id / applicationId: `com.diepthanhduy.assistant_pak`.

## Key domain rules

- Phone numbers are normalized to the VN local form `0xxxxxxxxx` (from `+84…`, `84…`, with spaces / dots / dashes). The clinic phone printed in the PDF header is excluded from call targets.
- `CallTask` is unique per `(date, phoneNormalized)`. Its status derives from the latest `ContactAttempt`; `Appointment` status follows its `CallTask` unless overridden per patient.
- Re-importing the same day dedupes by medical code (Mã Y Tế) and keeps existing call results.
- Calls and SMS share one history table (`ContactAttempt`, `channel = call | sms`).

## Platform constraints (short)

- **Android**: direct call `ACTION_CALL` + `CALL_PHONE` (platform channel), `READ_CALL_LOG` allowed (not on Play Store), direct SMS via `SmsManager` + `SEND_SMS`, SIM choice via `SubscriptionManager` / `PhoneAccountHandle`.
- **iOS**: `tel:` always shows a system confirm (2 taps); no call-log access (`CXCallObserver` gives connected/ended only, no number); SMS only via prefilled composer; no SIM choice.
- Vietnamese SMS with diacritics = UCS-2, ~70 chars/segment (67 when multipart).

Keep platform-specific code behind domain interfaces in `data/services/` so the iOS gaps degrade gracefully.

## Commands

```bash
# One-time bootstrap: flutter create (android/ios), add deps, codegen, analyze
./scripts/setup.sh

# Code generation (injectable, drift). build_runner >= 2.16 ignores --delete-conflicting-outputs.
dart run build_runner build
dart run build_runner watch

# Static analysis & formatting
flutter analyze
dart format lib test

# Tests
flutter test
flutter test test/data/pdf/            # parser tests only

# Run on a connected device
flutter devices
flutter run -d <deviceId>
flutter build apk --release            # sideload APK
```

Generated files (`*.g.dart`, `*.config.dart`) are excluded from analysis; never edit them by hand.

## Testing conventions

- Mirror `lib/` under `test/` (e.g. `test/data/pdf/appointment_list_parser_test.dart`).
- Domain + parser + phone/date utils: plain unit tests, no Flutter binding.
- Blocs: `bloc_test` with `mocktail` mocks of repositories / use cases; assert both states and effects.
- Fixtures are synthetic and built in Dart (see the `pdf-parser-tester` subagent).

## Subagents

- `flutter-reviewer` — read-only review of diffs against this file + docs/architecture.md.
- `pdf-parser-tester` — writes / maintains parser tests in `test/data/pdf/` from synthetic `PositionedText` fixtures.

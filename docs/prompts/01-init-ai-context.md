You are setting up the AI-agent context for this Flutter project so that future Claude Code sessions (and other coding agents) understand the product, architecture and rules without re-explaining. Do NOT write feature code. Only create documentation / agent config files listed below.

## Step 0 — Read first, then propose

1. Read `pubspec.yaml`, `analysis_options.yaml`, `README.md`, `scripts/setup.sh`, and list the `lib/` and `test/` tree.
2. Reply (in Vietnamese) with the exact list of files you will create and a 3–5 line outline of each. Wait for my confirmation before writing anything.

## Step 1 — Files to create

1. `CLAUDE.md` (root, English, concise — target < 200 lines; it is loaded into every session)
2. `AGENTS.md` (root) — one line: `See CLAUDE.md.` plus `@CLAUDE.md` import, so non-Claude agents find the same rules
3. `docs/requirements.md` — product requirements (MVP), English, tables
4. `docs/pdf-format.md` — spec of the input PDF + parser approach
5. `docs/architecture.md` — layers, dependency rule, folder map, state/effect pattern, DI, DB
6. `.claude/agents/flutter-reviewer.md` — subagent for code review
7. `.claude/agents/pdf-parser-tester.md` — subagent that writes/maintains parser tests from synthetic fixtures
8. `.claude/settings.json` — permission rules (see Rules)

Do not modify anything under `lib/`, `test/`, `pubspec.yaml`, `scripts/`, `android/`, `ios/`.

## Project facts (source of truth — put them in the right file)

### Product
- Internal app, single user, no login, no backend in MVP. Android + iOS only, not published to stores.
- Purpose: remind patients (often parents of young children) about vaccination / follow-up appointments by phone call, with SMS as backup.
- Current manual workflow being replaced: export daily list as PDF → tap numbers to call → highlight unreachable numbers in PDF → call again later.
- Data source in MVP: ONLY the clinic software's PDF "DANH SÁCH HẸN TÁI KHÁM". Image/OCR and Excel/CSV are Phase 2.
- One imported PDF = one day's list.
- Patients sharing a phone number are grouped: one call / one SMS reminds the whole group. Sample file: 26 patients → 21 phone groups.
- Calling = normal SIM voice call (no VoIP, no auto-call/TTS). Goal: 1 tap to start a call.

### MVP requirements (P0 unless noted)
- Import: PDF via file picker and share sheet/intent; coordinate-based parsing; skip repeated header per page and the "Tổng Cộng : N" footer; verify parsed count == N, otherwise warn and highlight suspicious rows; normalize VN phone numbers (0xxx / +84, spaces, dots); exclude the clinic phone printed in the header; mandatory review screen (original PDF side-by-side, edit/delete/add rows); re-import same day dedupes by medical code (Mã Y Tế) and keeps existing call results. Manual add = P1. OCR = P2. CSV = P2.
- Daily list: default "Today", pick another date; filter by status (Not called / Retry / Confirmed / Skipped); filter by type, search, progress bar = P1.
- Call: list grouped by phone (one row per number showing all patients + their content); 1-tap call; result applies to the whole group but can be overridden per patient. Sequential "call next" mode = P1. SIM selection in settings = P1 (Android only).
- Result: when the app resumes after a call, show a bottom sheet: Confirmed / No answer / Busy / Unreachable / Wrong number / Reschedule; free-text note; per-patient contact history. Auto-suggest result from call log (Android) / CXCallObserver (iOS) = P1. Reschedule with new date = P1.
- Retry: unreachable results go to "Retry" group; attempt counter; after N attempts (default 3, configurable) → "Unreachable". Min interval + local notification, and customer-requested callback time = P1.
- SMS backup: "Send SMS" on each row and in the result sheet, prefilled from template with placeholders {ten}, {noi_dung}, {ngay_tai_kham}, {ten_phong_kham}, {sdt_phong_kham}; group = list all names in one SMS; default template editable in Settings; SMS logged as a contact attempt. Bulk SMS to Retry group (Android only), multiple templates, strip-diacritics option, age-based salutation from DOB = P1.
- Default template: "Phòng khám {ten_phong_kham} nhắc lịch: {ten} có lịch {noi_dung} ngày {ngay_tai_kham}. Liên hệ {sdt_phong_kham}."

### Non-functional
- Offline-first; PDF parsed on-device, never uploaded.
- Health data = sensitive personal data under Vietnamese law: encrypt local DB (SQLCipher, later), app lock (biometric/PIN), never log phone numbers or patient names (console, crash reports, analytics).
- Auto-delete stored source PDFs after X days (configurable).
- Never commit real patient data. Real sample PDFs live in `/samples/` (git-ignored). Tests use synthetic fixtures only.

### Data model (drift)
| Entity | Key fields | Notes |
| --- | --- | --- |
| Patient | medicalCode (Mã Y Tế, unique), name, dob, address, phoneNormalized | many patients may share a phone |
| Appointment | id, patientId, date, content (Nội Dung), status, importBatchId | status: pending / confirmed / rescheduled / skipped |
| CallTask | id, date, phoneNormalized, status, attemptCount, nextRetryAt | unique (date, phone); status: pending / retry / done / unreachable |
| ContactAttempt | id, callTaskId, channel (call/sms), startedAt, returnedAt, result, durationSec?, source (manual/callLog/callKit), note, smsBody? | single history for calls + SMS |
| ImportBatch | id, date, sourceType, sourceFilePath, expectedCount, parsedCount, createdAt | |
CallTask status derives from the latest ContactAttempt; Appointment status follows CallTask unless overridden.

### PDF format (from the sample, A4 595×842 pt, has a text layer — no OCR needed)
- Header block: clinic org, clinic name, "Điện thoại: <clinic phone>", title "DANH SÁCH HẸN TÁI KHÁM".
- 8 columns, header row repeated at top of every page. Approx. x ranges (pt, from left): STT 8–26 · Mã Y Tế 38–77 · Tên Bệnh Nhân 86–165 · Ngày Sinh 181–227 · Địa Chỉ 242–338 · Số ĐT 358–408 · Nội Dung 428–505 · Ngày Tái Khám 516–580.
- Each record starts at a line where STT is an integer; overflow lines (name, address, content wrap) appear ~13 pt below, before the next STT → attach to the nearest record above.
- Text extraction order is NOT reading order → parse by coordinates (derive column boundaries from header text positions, not hard-coded numbers; hard-coded ranges only as fallback).
- Footer: "Tổng Cộng : N", then a print date line "Ngày dd tháng mm năm yyyy" (ignore).
- Dates dd/MM/yyyy. All Ngày Tái Khám values in one file are expected to be equal → that is the list date; warn if not.
- pdfrx 2.10: `PdfDocument.openFile(path)`, `page.loadStructuredText()` → `PdfPageText` with `fragments` (`text`, `bounds`, `charRects`); `PdfRect` origin is bottom-left, y up (`top > bottom`). Convert to top-left before row grouping.
- Parser design: `PdfTextExtractor` (pdfrx, data layer) → `List<PositionedText>` → pure-Dart `AppointmentListParser` (no Flutter/pdfrx imports, fully unit-tested).

### Platform constraints
- Android (sideloaded APK): direct call via `ACTION_CALL` + `CALL_PHONE` (platform channel); `READ_CALL_LOG` allowed since not on Play Store; direct SMS via `SmsManager` + `SEND_SMS`; SIM choice via `SubscriptionManager`/`PhoneAccountHandle`.
- iOS: `tel:` always shows a system confirm → 2 taps; no call log access, `CXCallObserver` gives connected/ended without number (needs PoC); SMS only via prefilled composer, user taps Send; no SIM choice.
- iOS distribution: no Apple Developer account yet → Android first; later Ad Hoc for one device.
- Vietnamese SMS with diacritics = UCS-2, ~70 chars per segment; show segment counter in template editor.

### Tech stack & architecture
- Flutter, single package, Clean Architecture by layer: `lib/core` (di, error, utils, theme), `lib/domain` (entities, repositories, usecases — pure Dart), `lib/data` (local/drift, pdf, repositories, services), `lib/presentation` (import, call_list, settings, common), `lib/app` (app, router).
- Dependency rule: presentation → domain ← data. Domain imports neither Flutter nor data.
- State: flutter_bloc, MVI style — immutable State, Events (sealed classes), one-off side effects (navigation, snackbar, launch call) via a separate effect stream, not in State.
- DI: get_it + injectable (`dart run build_runner build --delete-conflicting-outputs`). DB: drift. Routing: go_router. PDF: pdfrx. Tests: flutter_test, bloc_test, mocktail.
- Bundle id: com.diepthanhduy.assistant_pak.

### Roadmap
- Phase 0 PoC (Android): parse sample PDF → 26 rows matching "Tổng Cộng", 21 CallTasks; 1-tap call + call log read; direct SMS.
- Phase 1 MVP Android: all P0. Gate: 1–2 weeks real use replacing PDF + highlight workflow.
- Phase 1.1: P1 + iOS (developer account, CXCallObserver + SMS composer PoC, Ad Hoc).
- Phase 2: image/OCR, CSV, stats, Zalo ZNS, sync.

### Open questions (keep in docs/requirements.md)
- Accept 2 taps to call on iOS?
- Clinic name/phone for SMS: auto from PDF header or fixed in Settings?
- When to register Apple Developer?

## Rules to encode in CLAUDE.md (and agents)
- Talk to the user in Vietnamese; keep technical terms in English; code comments always English.
- Peer-to-peer tone, straight to the point, no 101 explanations.
- Before modifying code: review and propose; apply only after the user agrees. Fix typos/format/naming freely.
- Ask before: changing architecture/folder structure, adding a dependency, editing `pubspec.yaml` / build configs / Gradle / Xcode settings.
- When several solutions exist: list options with trade-offs and state a recommendation.
- NEVER run git push or any git delete operation (branch delete, `git rm`, `reset --hard`, `clean`, force operations). The user does those.
- Never put real patient data in code, tests, logs, commits or docs.
- Commands section: setup (`./scripts/setup.sh`), codegen, `flutter analyze`, `flutter test`, run on device.

`.claude/settings.json`: deny `Bash(git push:*)`, `Bash(git branch -d:*)`, `Bash(git branch -D:*)`, `Bash(git rm:*)`, `Bash(git reset --hard:*)`, `Bash(git clean:*)`, `Bash(git push --force:*)`, and `Read(./samples/**)`; allow `Bash(flutter analyze)`, `Bash(flutter test:*)`, `Bash(dart run build_runner:*)`, `Bash(dart format:*)`.

## Subagents
- `flutter-reviewer`: reviews diffs against CLAUDE.md + docs/architecture.md (layer violations, bloc state/effect misuse, missing tests, PII in logs, platform constraints). Read-only tools. Output: findings ranked by severity with suggested fix; never edits.
- `pdf-parser-tester`: builds synthetic `PositionedText` fixtures that mimic docs/pdf-format.md (wrapped lines, page-2 header, footer total, shared phones, mismatched total) and writes/updates tests in `test/data/pdf/`. Never uses files from `/samples/`.

## Step 2 — After writing
Show me the file list with line counts and a short summary (Vietnamese). Do not commit.

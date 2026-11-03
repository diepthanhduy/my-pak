Implement PDF import: extractor, parser, review screen and save. Requirements IMP-01…IMP-09. The parsing spec is docs/pdf-format.md — follow it exactly (coordinates, header band, overflow lines, footer, warnings, phone normalization).

## Step 0 — Plan first
Read CLAUDE.md, docs/pdf-format.md, docs/requirements.md §2.1, docs/architecture.md and existing `lib/data/local` (from prompt 03). Verify the installed pdfrx API (`pubspec.lock` version, the package source in the pub cache) against docs/pdf-format.md "pdfrx API notes" and report differences. Reply in Vietnamese with the plan and file list. Wait for my OK.

## Part A — Parser (do this first, fully tested before any UI)
- `lib/data/pdf/positioned_text.dart`, `parsed_appointment_list.dart` (result + row + warning types), `appointment_list_parser.dart` (pure Dart, no Flutter/pdfrx imports), `pdf_text_extractor.dart` (pdfrx → `List<PositionedText>`, top-left coordinates, splits fragments spanning two columns using `charRects`).
- `lib/core/utils/phone_normalizer.dart` (pure Dart) per docs/pdf-format.md §5.
- Use the `pdf-parser-tester` subagent to build synthetic fixtures for every scenario in docs/pdf-format.md §7 in `test/data/pdf/`. No file from `/samples/` is ever read by tests or committed.
- Add a debug-only integration check I can run locally: `dart run tool/parse_sample.dart <path>` (or an integration test) printing ONLY counts: rows, expectedCount, phone groups, warnings by type. Never print names/phones. Expected on my sample: 26 rows, total 26, 21 phone groups, 0 count-mismatch warnings.

## Part B — Import flow
1. **Entry points**: FAB "Import PDF" on Home and empty state → `/import`; Android share intent / iOS "Open in" for `application/pdf` (IMP-02). Native config changes (AndroidManifest intent-filter, iOS `CFBundleDocumentTypes` / `LSSupportsOpeningDocumentsInPlace`) touch build config → list them in the plan for my approval. If a share-intent package is needed, ask before adding it.
2. **Pick**: `file_picker` limited to PDF. Copy the file into app documents dir (`imports/<batchId>.pdf`); this copy is what the review screen shows and what auto-delete (SET-04, later) removes.
3. **Parsing state**: progress indicator; parse in an isolate (`compute`/`Isolate.run`) if it blocks the UI.
4. **Review screen** (`/import/review`):
   - Header: list date, clinic name/phone detected, "Đã đọc 26 / Tổng cộng 26" (red when mismatched), number of phone groups.
   - Warning banner summarizing warnings by type; tapping filters to affected rows.
   - Rows list grouped by phone (same grouping as Home) with per-row warning icon. Tap a row → edit sheet (name, DOB, phone, content, date). Swipe/delete; "Thêm dòng" adds a manual row.
   - "Xem PDF gốc" opens the copied PDF (pdfrx viewer) — on tablets/landscape show side-by-side, on phones a toggle/tab.
   - Primary button "Lưu danh sách" (disabled while blocking errors exist: invalid phone on a row not deleted).
5. **Save** (use case `SaveImportBatch` in domain, transaction in data):
   - Insert `ImportBatch` (expectedCount, parsedCount, sourceFilePath).
   - Upsert patients by `medicalCode`; insert appointments; create/merge `CallTask` per `(date, phoneNormalized)`.
   - Re-import same date (IMP-09): keep existing CallTasks and ContactAttempts and their statuses; only add new patients/appointments; report "Thêm X bệnh nhân mới, Y đã có".
   - Rows with clinic phone are excluded from CallTasks.
   - After save → navigate to Home on that date + snackbar.
6. Cancel at any step deletes the copied file and leaves DB untouched.

## Architecture
- `ImportBloc` (pick → parsing → review → saving → done/error) with effects for navigation/snackbar; review edits are events on the same bloc or a dedicated `ImportReviewBloc` — propose in the plan.
- Domain: `ImportRepository` interface + use cases `ParseAppointmentPdf`, `SaveImportBatch`. Data: `ImportRepositoryImpl` using extractor + parser + `ImportDao`.

## Tests
- Parser: all §7 scenarios + warnings table §4.
- Phone normalizer table §5.
- `SaveImportBatch` with in-memory drift: grouping, re-import dedupe keeps history, clinic phone excluded.
- `ImportBloc` states/effects with bloc_test.
- Widget test: review header shows mismatch in red.

## Done when
Analyze + tests pass; importing my sample on a device lands 21 call tasks on Home for 15/12/2025. Short Vietnamese summary. Do not commit.

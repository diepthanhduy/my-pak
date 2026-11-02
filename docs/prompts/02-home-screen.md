Implement the Home screen ("Danh sách gọi" for a selected day). Follow CLAUDE.md, docs/architecture.md and docs/requirements.md.

## Step 0 — Plan first
Read CLAUDE.md, docs/*.md and the current `lib/` tree. Reply in Vietnamese with: files to create/modify, State/Event/Effect design, and any question. Wait for my OK before writing code.

## Purpose
Home is the main screen of the app. It shows all CallTasks for one day (default: today). From here the user calls or texts each phone group with one tap and sees at a glance who is still left to call.

## Layout (top → bottom)
1. **AppBar**
   - Title: selected date, e.g. "Hôm nay · 15/12/2025" (or "Thứ Hai · 15/12/2025" if not today).
   - Left/right chevrons to move to previous/next day; tap title → date picker.
   - Action: settings icon (navigate to `/settings`, stub page is fine).
2. **Progress summary** (card under AppBar)
   - "Đã liên hệ X / Y số" + LinearProgressIndicator.
   - Small line: "Z bệnh nhân · N số cần gọi lại".
3. **Filter chips** (horizontal scroll, single select, each with count):
   Tất cả · Chưa gọi · Gọi lại · Đã xác nhận · Không liên lạc được.
4. **List of CallTask cards** (one card = one phone number)
   - Header row: phone formatted `0918 602 480`, status badge (color by status), attempt counter "Lần 2/3" when attempts > 0.
   - Body: one line per patient in the group: name (bold) · age derived from DOB ("3 tuổi", "8 tháng" when < 1 year) · content (Nội Dung, max 2 lines, ellipsis).
   - If the group has > 1 patient show a chip "3 người".
   - Last contact line (quiet text) when available: "Không nghe máy · 14:32".
   - Actions: primary **Gọi** button (FilledButton, icon phone), secondary **SMS** (OutlinedButton). Whole card tap → `/call-task/:id` (stub page).
   - Sort order: Chưa gọi → Gọi lại (earliest nextRetryAt first) → Đã xác nhận → Không liên lạc được; within a group keep PDF order (STT).
5. **FAB (extended)**: "Import PDF" → navigate to `/import` (stub page).

## States
- Loading: skeleton/progress.
- Empty day (no ImportBatch for that date): illustration-free empty state — "Chưa có danh sách cho ngày này" + button "Import PDF".
- Empty filter result: "Không có số nào ở trạng thái này".
- Data: as above.
- Error: message + retry.

## Behaviour
- Tap **Gọi**: emit a side effect to start the call through a `PhoneLauncher` service (domain interface; data impl may use url_launcher `tel:` for now — direct ACTION_CALL comes later). Record `startedAt` for the CallTask so the result bottom sheet (next prompt, out of scope here) can open on app resume.
- Tap **SMS**: build SMS body from the default template (all patient names of the group joined by ", "), emit effect to open the SMS composer via `PhoneLauncher`.
- Changing date or filter keeps scroll position reset to top.
- List reacts to data changes (repository exposes a `Stream`).

## Architecture
- Bloc (MVI): `HomeBloc` with immutable `HomeState` (selectedDate, filter, tasks, counts, status), sealed `HomeEvent` (started, dateChanged, filterChanged, callPressed, smsPressed, retryPressed), and one-off `HomeEffect` (launchCall, launchSms, navigate, showMessage) on a separate stream — not in State.
- Domain: minimal entities needed (`CallTask`, `PatientAppointment`, enums for statuses/results), `CallTaskRepository.watchByDate(DateTime)`, use cases `WatchCallTasksByDate`, `StartCall`, `SendSmsReminder`, `PhoneLauncher` interface.
- Data: the drift DB is not built yet → provide `InMemoryCallTaskRepository` with SYNTHETIC data (fake names/phones, include: a 3-patient shared phone, a child < 1 year, one retry task with 2 attempts, one confirmed, one unreachable). Register with injectable under an `@dev`/fake environment so it can be swapped later.
- Presentation: `lib/presentation/call_list/` → `home_page.dart`, `bloc/`, `widgets/` (call_task_card, progress_summary, status_filter_bar, empty_state). Keep widgets small and stateless.
- Routing: introduce go_router in `lib/app/router.dart` with `/` (Home), `/import`, `/settings`, `/call-task/:id` (stubs). This changes `app.dart` — mention it in the plan.
- UI strings in Vietnamese, centralized in one file (no i18n package yet). Material 3, works in light and dark theme, touch targets ≥ 48dp.

## Constraints
- No new dependencies beyond those in `scripts/setup.sh`; if you think one is needed, ask.
- No real patient data anywhere. Do not log phone numbers or names.
- Code comments in English.

## Tests
- `HomeBloc` with bloc_test + mocktail: initial load, filter change counts, date change, call/SMS effects.
- Pure functions: age formatting, phone formatting, sort order, SMS body building.
- Widget test: card renders a 3-patient group with "3 người" chip and both buttons.

## Done when
`flutter analyze` is clean, `flutter test` passes, and the app runs showing the fake data. Reply with a short Vietnamese summary and what is stubbed for the next prompts (result bottom sheet, import flow, drift repository). Do not commit.

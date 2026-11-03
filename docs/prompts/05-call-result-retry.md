Implement the call result bottom sheet and retry logic. Requirements RES-01…RES-03, RTY-01…RTY-03, SMS-01 (in sheet), SMS-05. Flow: docs/architecture.md §3 "Call → result flow".

## Step 0 — Plan first
Read CLAUDE.md, docs/requirements.md §2.4–2.6, docs/architecture.md, and current Home bloc/effects + drift repositories. Reply in Vietnamese with the plan, the status-derivation rules as a table, and file list. Wait for my OK.

## Behaviour
1. **Pending attempt**: tapping Gọi already records a `ContactAttempt(channel: call, startedAt)` with no result. Persisting it (not only in memory) means the sheet still appears if the app was killed during the call.
2. **On resume**: Home listens to `AppLifecycleState.resumed` → `AppResumed` event → bloc asks a use case `GetPendingCallAttempt` → effect `ShowResultSheet(callTask, attempt)`. Also check on app start (cold start after kill). Ignore resumes when no pending attempt exists.
3. **Result bottom sheet** (`presentation/call_list/widgets/call_result_sheet.dart`):
   - Header: phone + patients of the group + "Lần N".
   - Elapsed time since `startedAt` as a hint only ("Rời app 0:08"); if < 15 s pre-highlight "Không nghe máy" (suggestion, user still taps).
   - Result buttons, large, one tap each = submit: Đã xác nhận · Không nghe máy · Máy bận · Không liên lạc được · Sai số · Xin đổi lịch.
   - Optional note field (collapsed "Thêm ghi chú").
   - Per-patient override (CALL-03): expandable list where each patient can get a different outcome (e.g. one reschedules). Default = applies to all.
   - Secondary action "Gửi SMS" → submits "Không nghe máy" (or the chosen result) then opens SMS composer prefilled from template; logs an SMS attempt (SMS-05).
   - Dismiss without choosing → attempt stays pending; Home card shows "Chưa ghi kết quả" with a button to reopen the sheet.
   - "Xin đổi lịch" in MVP: mark appointment `rescheduled` + note; picking a new date is P1 (RES-05) — leave a TODO hook.
4. **Status derivation** (one domain use case `RecordContactResult`, the only place that computes it):
   - confirmed → CallTask `done`, appointments `confirmed` (unless overridden).
   - noAnswer / busy / unreachable → attemptCount += 1; if attemptCount ≥ `maxAttempts` (settings) → `unreachable`, else `retry`.
   - wrongNumber → `unreachable` immediately, appointments keep `pending` (flag for manual handling).
   - rescheduled → CallTask `done`, that appointment `rescheduled`.
   - SMS attempts do not increase attemptCount and do not change status.
   - Mixed per-patient outcomes: CallTask `done` only when every appointment is resolved (confirmed/rescheduled/skipped).
5. Home re-sorts automatically (stream). After submit, optional "Gọi số tiếp theo" snackbar action (CALL-04 light version).

## Tests
- `RecordContactResult`: every row of the derivation table, maxAttempts boundary, SMS no-increment, mixed outcomes.
- `HomeBloc`: resume with/without pending attempt, cold-start pending attempt, submit → state update.
- Widget: sheet renders group, tapping a result submits once.

## Done when
Analyze + tests pass; on device: call → return → sheet → result → card moves to the right group with correct "Lần N/3". Short Vietnamese summary. Do not commit.

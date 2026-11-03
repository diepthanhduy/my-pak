Implement the call task detail screen `/call-task/:id`. Requirements RES-02, RES-03, CALL-03.

## Step 0 — Plan first
Read CLAUDE.md, docs/requirements.md, current router stub `call_task_page.dart`, drift DAOs and `RecordContactResult` (prompt 05). Reply in Vietnamese with plan + file list. Wait for my OK.

## Screen
1. **Header**: formatted phone, status badge, "Lần N/max", next action buttons Gọi / SMS (same use cases and effects as Home).
2. **Bệnh nhân** section: one tile per patient in the group — name, age, DOB, medical code, content, appointment status chip. Tap status chip → change status for that patient only (confirmed / rescheduled / skipped / pending) through `RecordContactResult` or a dedicated use case — keep the single source of status rules.
3. **Lịch sử liên hệ** (RES-03): timeline newest first — icon call/SMS, time, result, duration if known, note, source (manual / callLog). SMS entries show the body collapsed.
4. **Ghi chú**: add a note without making a call. Do not fake it as a call attempt. Propose either a `notes` column/table on CallTask or a new attempt channel `note`, with the trade-off, in the plan.
5. **Đặt lại trạng thái**: overflow menu action "Đưa về Chưa gọi" (reset status + attemptCount, history kept) with confirm dialog.
6. Pending attempt without result → banner "Chưa ghi kết quả" + button to open the result sheet.

## Architecture
- `CallTaskDetailBloc` watching `CallTaskRepository.watchById(id)` + `watchAttempts(id)` (add to repo + DAO). Effects for call/SMS/snackbar/back.
- Unknown id → error state with back button.

## Tests
- Bloc: load, live update when an attempt is added, per-patient status change, reset.
- Widget: history renders call and SMS entries in correct order.

## Done when
Analyze + tests pass; opening a card from Home shows history that matches what was recorded. Short Vietnamese summary. Do not commit.

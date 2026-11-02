# Requirements — Assistant PAK (MVP)

## 1. Context

| Item | Value |
| --- | --- |
| Users | One internal user (clinic staff), no login |
| Platforms | Android + iOS, not published to stores (Android sideloaded APK first, iOS Ad Hoc later) |
| Backend | None in MVP — offline-first, all data on device |
| Purpose | Remind patients (often parents of young children) about vaccination / follow-up appointments by phone call, SMS as backup |
| Data source (MVP) | Only the clinic software's PDF "DANH SÁCH HẸN TÁI KHÁM" (see [pdf-format.md](pdf-format.md)) |
| Unit of import | One PDF = one day's list |
| Calling | Normal SIM voice call — no VoIP, no auto-call, no TTS. Goal: 1 tap to start a call |

### Workflow being replaced

1. Export the daily list as PDF from the clinic software.
2. Tap phone numbers in the PDF to call.
3. Highlight unreachable numbers in the PDF.
4. Call highlighted numbers again later.

### Phone grouping

Patients sharing a phone number (siblings, same parent) are grouped: **one call / one SMS reminds the whole group**. Sample file: 26 patients → 21 phone groups.

## 2. Functional requirements

Priority: **P0** = MVP must-have · **P1** = Phase 1.1 · **P2** = Phase 2.

### 2.1 Import

| ID | Requirement | Priority |
| --- | --- | --- |
| IMP-01 | Import PDF via file picker | P0 |
| IMP-02 | Import PDF via share sheet / Android intent | P0 |
| IMP-03 | Coordinate-based parsing (not text extraction order) | P0 |
| IMP-04 | Skip the header row repeated on every page and the `Tổng Cộng : N` footer | P0 |
| IMP-05 | Verify parsed count == N; otherwise warn and highlight suspicious rows | P0 |
| IMP-06 | Normalize VN phone numbers (`0xxx`, `+84`, spaces, dots) | P0 |
| IMP-07 | Exclude the clinic phone printed in the PDF header from call targets | P0 |
| IMP-08 | Mandatory review screen: original PDF side-by-side, edit / delete / add rows before saving | P0 |
| IMP-09 | Re-import same day: dedupe by medical code (Mã Y Tế), keep existing call results | P0 |
| IMP-10 | Manually add a patient / appointment outside of import | P1 |
| IMP-11 | Import from image (OCR) | P2 |
| IMP-12 | Import from Excel / CSV | P2 |

### 2.2 Daily list

| ID | Requirement | Priority |
| --- | --- | --- |
| LST-01 | Default view "Today"; pick another date | P0 |
| LST-02 | Filter by status: Not called / Retry / Confirmed / Skipped | P0 |
| LST-03 | Filter by appointment type (Nội Dung) | P1 |
| LST-04 | Search by name / phone | P1 |
| LST-05 | Progress bar (done / total) | P1 |

### 2.3 Call

| ID | Requirement | Priority |
| --- | --- | --- |
| CAL-01 | List grouped by phone: one row per number showing all patients + their content | P0 |
| CAL-02 | 1-tap call (Android direct call; iOS `tel:` = 2 taps) | P0 |
| CAL-03 | Result applies to the whole group, overridable per patient | P0 |
| CAL-04 | Sequential "call next" mode | P1 |
| CAL-05 | SIM selection in Settings (Android only) | P1 |

### 2.4 Result

| ID | Requirement | Priority |
| --- | --- | --- |
| RES-01 | When the app resumes after a call, show a bottom sheet: Confirmed / No answer / Busy / Unreachable / Wrong number / Reschedule | P0 |
| RES-02 | Free-text note per attempt | P0 |
| RES-03 | Per-patient contact history (calls + SMS) | P0 |
| RES-04 | Auto-suggest result from call log (Android) / `CXCallObserver` (iOS) | P1 |
| RES-05 | Reschedule with a new date | P1 |

### 2.5 Retry

| ID | Requirement | Priority |
| --- | --- | --- |
| RTY-01 | Unreachable results (No answer / Busy / Unreachable) go to the "Retry" group | P0 |
| RTY-02 | Attempt counter per phone group | P0 |
| RTY-03 | After N attempts (default 3, configurable) → status "Unreachable" | P0 |
| RTY-04 | Minimum interval between attempts + local notification when due | P1 |
| RTY-05 | Customer-requested callback time | P1 |

### 2.6 SMS backup

| ID | Requirement | Priority |
| --- | --- | --- |
| SMS-01 | "Send SMS" action on each row and in the result sheet | P0 |
| SMS-02 | Prefilled from template with placeholders (see below) | P0 |
| SMS-03 | Group SMS lists all patient names in one message | P0 |
| SMS-04 | Default template editable in Settings | P0 |
| SMS-05 | SMS logged as a contact attempt (`channel = sms`) | P0 |
| SMS-06 | Segment counter in template editor (UCS-2, ~70 chars/segment) | P0 |
| SMS-07 | Bulk SMS to the Retry group (Android only, `SmsManager`) | P1 |
| SMS-08 | Multiple templates | P1 |
| SMS-09 | Strip-diacritics option (GSM-7, 160 chars/segment) | P1 |
| SMS-10 | Age-based salutation derived from DOB | P1 |

**Placeholders**

| Placeholder | Value |
| --- | --- |
| `{ten}` | Patient name(s); for a group, all names joined |
| `{noi_dung}` | Appointment content (Nội Dung) |
| `{ngay_tai_kham}` | Appointment date, `dd/MM/yyyy` |
| `{ten_phong_kham}` | Clinic name |
| `{sdt_phong_kham}` | Clinic phone |

**Default template**

```text
Phòng khám {ten_phong_kham} nhắc lịch: {ten} có lịch {noi_dung} ngày {ngay_tai_kham}. Liên hệ {sdt_phong_kham}.
```

### 2.7 Settings

| ID | Requirement | Priority |
| --- | --- | --- |
| SET-01 | Edit SMS template | P0 |
| SET-02 | Max retry attempts (default 3) | P0 |
| SET-03 | Clinic name / phone for SMS (see open questions) | P0 |
| SET-04 | Auto-delete stored source PDFs after X days | P0 |
| SET-05 | SIM selection (Android) | P1 |
| SET-06 | Retry minimum interval | P1 |

## 3. Non-functional requirements

| ID | Requirement | Notes |
| --- | --- | --- |
| NFR-01 | Offline-first | No network needed for any MVP feature |
| NFR-02 | PDF parsed on-device, never uploaded | |
| NFR-03 | Health data = sensitive personal data under Vietnamese law | Drives NFR-04..07 |
| NFR-04 | Encrypt local DB | SQLCipher — later (not Phase 0) |
| NFR-05 | App lock (biometric / PIN) | |
| NFR-06 | Never log phone numbers or patient names | Console, crash reports, analytics |
| NFR-07 | Auto-delete stored source PDFs after X days (configurable) | |
| NFR-08 | Never commit real patient data | Real PDFs live in `/samples/` (git-ignored); tests use synthetic fixtures |

## 4. Data model (drift)

| Entity | Key fields | Notes |
| --- | --- | --- |
| Patient | medicalCode (Mã Y Tế, unique), name, dob, address, phoneNormalized | Many patients may share a phone |
| Appointment | id, patientId, date, content (Nội Dung), status, importBatchId | status: pending / confirmed / rescheduled / skipped |
| CallTask | id, date, phoneNormalized, status, attemptCount, nextRetryAt | Unique `(date, phoneNormalized)`; status: pending / retry / done / unreachable |
| ContactAttempt | id, callTaskId, channel (call/sms), startedAt, returnedAt, result, durationSec?, source (manual/callLog/callKit), note, smsBody? | Single history for calls + SMS |
| ImportBatch | id, date, sourceType, sourceFilePath, expectedCount, parsedCount, createdAt | |

- `CallTask.status` derives from the latest `ContactAttempt`.
- `Appointment.status` follows its `CallTask` unless overridden per patient.

## 5. Platform constraints

| Topic | Android (sideloaded) | iOS |
| --- | --- | --- |
| Start call | `ACTION_CALL` + `CALL_PHONE` via platform channel → 1 tap | `tel:` always shows system confirm → 2 taps |
| Call outcome | `READ_CALL_LOG` allowed (not on Play Store) | No call-log access; `CXCallObserver` gives connected / ended without number (needs PoC) |
| SMS | Direct send via `SmsManager` + `SEND_SMS` | Prefilled composer only; user taps Send |
| SIM choice | `SubscriptionManager` / `PhoneAccountHandle` | Not possible |
| Distribution | APK sideload | No Apple Developer account yet → later Ad Hoc for one device |

SMS encoding: Vietnamese with diacritics = UCS-2, 70 chars single segment / 67 per segment when multipart. Without diacritics = GSM-7, 160 / 153.

## 6. Roadmap

| Phase | Scope | Exit gate |
| --- | --- | --- |
| 0 — PoC (Android) | Parse sample PDF → 26 rows matching `Tổng Cộng`, 21 CallTasks; 1-tap call + call-log read; direct SMS | All three work on a real device |
| 1 — MVP Android | All P0 | 1–2 weeks of real use replacing the PDF + highlight workflow |
| 1.1 | P1 + iOS (developer account, `CXCallObserver` + SMS composer PoC, Ad Hoc) | |
| 2 | Image/OCR, CSV, stats, Zalo ZNS, sync | |

## 7. Open questions

| # | Question | Status |
| --- | --- | --- |
| Q1 | Accept 2 taps to call on iOS? | Open |
| Q2 | Clinic name / phone for SMS: auto from PDF header or fixed in Settings? | Open |
| Q3 | When to register the Apple Developer account? | Open |

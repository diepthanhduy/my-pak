Implement Android native services: 1-tap direct call, call-log based result suggestion, direct SMS. Requirements CALL-02 (1 tap), RES-04 (P1, Android part), SMS-07 groundwork. iOS keeps `url_launcher` behaviour. See docs/architecture.md §6 and docs/requirements.md §5.

## Step 0 — Plan first
Read CLAUDE.md, docs/architecture.md §6, current `PhoneLauncher` + `UrlPhoneLauncher`, and `android/app/src/main/AndroidManifest.xml` + `MainActivity.kt`. Note: architecture.md names services `PhoneCallService` / `CallLogService` / `SmsService` while code has `PhoneLauncher` — propose how to reconcile (rename vs keep) before coding. This prompt changes AndroidManifest and native Kotlin code → list every manifest/permission/Gradle change for my approval. Do not add a package without asking; prefer a small hand-written MethodChannel. Wait for my OK.

## Scope
1. **MethodChannel** `com.diepthanhduy.assistant_pak/telephony` in Kotlin (`TelephonyChannel.kt`, registered in `MainActivity`):
   - `startCall(phone)` → `Intent.ACTION_CALL` with `tel:` URI. Requires `CALL_PHONE`.
   - `lastCall(phone, sinceEpochMs)` → query `CallLog.Calls` for OUTGOING calls to the normalized number after `since`; return `{durationSec, type, date}` or null. Requires `READ_CALL_LOG`. Compare numbers after normalization on both sides (+84 vs 0).
   - `sendSms(phone, body)` → `SmsManager.divideMessage` + `sendMultipartTextMessage`, return sent result via PendingIntent/BroadcastReceiver. Requires `SEND_SMS`. Use `context.getSystemService(SmsManager::class.java)` on API 31+.
   - `capabilities()` → which features are available.
2. **Permissions**: request at first use with a short Vietnamese rationale dialog (use the platform channel or `ActivityCompat`; if `permission_handler` is preferred, ask first). Denied → fall back to `url_launcher` (dialer / SMS composer) and show a one-time hint.
3. **Dart side** (`data/services/`): Android implementation using the channel; iOS + fallback implementation using url_launcher. Selected by `Platform.isAndroid` in the DI module.
4. **Result suggestion** (RES-04, Android): when the result sheet opens, query `lastCall`: duration > 0 → do not pre-select a result (connected does not mean confirmed), only show the hint "Đã kết nối 1:24"; duration 0 / no entry → pre-highlight "Không nghe máy". Store `durationSec` and `source = callLog` on the attempt. User still confirms.
5. **Direct SMS**: "Gửi SMS" sends directly on Android (with a confirm sheet showing the rendered body + segment count), logs attempt after the send callback; iOS opens composer.
6. Dual SIM (SET-05) is out of scope — leave the channel method signature open for an optional `subscriptionId`.

## Privacy
- Never log phone numbers in Kotlin (`Log`) or Dart. Only log booleans/durations.

## Tests
- Dart: service selection + fallback when permission denied (mock channel with `TestDefaultBinaryMessengerBinding`).
- Kotlin: keep logic minimal; number-normalization helper unit-tested in Dart and mirrored in Kotlin.
- Manual test checklist (write to `docs/manual-tests/android-telephony.md`): 1-tap call, call log suggestion connected / not answered, direct SMS single + multipart, permission denied fallback.

## Done when
Analyze + tests pass; on a real Android phone Gọi starts the call without opening the dialer, result sheet shows the call-log hint, SMS sends directly. Short Vietnamese summary. Do not commit.

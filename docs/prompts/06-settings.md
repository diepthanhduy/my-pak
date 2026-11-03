Implement the Settings screen. Requirements SET-01…SET-04, SMS-04, SMS-06.

## Step 0 — Plan first
Read CLAUDE.md, docs/requirements.md §2.6–2.7 and §7 (open question on clinic name/phone), current `SettingsRepository` and `sms_template_renderer.dart`. Reply in Vietnamese with plan + file list. Wait for my OK.

## Screen `/settings`
1. **Phòng khám**: clinic name, clinic phone. Default = last values detected from an imported PDF header; user can override. Show "Lấy từ PDF" chip when the value is auto-detected.
2. **Mẫu SMS** (SMS-04, SMS-06):
   - Multiline editor with placeholder chips that insert at cursor: {ten}, {noi_dung}, {ngay_tai_kham}, {ten_phong_kham}, {sdt_phong_kham}.
   - Live preview rendered with a synthetic sample group (2 patients, fake names).
   - Segment counter under preview: characters, encoding (UCS-2 if any non-GSM-7 char, else GSM-7), segments (UCS-2: 70 single / 67 per part; GSM-7: 160 / 153). Pure Dart util in `core/utils/sms_segments.dart`.
   - Validation: unknown placeholder → inline error; empty template not allowed. "Khôi phục mặc định".
3. **Gọi lại**: max attempts stepper 1–5 (default 3, SET-02).
4. **Dữ liệu**: auto-delete source PDFs after N days (7/14/30/never, default 30) (SET-04). The deletion runs on app start (use case `CleanupOldImports`), deletes files only (DB rows keep `sourceFilePath` = null after delete).
5. **Về app**: version, build.

## Architecture
- `SettingsCubit` (simple form state) is acceptable here; effects for snackbar "Đã lưu". Save on change with debounce or explicit "Lưu" button — propose.
- Extend `ReminderSettings` / `SettingsRepository` (drift from prompt 03) with `autoDeleteDays`.

## Tests
- `sms_segments`: GSM-7 vs UCS-2 detection, boundaries 70/67/160/153.
- Template validation + renderer with group names.
- `CleanupOldImports` with a fake clock + temp dir.
- Cubit save/restore default.

## Done when
Analyze + tests pass; changing template is reflected in the SMS opened from Home. Short Vietnamese summary. Do not commit.

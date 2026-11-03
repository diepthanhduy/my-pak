# Input PDF format — "DANH SÁCH HẸN TÁI KHÁM"

Spec of the clinic software's daily appointment list and how we parse it. Derived from a real sample (kept in `/samples/`, git-ignored — **never read or quote it in code, tests or docs**). All examples below are synthetic.

## 1. Document

| Property | Value |
| --- | --- |
| Page size | A4, 595 × 842 pt |
| Text layer | Yes — no OCR needed |
| Pages | 1..n; one file = one day's list |
| Date format | `dd/MM/yyyy` |

## 2. Layout

```text
┌─────────────────────────────────────────────────────────────┐
│ <Clinic organization>                                       │  header block
│ <Clinic name>                                               │  (page 1 only)
│ Điện thoại: <clinic phone>                                  │
│                DANH SÁCH HẸN TÁI KHÁM                       │
├────┬────────┬──────────┬────────┬────────┬──────┬────────┬──┤
│STT │Mã Y Tế │Tên Bệnh  │Ngày    │Địa Chỉ │Số ĐT │Nội Dung│Ngày Tái Khám │  column header
│    │        │Nhân      │Sinh    │        │      │        │              │  (repeated on every page)
├────┼────────┼──────────┼────────┼────────┼──────┼────────┼──┤
│ 1  │YT000001│Nguyễn Văn│01/01/  │Số 1,   │0900  │Tiêm    │02/11/2026    │  record start (STT = int)
│    │        │A         │2024    │Phường X│000001│ngừa ...│              │  overflow line (~13 pt below)
│ 2  │ ...                                                     │
└─────────────────────────────────────────────────────────────┘
Tổng Cộng : N                                                     footer (last page)
Ngày dd tháng mm năm yyyy                                         print date (ignore)
```

### Columns

Approximate x ranges (pt, from page left), measured on the sample. **Use only as a fallback** — derive boundaries from header text positions at runtime.

| # | Header text | Field | Approx. x range |
| --- | --- | --- | --- |
| 1 | STT | row number (int) | 8–26 |
| 2 | Mã Y Tế | `medicalCode` | 38–77 |
| 3 | Tên Bệnh Nhân | `name` | 86–165 |
| 4 | Ngày Sinh | `dob` | 181–227 |
| 5 | Địa Chỉ | `address` | 242–338 |
| 6 | Số ĐT | `phone` (raw) | 358–408 |
| 7 | Nội Dung | `content` | 428–505 |
| 8 | Ngày Tái Khám | `appointmentDate` | 516–580 |

Header labels may themselves wrap onto two lines (e.g. "Tên Bệnh" / "Nhân", "Ngày Tái" / "Khám"); match them by joining fragments in the header band.

## 3. Parsing rules

1. **Coordinates, not extraction order.** Text extraction order is NOT reading order. Always sort / group by position.
2. **Coordinate system.** pdfrx `PdfRect` has origin bottom-left, y up (`top > bottom`). Convert to top-left origin (`yTop = pageHeight - rect.top`) in the extractor, before any row grouping. The parser only sees top-left coordinates.
3. **Header block** (page 1): find the line starting with `Điện thoại:` → clinic phone (normalized, excluded from call targets). Clinic name = line(s) above it. Title line `DANH SÁCH HẸN TÁI KHÁM` marks the end of the header block.
4. **Column header band**: on each page, locate the header labels; their x positions define column boundaries (midpoint between adjacent labels' extents). Everything above and including the header band on every page is skipped.
5. **Row grouping**: cluster fragments into lines by y (tolerance ≈ a few pt, relative to font height), then assign each fragment to a column by its horizontal center.
6. **Record start**: a line whose STT cell is an integer starts a new record.
7. **Overflow lines**: lines without an integer STT (name / address / content wraps, typically ~13 pt below) attach to the **nearest record above** on the same page; append cell text with a single space.
8. **Footer**: `Tổng Cộng : N` → `expectedCount = N` (tolerate spacing variants such as `Tổng cộng: N`). Stop parsing records after it. The following print-date line `Ngày dd tháng mm năm yyyy` is ignored.
9. **List date**: all `Ngày Tái Khám` values are expected to be equal → that value is the list date. If not all equal: use the most frequent value and emit a warning listing the outlier rows.

## 4. Validation & warnings

The parser never throws on content problems; it returns a result with warnings so the review screen can highlight rows.

| Check | Outcome |
| --- | --- |
| `parsedCount != expectedCount` | Warning `countMismatch`; review screen shows both numbers |
| Footer missing | Warning `missingTotal` |
| STT sequence gap / duplicate | Warning on the affected rows (`suspiciousRow`) |
| Empty / unparseable phone | Row warning `invalidPhone` |
| Phone equals clinic phone | Row warning `clinicPhone`; excluded from CallTasks |
| Invalid `dd/MM/yyyy` in DOB or appointment date | Row warning `invalidDate` |
| Mixed appointment dates | Warning `mixedDates` |
| Duplicate medical code in one file | Row warning `duplicateMedicalCode` |

## 5. Phone normalization

Target form: VN local `0xxxxxxxxx` (10 digits for mobile).

| Raw | Normalized |
| --- | --- |
| `0900 000 001` | `0900000001` |
| `0900.000.001` | `0900000001` |
| `+84 900 000 001` | `0900000001` |
| `84900000001` | `0900000001` |
| `0900-000-001` | `0900000001` |

Strip spaces, dots, dashes, parentheses; `+84` / `84` prefix → `0`. If a cell contains two numbers (e.g. separated by `/` or `-` with full-length parts), take the first and emit a warning. Lives in `lib/core/utils/` (pure Dart).

## 6. Pipeline & code design

```text
PDF file
  │  PdfTextExtractor            lib/data/pdf/   (imports pdfrx)
  ▼
List<PositionedText>            pageIndex, text, left, top, right, bottom (top-left origin, pt), pageWidth, pageHeight
  │  AppointmentListParser       lib/data/pdf/   (pure Dart — NO Flutter / pdfrx imports)
  ▼
ParsedAppointmentList           clinicName?, clinicPhone?, listDate?, expectedCount?, rows[], warnings[]
  │  ImportRepository / use case
  ▼
Review screen → drift (Patient, Appointment, CallTask, ImportBatch)
```

- `PositionedText` and the parser result types live in `lib/data/pdf/` and are plain Dart classes so the parser is unit-testable without a device.
- Extractor responsibilities only: open file, iterate pages, convert coordinates, emit fragments. No business rules.
- Parser responsibilities: everything in §3–§5. Deterministic, no I/O.

### pdfrx API notes (verified against pdfrx 2.11.0 / pdfrx_engine 0.9.0)

- Call `pdfrxFlutterInitialize()` once at startup (`main.dart`): documents are opened before any pdfrx widget is built.
- `PdfDocument.openFile(path)` → document; iterate `document.pages`; `await document.dispose()` afterwards.
- `page.loadStructuredText(ensureLoaded: true)` (extension method) → `PdfPageText` with `fragments`; each fragment has `text`, `bounds` (`PdfRect`), `charRects` (one per UTF-16 unit) and `direction`. pdfrx already reorders text heuristically — we still group by coordinates.
- `PdfRect`: origin bottom-left, y up, `top > bottom`. `page.width` / `page.height` are the rotated size; rotated pages (`page.rotation != PdfPageRotation.none`) are skipped by the extractor.
- The extractor splits a fragment wherever two characters are a cell gap apart (`isCellGap`); the parser merges neighbouring pieces closer than that back into one cell.
- Debug builds log counts only (`rows`, `expected`, `phoneGroups`, warnings by type) under the `import` log name — never names or phones.

## 7. Test scenarios (synthetic fixtures)

Maintained by the `pdf-parser-tester` subagent in `test/data/pdf/`.

- Single page, all fields on one line.
- Wrapped name / address / content (overflow lines ~13 pt below).
- Two pages with the column header repeated on page 2; a record near a page boundary.
- Footer total matches; footer total mismatched; footer missing.
- Several patients sharing one phone (expect grouping downstream).
- Phone variants (`+84`, dots, spaces) and the clinic phone appearing in a row.
- Mixed appointment dates.
- Fragments delivered in shuffled order (extraction order ≠ reading order).
- Header column positions shifted by a few pt (boundaries must come from the header, not constants).

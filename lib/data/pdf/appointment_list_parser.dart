import 'dart:math' as math;

import 'package:injectable/injectable.dart';

import '../../core/utils/phone_normalizer.dart';
import '../../core/utils/text_fold.dart';
import '../../domain/entities/import_row.dart';
import '../../domain/entities/import_warning.dart';
import '../../domain/usecases/validate_import_rows.dart';
import 'parsed_appointment_list.dart';
import 'positioned_text.dart';

/// Parses the clinic's "DANH SÁCH HẸN TÁI KHÁM" from positioned text, as
/// specified in docs/pdf-format.md. Pure Dart and deterministic; content
/// problems become warnings, never exceptions.
@lazySingleton
class AppointmentListParser {
  const AppointmentListParser();

  ParsedAppointmentList parse(List<PositionedText> texts) {
    final pageIndexes = texts.map((t) => t.pageIndex).toSet().toList()..sort();
    String? clinicName;
    String? clinicPhone;
    int? expectedCount;
    var layout = _ColumnLayout.fallback;
    final records = <_Record>[];

    for (final pageIndex in pageIndexes) {
      final lines = _linesOf(texts.where((t) => t.pageIndex == pageIndex));
      final band = _findHeaderBand(lines);
      if (band != null) layout = _ColumnLayout.fromHeader(band.runs) ?? layout;
      final bandTop = band?.top ?? double.negativeInfinity;
      final bandBottom = band?.bottom ?? double.negativeInfinity;

      if (pageIndex == pageIndexes.first) {
        final header = _readHeaderBlock(
          lines.where((line) => line.bottom <= bandTop).toList(),
        );
        clinicName = header.name;
        clinicPhone = header.phone;
      }

      _Record? pageRecord;
      for (final line in lines.where((line) => line.top > bandBottom)) {
        final total = _totalOf(line);
        if (total != null) {
          expectedCount = total;
          break;
        }
        // Printed when the footer is missing too; never part of a record.
        if (_printDatePattern.hasMatch(line.folded)) continue;
        final cells = layout.cellsOf(line);
        final stt = int.tryParse(cells[_Column.stt]?.trim() ?? '');
        if (stt != null) {
          pageRecord = _Record(stt)..append(cells);
          records.add(pageRecord);
        } else if (pageRecord != null) {
          pageRecord.append(cells);
        } else if (records.isNotEmpty) {
          // Wrapped line at the top of a page: belongs to the last record of
          // the previous page, which the spec does not expect.
          records.last
            ..append(cells)
            ..suspicious = true;
        }
      }
      if (expectedCount != null) break;
    }

    _flagSttSequence(records);
    final rows = [
      for (final (index, record) in records.indexed) record.toRow(index + 1),
    ];
    final listDate = _mostFrequentDate(rows);
    final distinctDates = rows
        .map((row) => row.appointmentDate)
        .whereType<DateTime>()
        .toSet();
    return ParsedAppointmentList(
      rows: validateImportRows(
        rows,
        clinicPhone: clinicPhone,
        listDate: listDate,
      ),
      clinicName: clinicName,
      clinicPhone: clinicPhone,
      listDate: listDate,
      expectedCount: expectedCount,
      warnings: {
        if (expectedCount == null) ImportWarningType.missingTotal,
        if (expectedCount != null && expectedCount != rows.length)
          ImportWarningType.countMismatch,
        if (distinctDates.length > 1) ImportWarningType.mixedDates,
      },
    );
  }
}

enum _Column { stt, medicalCode, name, dob, address, phone, content, date }

/// Folded header labels without spaces, see [foldVietnamese].
const _labels = {
  _Column.stt: 'stt',
  _Column.medicalCode: 'mayte',
  _Column.name: 'tenbenhnhan',
  _Column.dob: 'ngaysinh',
  _Column.address: 'diachi',
  _Column.phone: 'sodt',
  _Column.content: 'noidung',
  _Column.date: 'ngaytaikham',
};

/// Every folded word that may appear in the column header band.
final _headerWords = {
  for (final label in [
    'stt',
    'ma y te',
    'ten benh nhan',
    'ngay sinh',
    'dia chi',
    'so dt',
    'noi dung',
    'ngay tai kham',
  ])
    ...label.split(' '),
};

/// Anchored so "tổng cộng" inside a Nội Dung cell is not taken as the footer.
final _totalPattern = RegExp(r'^tong cong\s*:?\s*(\d+)');
final _printDatePattern = RegExp(r'^ngay \d{1,2} thang \d{1,2} nam \d{4}$');
final _whitespace = RegExp(r'\s+');

/// Fragments of one visual line, merged into runs (one run per cell).
final class _Line {
  _Line(this.runs);

  /// Sorted left to right.
  final List<PositionedText> runs;

  double get top => runs.map((r) => r.top).reduce(math.min);
  double get bottom => runs.map((r) => r.bottom).reduce(math.max);
  String get text => runs.map((r) => r.text).join(' ');
  String get folded => foldVietnamese(text);
}

/// Groups fragments into lines by vertical center, then merges neighbours
/// closer than a cell gap into runs.
List<_Line> _linesOf(Iterable<PositionedText> fragments) {
  final sorted = fragments.where((f) => f.text.trim().isNotEmpty).toList()
    ..sort((a, b) => a.centerY.compareTo(b.centerY));
  final groups = <List<PositionedText>>[];
  for (final fragment in sorted) {
    final current = groups.lastOrNull;
    if (current != null) {
      final center =
          current.map((f) => f.centerY).reduce((a, b) => a + b) /
          current.length;
      final height = current.map((f) => f.height).reduce(math.min);
      final tolerance = math.max(2.0, math.min(height, fragment.height) / 2);
      if ((fragment.centerY - center).abs() <= tolerance) {
        current.add(fragment);
        continue;
      }
    }
    groups.add([fragment]);
  }
  return [
    for (final group in groups)
      _Line(_mergeRuns(group..sort((a, b) => a.left.compareTo(b.left)))),
  ];
}

List<PositionedText> _mergeRuns(List<PositionedText> fragments) {
  final runs = <PositionedText>[];
  for (final fragment in fragments) {
    final text = fragment.text.trim();
    final previous = runs.lastOrNull;
    final gap = previous == null ? 0.0 : fragment.left - previous.right;
    if (previous == null || isCellGap(gap, fragment.height)) {
      runs.add(_withText(fragment, text));
      continue;
    }
    // Pieces of one word touch; words are separated by a space.
    final separator = gap > fragment.height * 0.1 ? ' ' : '';
    runs[runs.length - 1] = PositionedText(
      pageIndex: previous.pageIndex,
      text: '${previous.text}$separator$text',
      left: previous.left,
      top: math.min(previous.top, fragment.top),
      right: math.max(previous.right, fragment.right),
      bottom: math.max(previous.bottom, fragment.bottom),
      pageWidth: previous.pageWidth,
      pageHeight: previous.pageHeight,
    );
  }
  return runs;
}

PositionedText _withText(PositionedText t, String text) => PositionedText(
  pageIndex: t.pageIndex,
  text: text,
  left: t.left,
  top: t.top,
  right: t.right,
  bottom: t.bottom,
  pageWidth: t.pageWidth,
  pageHeight: t.pageHeight,
);

/// The column header band: the line with "STT" plus neighbouring lines made
/// only of header words (labels may wrap above or below it).
_HeaderBand? _findHeaderBand(List<_Line> lines) {
  final index = lines.indexWhere(
    (line) => line.runs.any((run) => foldVietnamese(run.text) == 'stt'),
  );
  if (index < 0) return null;
  final anchor = lines[index];
  final reach = (anchor.bottom - anchor.top) * 2.2;
  bool isBandLine(_Line line) =>
      (line.top - anchor.top).abs() <= reach &&
      line.folded.split(' ').every(_headerWords.contains);

  final band = [anchor];
  for (var i = index - 1; i >= 0 && isBandLine(lines[i]); i--) {
    band.insert(0, lines[i]);
  }
  for (var i = index + 1; i < lines.length && isBandLine(lines[i]); i++) {
    band.add(lines[i]);
  }
  return _HeaderBand(band);
}

final class _HeaderBand {
  _HeaderBand(this.lines);

  final List<_Line> lines;

  double get top => lines.first.top;
  double get bottom => lines.last.bottom;
  List<PositionedText> get runs => [for (final line in lines) ...line.runs];
}

/// Column boundaries: midpoints between adjacent header labels.
final class _ColumnLayout {
  const _ColumnLayout(this.boundaries);

  /// Approximate boundaries measured on the sample (docs/pdf-format.md §2),
  /// used only when a page has no readable header.
  static const fallback = _ColumnLayout([
    32,
    81.5,
    173,
    234.5,
    348,
    418,
    510.5,
  ]);

  /// `boundaries[i]` separates column `i` from column `i + 1`.
  final List<double> boundaries;

  /// Null unless all eight labels are found.
  static _ColumnLayout? fromHeader(List<PositionedText> runs) {
    final groups = _labelGroups(runs);
    final found = <_Column, _LabelGroup>{};
    for (final group in groups) {
      final key = group.folded.replaceAll(' ', '');
      for (final MapEntry(key: column, value: label) in _labels.entries) {
        if (key == label && !found.containsKey(column)) found[column] = group;
      }
    }
    if (found.length != _Column.values.length) return null;
    final ordered = [for (final column in _Column.values) found[column]!];
    for (var i = 1; i < ordered.length; i++) {
      if (ordered[i].left <= ordered[i - 1].left) return null;
    }
    return _ColumnLayout([
      for (var i = 0; i < ordered.length - 1; i++)
        (ordered[i].right + ordered[i + 1].left) / 2,
    ]);
  }

  _Column columnAt(double x) {
    for (final (index, boundary) in boundaries.indexed) {
      if (x < boundary) return _Column.values[index];
    }
    return _Column.values.last;
  }

  /// Cell texts of [line] keyed by column, runs joined with a space.
  Map<_Column, String> cellsOf(_Line line) {
    final cells = <_Column, String>{};
    for (final run in line.runs) {
      final column = columnAt(run.centerX);
      final previous = cells[column];
      cells[column] = previous == null ? run.text : '$previous ${run.text}';
    }
    return cells;
  }
}

/// Header runs stacked vertically (a wrapped label) form one group.
final class _LabelGroup {
  _LabelGroup(PositionedText run) : runs = [run];

  final List<PositionedText> runs;

  double get left => runs.map((r) => r.left).reduce(math.min);
  double get right => runs.map((r) => r.right).reduce(math.max);

  String get folded {
    final ordered = [...runs]
      ..sort((a, b) {
        final byTop = a.top.compareTo(b.top);
        return byTop != 0 ? byTop : a.left.compareTo(b.left);
      });
    return foldVietnamese(ordered.map((r) => r.text).join(' '));
  }

  bool overlaps(PositionedText run) => run.left < right && run.right > left;
}

List<_LabelGroup> _labelGroups(List<PositionedText> runs) {
  final groups = <_LabelGroup>[];
  for (final run in [...runs]..sort((a, b) => a.left.compareTo(b.left))) {
    final group = groups.where((g) => g.overlaps(run)).firstOrNull;
    if (group == null) {
      groups.add(_LabelGroup(run));
    } else {
      group.runs.add(run);
    }
  }
  return groups;
}

typedef _HeaderBlock = ({String? name, String? phone});

/// Clinic phone from the `Điện thoại:` line and the clinic name above it.
_HeaderBlock _readHeaderBlock(List<_Line> lines) {
  final index = lines.indexWhere(
    (line) => line.folded.startsWith('dien thoai'),
  );
  if (index < 0) return (name: null, phone: null);
  final text = lines[index].text;
  final colon = text.indexOf(':');
  final phone = colon < 0 ? null : normalizePhone(text.substring(colon + 1));
  final name = index > 0 ? lines[index - 1].text.trim() : null;
  return (name: name, phone: phone?.phone);
}

int? _totalOf(_Line line) {
  final match = _totalPattern.firstMatch(line.folded);
  return match == null ? null : int.parse(match[1]!);
}

/// Marks rows whose STT breaks the 1, 2, 3… sequence.
void _flagSttSequence(List<_Record> records) {
  final seen = <int>{};
  for (final (index, record) in records.indexed) {
    final expected = index == 0 ? 1 : records[index - 1].stt + 1;
    if (record.stt != expected || !seen.add(record.stt)) {
      record.suspicious = true;
    }
  }
}

DateTime? _mostFrequentDate(List<ImportRow> rows) {
  final counts = <DateTime, int>{};
  for (final row in rows) {
    final date = row.appointmentDate;
    if (date != null) counts[date] = (counts[date] ?? 0) + 1;
  }
  if (counts.isEmpty) return null;
  final entries = counts.entries.toList()
    ..sort((a, b) {
      final byCount = b.value.compareTo(a.value);
      return byCount != 0 ? byCount : a.key.compareTo(b.key);
    });
  return entries.first.key;
}

/// A record being assembled from its start line and overflow lines.
final class _Record {
  _Record(this.stt);

  final int stt;
  final _cells = <_Column, List<String>>{};
  var suspicious = false;

  void append(Map<_Column, String> cells) {
    for (final MapEntry(key: column, value: text) in cells.entries) {
      if (column == _Column.stt) continue;
      final trimmed = text.trim();
      if (trimmed.isNotEmpty) (_cells[column] ??= []).add(trimmed);
    }
  }

  String _cell(_Column column) => (_cells[column] ?? const []).join(' ');

  ImportRow toRow(int key) => ImportRow(
    key: key,
    stt: stt,
    medicalCode: _cell(_Column.medicalCode).replaceAll(_whitespace, ''),
    name: _cell(_Column.name),
    dobText: _cell(_Column.dob),
    address: _cell(_Column.address),
    phoneText: _cell(_Column.phone),
    content: _cell(_Column.content),
    dateText: _cell(_Column.date),
    layoutWarnings: {if (suspicious) ImportWarningType.suspiciousRow},
  );
}

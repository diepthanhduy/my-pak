import 'package:equatable/equatable.dart';

import '../../core/utils/date_utils.dart';
import '../../core/utils/phone_normalizer.dart';
import 'import_warning.dart';

/// One editable row of an imported list. Dates and phone are kept as typed so
/// the review screen can show and fix exactly what was read.
final class ImportRow extends Equatable {
  const ImportRow({
    required this.key,
    required this.stt,
    required this.medicalCode,
    required this.name,
    this.dobText = '',
    this.address = '',
    this.phoneText = '',
    this.content = '',
    this.dateText = '',
    this.isManual = false,
    this.layoutWarnings = const {},
    this.warnings = const {},
  });

  /// Stable identity inside the draft, independent of STT.
  final int key;

  /// Row number (STT) in the source PDF.
  final int stt;

  /// Mã Y Tế.
  final String medicalCode;
  final String name;
  final String dobText;
  final String address;
  final String phoneText;

  /// Nội Dung.
  final String content;

  /// Ngày Tái Khám, `dd/MM/yyyy`.
  final String dateText;

  /// Added by hand on the review screen.
  final bool isManual;

  /// From the PDF layout (e.g. STT gaps); kept across edits.
  final Set<ImportWarningType> layoutWarnings;

  /// From content validation; recomputed after every edit.
  final Set<ImportWarningType> warnings;

  DateTime? get dob => parseDate(dobText);
  DateTime? get appointmentDate => parseDate(dateText);
  String? get phone => normalizePhone(phoneText).phone;

  Set<ImportWarningType> get allWarnings => {...layoutWarnings, ...warnings};

  /// Rows that cannot be saved until fixed or deleted.
  bool get isBlocking =>
      phone == null || medicalCode.trim().isEmpty || appointmentDate == null;

  ImportRow copyWith({
    int? stt,
    String? medicalCode,
    String? name,
    String? dobText,
    String? address,
    String? phoneText,
    String? content,
    String? dateText,
    Set<ImportWarningType>? warnings,
  }) => ImportRow(
    key: key,
    stt: stt ?? this.stt,
    medicalCode: medicalCode ?? this.medicalCode,
    name: name ?? this.name,
    dobText: dobText ?? this.dobText,
    address: address ?? this.address,
    phoneText: phoneText ?? this.phoneText,
    content: content ?? this.content,
    dateText: dateText ?? this.dateText,
    isManual: isManual,
    layoutWarnings: layoutWarnings,
    warnings: warnings ?? this.warnings,
  );

  @override
  List<Object?> get props => [
    key,
    stt,
    medicalCode,
    name,
    dobText,
    address,
    phoneText,
    content,
    dateText,
    isManual,
    layoutWarnings,
    warnings,
  ];
}

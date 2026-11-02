import '../../core/utils/date_utils.dart';
import '../entities/call_task.dart';

final _placeholder = RegExp(r'\{[a-z_]+\}');

/// Fills [template] for one phone group.
///
/// `{ten}` lists every patient name joined by ", "; `{noi_dung}` lists the
/// distinct contents. Unknown placeholders are left untouched.
String renderSmsReminder({
  required String template,
  required CallTask task,
  required String clinicName,
  required String clinicPhone,
}) {
  final values = {
    '{ten}': task.patients.map((p) => p.name).join(', '),
    '{noi_dung}': task.patients
        .map((p) => p.content.trim())
        .where((content) => content.isNotEmpty)
        .toSet()
        .join(', '),
    '{ngay_tai_kham}': formatDate(task.date),
    '{ten_phong_kham}': clinicName,
    '{sdt_phong_kham}': clinicPhone,
  };
  return template.replaceAllMapped(
    _placeholder,
    (match) => values[match[0]] ?? match[0]!,
  );
}

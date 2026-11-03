import 'package:equatable/equatable.dart';

const defaultSmsTemplate =
    'Phòng khám {ten_phong_kham} nhắc lịch: {ten} có lịch {noi_dung} '
    'ngày {ngay_tai_kham}. Liên hệ {sdt_phong_kham}.';

const defaultMaxAttempts = 3;

/// Empty until set in Settings or detected from an imported PDF header.
const defaultClinicName = '';
const defaultClinicPhone = '';

final class ReminderSettings extends Equatable {
  const ReminderSettings({
    required this.smsTemplate,
    required this.clinicName,
    required this.clinicPhone,
    this.maxAttempts = defaultMaxAttempts,
  });

  final String smsTemplate;
  final String clinicName;
  final String clinicPhone;

  /// Call attempts before a task becomes unreachable.
  final int maxAttempts;

  @override
  List<Object?> get props => [
    smsTemplate,
    clinicName,
    clinicPhone,
    maxAttempts,
  ];
}

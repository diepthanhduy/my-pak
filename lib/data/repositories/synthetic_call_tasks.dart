import '../../core/utils/date_utils.dart';
import '../../domain/entities/call_task.dart';
import '../../domain/entities/contact_summary.dart';
import '../../domain/entities/patient_appointment.dart';

/// SYNTHETIC development data — fake names, phones and medical codes only.
///
/// Dates are relative to [today] so the Home screen always has something to
/// show: today, yesterday and tomorrow.
List<CallTask> buildSyntheticCallTasks(DateTime today) {
  final yesterday = addDays(today, -1);
  final tomorrow = addDays(today, 1);

  DateTime monthsAgo(int months) =>
      DateTime(today.year, today.month - months, 1);
  DateTime at(DateTime day, int hour, int minute) =>
      DateTime(day.year, day.month, day.day, hour, minute);

  var appointmentId = 0;
  PatientAppointment patient(
    int stt,
    String name,
    DateTime dob,
    String content,
  ) => PatientAppointment(
    appointmentId: ++appointmentId,
    stt: stt,
    medicalCode: 'YT${stt.toString().padLeft(6, '0')}',
    name: name,
    dob: dob,
    content: content,
  );

  return [
    // Three siblings sharing one phone; the youngest is under one year.
    CallTask(
      id: 1,
      date: today,
      phoneNormalized: '0900000001',
      patients: [
        patient(
          1,
          'Nguyễn Văn A',
          monthsAgo(62),
          'Tiêm vắc xin sởi - quai bị - rubella mũi 2',
        ),
        patient(2, 'Nguyễn Thị B', monthsAgo(38), 'Tái khám hô hấp'),
        patient(
          3,
          'Nguyễn Văn C',
          monthsAgo(8),
          'Tiêm vắc xin 6 trong 1 mũi 3',
        ),
      ],
    ),
    CallTask(
      id: 2,
      date: today,
      phoneNormalized: '0900000002',
      patients: [
        patient(4, 'Trần Thị D', monthsAgo(4), 'Tiêm vắc xin phế cầu mũi 2'),
      ],
    ),
    // Retry after two unanswered calls.
    CallTask(
      id: 3,
      date: today,
      phoneNormalized: '0900000003',
      status: CallTaskStatus.retry,
      attemptCount: 2,
      nextRetryAt: at(today, 15, 0),
      lastContact: ContactSummary(
        channel: ContactChannel.call,
        at: at(today, 10, 15),
        result: ContactResult.noAnswer,
      ),
      patients: [patient(5, 'Lê Văn E', monthsAgo(27), 'Tái khám tiêu hóa')],
    ),
    CallTask(
      id: 4,
      date: today,
      phoneNormalized: '0900000004',
      status: CallTaskStatus.retry,
      attemptCount: 1,
      nextRetryAt: at(today, 11, 30),
      lastContact: ContactSummary(
        channel: ContactChannel.call,
        at: at(today, 9, 40),
        result: ContactResult.busy,
      ),
      patients: [
        patient(6, 'Phạm Thị F', monthsAgo(15), 'Tiêm vắc xin cúm mũi 1'),
      ],
    ),
    CallTask(
      id: 5,
      date: today,
      phoneNormalized: '0900000005',
      status: CallTaskStatus.done,
      attemptCount: 1,
      lastContact: ContactSummary(
        channel: ContactChannel.call,
        at: at(today, 9, 5),
        result: ContactResult.confirmed,
      ),
      patients: [
        patient(
          7,
          'Hoàng Văn G',
          monthsAgo(50),
          'Tiêm vắc xin viêm não Nhật Bản',
        ),
      ],
    ),
    CallTask(
      id: 6,
      date: today,
      phoneNormalized: '0900000006',
      status: CallTaskStatus.unreachable,
      attemptCount: 3,
      lastContact: ContactSummary(
        channel: ContactChannel.call,
        at: at(today, 8, 50),
        result: ContactResult.unreachable,
      ),
      patients: [patient(8, 'Võ Thị H', monthsAgo(20), 'Tái khám da liễu')],
    ),
    CallTask(
      id: 7,
      date: today,
      phoneNormalized: '0900000007',
      patients: [
        patient(9, 'Đặng Văn I', monthsAgo(70), 'Tiêm vắc xin thủy đậu mũi 2'),
        patient(10, 'Đặng Thị K', monthsAgo(30), 'Tiêm vắc xin thủy đậu mũi 1'),
      ],
    ),
    CallTask(
      id: 8,
      date: yesterday,
      phoneNormalized: '0900000008',
      status: CallTaskStatus.done,
      attemptCount: 1,
      lastContact: ContactSummary(
        channel: ContactChannel.call,
        at: at(yesterday, 14, 20),
        result: ContactResult.confirmed,
      ),
      patients: [
        patient(1, 'Bùi Văn L', monthsAgo(11), 'Tiêm vắc xin rota liều 2'),
      ],
    ),
    CallTask(
      id: 9,
      date: tomorrow,
      phoneNormalized: '0900000009',
      patients: [patient(1, 'Đỗ Thị M', monthsAgo(44), 'Tái khám mắt')],
    ),
  ];
}

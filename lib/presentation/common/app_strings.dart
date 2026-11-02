/// All user-facing Vietnamese strings (no i18n package yet).
abstract final class AppStrings {
  static const appTitle = 'Assistant PAK';

  // Dates
  static const today = 'Hôm nay';

  /// Indexed by `DateTime.weekday - 1`.
  static const weekdays = [
    'Thứ Hai',
    'Thứ Ba',
    'Thứ Tư',
    'Thứ Năm',
    'Thứ Sáu',
    'Thứ Bảy',
    'Chủ Nhật',
  ];
  static const previousDay = 'Ngày trước';
  static const nextDay = 'Ngày sau';
  static const pickDate = 'Chọn ngày';

  // Home
  static const settings = 'Cài đặt';
  static const importPdf = 'Import PDF';
  static String contactedProgress(int contacted, int total) =>
      'Đã liên hệ $contacted / $total số';
  static String patientsAndRetry(int patients, int retry) =>
      '$patients bệnh nhân · $retry số cần gọi lại';
  static const emptyDay = 'Chưa có danh sách cho ngày này';
  static const emptyFilter = 'Không có số nào ở trạng thái này';
  static const loadFailed = 'Không tải được danh sách';
  static const retry = 'Thử lại';
  static const actionFailed = 'Có lỗi xảy ra, vui lòng thử lại';
  static const launchCallFailed = 'Không mở được ứng dụng gọi điện';
  static const launchSmsFailed = 'Không mở được ứng dụng tin nhắn';

  // Filters
  static const filterAll = 'Tất cả';
  static const filterPending = 'Chưa gọi';
  static const filterRetry = 'Gọi lại';
  static const filterDone = 'Đã xác nhận';
  static const filterUnreachable = 'Không liên lạc được';

  // Call task card
  static const call = 'Gọi';
  static const sms = 'SMS';
  static String attempt(int count, int max) => 'Lần $count/$max';
  static String groupSize(int count) => '$count người';
  static String ageYears(int years) => '$years tuổi';
  static String ageMonths(int months) => '$months tháng';
  static const ageUnderOneMonth = 'Dưới 1 tháng';

  // Call task status
  static const statusPending = 'Chưa gọi';
  static const statusRetry = 'Gọi lại';
  static const statusDone = 'Đã xác nhận';
  static const statusUnreachable = 'Không liên lạc được';

  // Contact results
  static const resultConfirmed = 'Đã xác nhận';
  static const resultNoAnswer = 'Không nghe máy';
  static const resultBusy = 'Máy bận';
  static const resultUnreachable = 'Không liên lạc được';
  static const resultWrongNumber = 'Sai số';
  static const resultRescheduled = 'Hẹn lại';
  static const callAwaitingResult = 'Đã gọi, chưa ghi kết quả';
  static const smsOpened = 'Đã mở SMS';

  // Stub pages
  static const callTaskDetail = 'Chi tiết số gọi';
  static const comingSoon = 'Sẽ làm ở bước sau';
}

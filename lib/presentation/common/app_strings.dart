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

  // Import
  static const openingPicker = 'Đang mở trình chọn file…';
  static const readingPdf = 'Đang đọc PDF…';
  static const pdfUnreadable = 'Không đọc được file PDF này';
  static const pdfNoRows = 'Không tìm thấy dòng nào trong danh sách';
  static const pickAnotherPdf = 'Chọn file khác';
  static const cancel = 'Huỷ';
  static const reviewTitle = 'Kiểm tra danh sách';
  static const discardImportTitle = 'Huỷ import?';
  static const discardImportBody =
      'Danh sách chưa được lưu. File vừa chọn sẽ bị xoá khỏi app.';
  static const keepEditing = 'Tiếp tục kiểm tra';
  static const discard = 'Huỷ import';
  static const saveList = 'Lưu danh sách';
  static String blockingRows(int count) => 'Còn $count dòng cần sửa hoặc xoá';
  static const addRow = 'Thêm dòng';
  static const listTab = 'Danh sách';
  static const pdfTab = 'PDF gốc';
  static String listDate(String date) => 'Ngày tái khám: $date';
  static const unknownDate = 'chưa rõ';
  static String clinic(String text) => 'Phòng khám: $text';
  static String readCount(int read, int total) =>
      'Đã đọc $read / Tổng cộng $total';
  static String readCountNoTotal(int read) =>
      'Đã đọc $read · không thấy dòng Tổng cộng';
  static String phoneGroups(int count) => '$count số điện thoại';
  static const mixedDatesNotice = 'Danh sách có nhiều ngày tái khám khác nhau';
  static const invalidPhoneGroup = 'SĐT không hợp lệ';
  static const clinicPhoneGroup = 'Số phòng khám · không gọi';
  static const rowDeleted = 'Đã xoá dòng';
  static const undo = 'Hoàn tác';
  static String importSaved(int added, int existing) =>
      'Đã lưu: thêm $added bệnh nhân mới, $existing đã có';
  static const importSaveFailed = 'Không lưu được danh sách, vui lòng thử lại';
  static const editRow = 'Sửa dòng';
  static const medicalCode = 'Mã Y Tế';
  static const patientName = 'Tên bệnh nhân';
  static const dob = 'Ngày sinh (dd/MM/yyyy)';
  static const address = 'Địa chỉ';
  static const phone = 'Số điện thoại';
  static const content = 'Nội dung';
  static const appointmentDate = 'Ngày tái khám (dd/MM/yyyy)';
  static const save = 'Lưu';
  static const required = 'Bắt buộc';
  static const invalidPhone = 'Số không hợp lệ';
  static const invalidDate = 'Sai định dạng dd/MM/yyyy';
  static String phonePreview(String phone) => 'Sẽ gọi: $phone';

  // Import warnings
  static const warningCountMismatch = 'Lệch tổng số';
  static const warningMissingTotal = 'Thiếu dòng tổng';
  static const warningMixedDates = 'Khác ngày tái khám';
  static const warningSuspiciousRow = 'STT bất thường';
  static const warningInvalidPhone = 'SĐT không hợp lệ';
  static const warningMultiplePhones = 'Nhiều SĐT';
  static const warningClinicPhone = 'Số phòng khám';
  static const warningInvalidDate = 'Sai ngày';
  static const warningDuplicateMedicalCode = 'Trùng Mã Y Tế';
  static const warningMissingMedicalCode = 'Thiếu Mã Y Tế';

  // Stub pages
  static const callTaskDetail = 'Chi tiết số gọi';
  static const comingSoon = 'Sẽ làm ở bước sau';
}

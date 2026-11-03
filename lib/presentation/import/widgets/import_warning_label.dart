import '../../../domain/entities/import_warning.dart';
import '../../common/app_strings.dart';

extension ImportWarningLabel on ImportWarningType {
  String get label => switch (this) {
    ImportWarningType.countMismatch => AppStrings.warningCountMismatch,
    ImportWarningType.missingTotal => AppStrings.warningMissingTotal,
    ImportWarningType.mixedDates => AppStrings.warningMixedDates,
    ImportWarningType.suspiciousRow => AppStrings.warningSuspiciousRow,
    ImportWarningType.invalidPhone => AppStrings.warningInvalidPhone,
    ImportWarningType.multiplePhones => AppStrings.warningMultiplePhones,
    ImportWarningType.clinicPhone => AppStrings.warningClinicPhone,
    ImportWarningType.invalidDate => AppStrings.warningInvalidDate,
    ImportWarningType.duplicateMedicalCode =>
      AppStrings.warningDuplicateMedicalCode,
    ImportWarningType.missingMedicalCode =>
      AppStrings.warningMissingMedicalCode,
  };
}

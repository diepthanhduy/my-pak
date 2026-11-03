// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:assistant_pak/core/di/database_module.dart' as _i801;
import 'package:assistant_pak/core/utils/clock.dart' as _i236;
import 'package:assistant_pak/data/local/app_database.dart' as _i617;
import 'package:assistant_pak/data/local/dev_data_seeder.dart' as _i1070;
import 'package:assistant_pak/data/pdf/appointment_list_parser.dart' as _i585;
import 'package:assistant_pak/data/pdf/pdf_import_reader.dart' as _i72;
import 'package:assistant_pak/data/pdf/pdf_text_extractor.dart' as _i628;
import 'package:assistant_pak/data/repositories/dev_import_repository.dart'
    as _i491;
import 'package:assistant_pak/data/repositories/drift_call_task_repository.dart'
    as _i989;
import 'package:assistant_pak/data/repositories/drift_settings_repository.dart'
    as _i923;
import 'package:assistant_pak/data/repositories/import_repository_impl.dart'
    as _i873;
import 'package:assistant_pak/data/repositories/in_memory_call_task_repository.dart'
    as _i386;
import 'package:assistant_pak/data/repositories/in_memory_settings_repository.dart'
    as _i13;
import 'package:assistant_pak/data/services/app_import_file_store.dart'
    as _i224;
import 'package:assistant_pak/data/services/file_picker_pdf_picker.dart'
    as _i390;
import 'package:assistant_pak/data/services/method_channel_shared_pdf_source.dart'
    as _i669;
import 'package:assistant_pak/data/services/url_phone_launcher.dart' as _i636;
import 'package:assistant_pak/domain/repositories/call_task_repository.dart'
    as _i223;
import 'package:assistant_pak/domain/repositories/import_repository.dart'
    as _i908;
import 'package:assistant_pak/domain/repositories/settings_repository.dart'
    as _i380;
import 'package:assistant_pak/domain/services/import_file_store.dart' as _i817;
import 'package:assistant_pak/domain/services/pdf_picker.dart' as _i651;
import 'package:assistant_pak/domain/services/phone_launcher.dart' as _i481;
import 'package:assistant_pak/domain/services/shared_pdf_source.dart' as _i360;
import 'package:assistant_pak/domain/usecases/parse_appointment_pdf.dart'
    as _i479;
import 'package:assistant_pak/domain/usecases/save_import_batch.dart' as _i217;
import 'package:assistant_pak/domain/usecases/send_sms_reminder.dart' as _i884;
import 'package:assistant_pak/domain/usecases/start_call.dart' as _i649;
import 'package:assistant_pak/domain/usecases/watch_call_tasks_by_date.dart'
    as _i591;
import 'package:assistant_pak/presentation/call_list/bloc/home_bloc.dart'
    as _i37;
import 'package:assistant_pak/presentation/import/bloc/import_bloc.dart'
    as _i560;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

const String _dev = 'dev';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final databaseModule = _$DatabaseModule();
    gh.lazySingleton<_i236.Clock>(() => const _i236.Clock());
    gh.lazySingleton<_i585.AppointmentListParser>(
      () => const _i585.AppointmentListParser(),
    );
    gh.lazySingleton<_i628.PdfTextExtractor>(
      () => const _i628.PdfTextExtractor(),
    );
    gh.lazySingleton<_i481.PhoneLauncher>(() => _i636.UrlPhoneLauncher());
    gh.lazySingleton<_i223.CallTaskRepository>(
      () => _i386.InMemoryCallTaskRepository(gh<_i236.Clock>()),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i72.PdfImportReader>(
      () => _i72.PdfImportReader(
        gh<_i628.PdfTextExtractor>(),
        gh<_i585.AppointmentListParser>(),
      ),
    );
    gh.lazySingleton<_i380.SettingsRepository>(
      () => _i13.InMemorySettingsRepository(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i360.SharedPdfSource>(
      () => _i669.MethodChannelSharedPdfSource(),
    );
    gh.lazySingleton<_i651.PdfPicker>(() => const _i390.FilePickerPdfPicker());
    gh.lazySingleton<_i817.ImportFileStore>(
      () => _i224.AppImportFileStore(gh<_i236.Clock>()),
    );
    gh.lazySingleton<_i617.AppDatabase>(
      () => databaseModule.database,
      registerFor: {_prod},
      dispose: _i801.closeAppDatabase,
    );
    gh.lazySingleton<_i908.ImportRepository>(
      () => _i491.DevImportRepository(gh<_i72.PdfImportReader>()),
      registerFor: {_dev},
    );
    gh.factory<_i1070.DevDataSeeder>(
      () => _i1070.DevDataSeeder(gh<_i617.AppDatabase>(), gh<_i236.Clock>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i380.SettingsRepository>(
      () => _i923.DriftSettingsRepository(gh<_i617.AppDatabase>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i223.CallTaskRepository>(
      () => _i989.DriftCallTaskRepository(gh<_i617.AppDatabase>()),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i908.ImportRepository>(
      () => _i873.ImportRepositoryImpl(
        gh<_i617.AppDatabase>(),
        gh<_i72.PdfImportReader>(),
        gh<_i236.Clock>(),
      ),
      registerFor: {_prod},
    );
    gh.factory<_i649.StartCall>(
      () => _i649.StartCall(gh<_i223.CallTaskRepository>(), gh<_i236.Clock>()),
    );
    gh.factory<_i217.SaveImportBatch>(
      () => _i217.SaveImportBatch(gh<_i908.ImportRepository>()),
    );
    gh.factory<_i591.WatchCallTasksByDate>(
      () => _i591.WatchCallTasksByDate(gh<_i223.CallTaskRepository>()),
    );
    gh.factory<_i479.ParseAppointmentPdf>(
      () => _i479.ParseAppointmentPdf(
        gh<_i908.ImportRepository>(),
        gh<_i817.ImportFileStore>(),
      ),
    );
    gh.factory<_i884.SendSmsReminder>(
      () => _i884.SendSmsReminder(
        gh<_i223.CallTaskRepository>(),
        gh<_i380.SettingsRepository>(),
        gh<_i236.Clock>(),
      ),
    );
    gh.factory<_i560.ImportBloc>(
      () => _i560.ImportBloc(
        gh<_i651.PdfPicker>(),
        gh<_i479.ParseAppointmentPdf>(),
        gh<_i217.SaveImportBatch>(),
        gh<_i817.ImportFileStore>(),
      ),
    );
    gh.factory<_i37.HomeBloc>(
      () => _i37.HomeBloc(
        gh<_i591.WatchCallTasksByDate>(),
        gh<_i649.StartCall>(),
        gh<_i884.SendSmsReminder>(),
        gh<_i380.SettingsRepository>(),
        gh<_i236.Clock>(),
      ),
    );
    return this;
  }
}

class _$DatabaseModule extends _i801.DatabaseModule {}

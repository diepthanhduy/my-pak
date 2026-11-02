// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:assistant_pak/core/utils/clock.dart' as _i236;
import 'package:assistant_pak/data/repositories/in_memory_call_task_repository.dart'
    as _i386;
import 'package:assistant_pak/data/repositories/in_memory_settings_repository.dart'
    as _i13;
import 'package:assistant_pak/data/services/url_phone_launcher.dart' as _i636;
import 'package:assistant_pak/domain/repositories/call_task_repository.dart'
    as _i223;
import 'package:assistant_pak/domain/repositories/settings_repository.dart'
    as _i380;
import 'package:assistant_pak/domain/services/phone_launcher.dart' as _i481;
import 'package:assistant_pak/domain/usecases/send_sms_reminder.dart' as _i884;
import 'package:assistant_pak/domain/usecases/start_call.dart' as _i649;
import 'package:assistant_pak/domain/usecases/watch_call_tasks_by_date.dart'
    as _i591;
import 'package:assistant_pak/presentation/call_list/bloc/home_bloc.dart'
    as _i37;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

const String _dev = 'dev';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i236.Clock>(() => const _i236.Clock());
    gh.lazySingleton<_i481.PhoneLauncher>(() => _i636.UrlPhoneLauncher());
    gh.lazySingleton<_i223.CallTaskRepository>(
      () => _i386.InMemoryCallTaskRepository(gh<_i236.Clock>()),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i380.SettingsRepository>(
      () => _i13.InMemorySettingsRepository(),
      registerFor: {_dev},
    );
    gh.factory<_i884.SendSmsReminder>(
      () => _i884.SendSmsReminder(
        gh<_i223.CallTaskRepository>(),
        gh<_i380.SettingsRepository>(),
        gh<_i236.Clock>(),
      ),
    );
    gh.factory<_i649.StartCall>(
      () => _i649.StartCall(gh<_i223.CallTaskRepository>(), gh<_i236.Clock>()),
    );
    gh.factory<_i591.WatchCallTasksByDate>(
      () => _i591.WatchCallTasksByDate(gh<_i223.CallTaskRepository>()),
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

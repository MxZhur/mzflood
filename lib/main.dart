import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '/l10n/app_localizations.dart';
import '/router/route_generator.dart';
import '/themes/app_themes.dart';
import 'bloc/app_settings/app_settings_cubit.dart';
import 'bloc/app_settings/app_settings_state.dart';
import 'bloc/game_state/game_state_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getApplicationCacheDirectory()).path),
  );
  runApp(FloodPuzzleApp());
}

class FloodPuzzleApp extends StatelessWidget {
  const FloodPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<AppSettingsCubit>(create: (_) => AppSettingsCubit()),
      BlocProvider<GameStateCubit>(create: (_) => GameStateCubit()),
    ],
    child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, settingsState) => MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: settingsState.language != null
            ? Locale(settingsState.language!)
            : null,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: settingsState.brightnessMode,
        initialRoute: '/',
        onGenerateRoute: onGenerateRoute,
      ),
    ),
  );
}

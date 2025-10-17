import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mzflood/bloc/app_settings/app_settings_bloc.dart';
import 'package:mzflood/bloc/app_settings/game_state_bloc.dart';
import 'package:mzflood/l10n/app_localizations.dart';
import 'package:mzflood/router/route_generator.dart';
import 'package:mzflood/themes/app_themes.dart';

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

  // TODO: Review, decompose, and refactor the app's entire code

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSettingsCubit>(create: (_) => AppSettingsCubit()),
        BlocProvider<GameStateCubit>(create: (_) => GameStateCubit()),
      ],
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          return MaterialApp(
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)!.appTitle,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: state.language != null ? Locale(state.language!) : null,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: state.brightnessMode,
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.onGenerateRoute,
          );
        },
      ),
    );
  }
}

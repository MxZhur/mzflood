import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/app_settings/app_settings_cubit.dart';
import '/bloc/game_state/game_state_cubit.dart';
import '/domain/game_grid.dart';
import '/l10n/app_localizations.dart';
import '/utils/notifications.dart';

void makeMove(BuildContext context, {required ColorIndex colorIndex}) {
  context.read<GameStateCubit>().makeMove(colorIndex);
}

void resetBoard(BuildContext context, {bool verbose = false}) {
  context.read<GameStateCubit>().resetBoard();

  if (verbose) {
    showNotification(
      context,
      AppLocalizations.of(context)!.messageBoardRestarted,
    );
  }
}

void startNewGame(BuildContext context, {bool verbose = false}) {
  final gameStateCubit = context.read<GameStateCubit>();
  final appSettingsCubit = context.read<AppSettingsCubit>();

  gameStateCubit.initFromAppSettings(appSettingsCubit.state);

  if (verbose) {
    showNotification(
      context,
      AppLocalizations.of(context)!.messageNewGameStarted,
    );
  }
}

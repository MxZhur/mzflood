import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/game_state/game_state.dart';
import '/bloc/game_state/game_state_cubit.dart';
import '/commands/commands.dart';
import '/l10n/app_localizations.dart';

class GameToolBar extends StatelessWidget {
  const GameToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    return BlocBuilder<GameStateCubit, GameState?>(
      builder: (context, gameState) {
        if (gameState == null) {
          return const SizedBox();
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            Tooltip(
              message: i18n.buttonNewGame,
              child: IconButton.filled(
                onPressed: () => startNewGame(context, verbose: true),
                icon: const Icon(Icons.replay),
              ),
            ),

            Tooltip(
              message: i18n.buttonRestartBoard,
              child: IconButton.filled(
                onPressed: gameState.stepsDone > 0
                    ? () => resetBoard(context, verbose: true)
                    : null,
                icon: const Icon(Icons.restore),
              ),
            ),

            Tooltip(
              message: i18n.titleSettings,
              child: IconButton.filled(
                onPressed: () {
                  Navigator.pushNamed(context, '/app-settings');
                },
                icon: const Icon(Icons.settings),
              ),
            ),
          ],
        );
      },
    );
  }
}

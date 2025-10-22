import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/app_settings/app_settings_cubit.dart';
import '/bloc/app_settings/app_settings_state.dart';
import '/bloc/game_state/game_state.dart';
import '/bloc/game_state/game_state_cubit.dart';
import '/commands/commands.dart';
import '/constants/colors.dart';
import 'widgets/game_board/game_board_view.dart';
import 'widgets/game_bottom_bar/game_bottom_bar.dart';
import 'widgets/game_status_bar/game_status_bar.dart';
import 'widgets/scaffold_with_debug_mode.dart';

class GameScreen extends StatelessWidget {
  static const Duration _initializationDelay = Duration(milliseconds: 250);

  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) => ScaffoldWithDebugButton(
    body: SafeArea(
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (_, settingsState) => BlocBuilder<GameStateCubit, GameState?>(
          builder: (context, gameState) {
            // Couldn't come up with a better autostart solution yet.
            // But it works.
            if (gameState == null) {
              Future.delayed(_initializationDelay).then((value) {
                if (!context.mounted) return;

                startNewGame(context);
              });

              return Center(child: CircularProgressIndicator());
            }

            final gameGridPalette = gameState.settings.generatePalette();

            final stateColor = switch (gameState.winningState) {
              WinningState.inProgress when gameState.fewMovesLeft =>
                warningColor,
              WinningState.victory => victoryColor,
              WinningState.defeat => defeatColor,
              _ => null,
            };

            return Theme(
              data: (stateColor != null)
                  ? ThemeData(
                      colorSchemeSeed: stateColor,
                      brightness: Theme.brightnessOf(context),
                    )
                  : Theme.of(context),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 8,
                  children: [
                    GameStatusBar(),
                    Expanded(child: GameBoardView(palette: gameGridPalette)),
                    GameBottomBar(gamePalette: gameGridPalette),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

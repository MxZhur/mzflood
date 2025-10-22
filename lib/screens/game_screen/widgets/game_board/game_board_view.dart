import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/app_settings/app_settings_cubit.dart';
import '/bloc/app_settings/app_settings_state.dart';
import '/bloc/game_state/game_state.dart';
import '/bloc/game_state/game_state_cubit.dart';
import '/commands/commands.dart';
import '/constants/palette.dart';
import 'components/game_board_layer.dart';
import 'components/winning_state_message_box.dart';

class GameBoardView extends StatelessWidget {
  final Palette palette;

  const GameBoardView({super.key, required this.palette});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, settingsState) =>
            BlocBuilder<GameStateCubit, GameState?>(
              builder: (context, gameState) => (gameState == null)
                  ? const SizedBox()
                  : Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: GameBoardLayer(
                            grid: gameState.gameGrid,
                            cellColorGenerator: (gridIndex) =>
                                palette[gameState.gameGrid.valueAt(gridIndex)],
                            gameState: gameState,
                            settingsState: settingsState,
                            onCellPress: (gridIndex) => makeMove(
                              context,
                              colorIndex: gameState.gameGrid.valueAt(gridIndex),
                            ),
                            showFillingPoint:
                                gameState.winningState != WinningState.victory,
                          ),
                        ),
                        WinningStateMessageBox(
                          winningState: gameState.winningState,
                        ),
                      ],
                    ),
            ),
      );
}

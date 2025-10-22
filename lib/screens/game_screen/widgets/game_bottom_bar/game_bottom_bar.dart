import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/app_settings/app_settings_cubit.dart';
import '/bloc/app_settings/app_settings_state.dart';
import '/bloc/game_state/game_state.dart';
import '/bloc/game_state/game_state_cubit.dart';
import '/constants/palette.dart';
import 'components/after_game_bottom_menu_bar.dart';
import 'components/color_selector_bar.dart';

class GameBottomBar extends StatelessWidget {
  final Palette gamePalette;

  const GameBottomBar({super.key, required this.gamePalette});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (_, settingsState) => BlocBuilder<GameStateCubit, GameState?>(
          builder: (_, gameState) {
            if (gameState == null) {
              return const SizedBox();
            }

            return AnimatedCrossFade(
              firstChild: Visibility(
                visible:
                    settingsState.isColorPanelVisible &&
                    gameState.gameGrid.totalUniqueValuesOnGrid > 1,
                child: Card(
                  child: ColorSelectorBar(
                    gameState: gameState,
                    palette: gamePalette,
                    colorAccessabilityMode:
                        settingsState.colorAccessabilityMode,
                  ),
                ),
              ),
              secondChild: AfterGameBottomMenuBar(),
              crossFadeState: gameState.winningState == WinningState.inProgress
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Durations.long2,
              sizeCurve: Curves.easeOut,
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeOut,
            );
          },
        ),
      );
}

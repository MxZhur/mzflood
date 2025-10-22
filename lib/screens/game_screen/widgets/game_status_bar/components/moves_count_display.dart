import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/game_state/game_state.dart';
import '/bloc/game_state/game_state_cubit.dart';

class MovesCountDisplay extends StatelessWidget {
  static const double movesCounterFontSize = 40;

  const MovesCountDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final maxMovesFontSize = movesCounterFontSize * 0.5;

    final stateColor = HSLColor.fromColor(
      Theme.of(context).colorScheme.primary,
    ).withSaturation(1).toColor();

    return BlocBuilder<GameStateCubit, GameState?>(
      builder: (_, gameState) {
        if (gameState == null) {
          return const SizedBox();
        }

        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: gameState.stepsDone.toString(),
                style: TextStyle(
                  fontSize: movesCounterFontSize,
                  color: stateColor,
                ),
              ),

              TextSpan(
                text: ' / ${gameState.settings.maxMoves}',
                style: TextStyle(
                  fontSize: maxMovesFontSize,
                  color: stateColor.withAlpha(190),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

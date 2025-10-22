import 'package:flutter/material.dart';

import '/bloc/game_state/game_state.dart';
import '/constants/colors.dart';
import '/l10n/app_localizations.dart';

class WinningStateMessageBox extends StatelessWidget {
  final WinningState winningState;

  const WinningStateMessageBox({super.key, required this.winningState});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    final stateColor = switch (winningState) {
      WinningState.victory => victoryColor,
      WinningState.defeat => defeatColor,
      _ => null,
    };

    final stateLabelStyle = Theme.of(context).textTheme.displayLarge?.copyWith(
      color: stateColor,
      fontWeight: FontWeight.bold,
    );

    return Positioned(
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: winningState == WinningState.inProgress ? 0 : 1,
        duration: Durations.short4,
        curve: Curves.easeOut,
        child: AnimatedSize(
          duration: Durations.short4,
          curve: Curves.easeOut,
          child: Container(
            color: Theme.of(context).colorScheme.surface.withAlpha(210),
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            alignment: Alignment.center,
            child: FittedBox(
              child: Builder(
                builder: (_) {
                  if (winningState == WinningState.inProgress) {
                    return const SizedBox();
                  }

                  final message = switch (winningState) {
                    WinningState.victory => i18n.messageVictory,
                    WinningState.defeat => i18n.messageDefeat,
                    _ => '',
                  };

                  return Text(message, style: stateLabelStyle);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

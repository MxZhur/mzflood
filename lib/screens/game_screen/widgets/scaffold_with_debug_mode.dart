import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/game_state/game_state_cubit.dart';
import '/domain/game_grid.dart';
import '/l10n/app_localizations.dart';

class ScaffoldWithDebugButton extends StatelessWidget {
  final Widget? body;
  final PreferredSizeWidget? appBar;
  const ScaffoldWithDebugButton({super.key, this.body, this.appBar});

  @override
  Widget build(BuildContext context) => Scaffold(
    floatingActionButton: kDebugMode
        ? const DebugModeFloatingActionButton()
        : null,
    floatingActionButtonLocation: kDebugMode
        ? FloatingActionButtonLocation.miniEndFloat
        : null,
    appBar: appBar,
    body: body,
  );
}

class DebugModeFloatingActionButton extends StatelessWidget {
  const DebugModeFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    return FloatingActionButton(
      onPressed: () {
        final gameStateCubit = context.read<GameStateCubit>();
        final gameState = gameStateCubit.state;

        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: Text(i18n.debug),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  if (gameState != null) {
                    gameStateCubit.setGameStateExplicitly(
                      gameState.copyWith(
                        stepsDone: 0,
                        gameGrid: GameGrid<ColorIndex>.generate(
                          width: gameState.settings.gridWidth,
                          height: gameState.settings.gridHeight,
                          valueGenerator: (_) => 0,
                        ),
                      ),
                    );
                  }

                  Navigator.pop(context);
                },
                child: Text(i18n.debugSetVictory),
              ),

              SimpleDialogOption(
                onPressed: () {
                  if (gameState != null) {
                    gameStateCubit.setGameStateExplicitly(
                      gameState.copyWith(
                        stepsDone: gameState.settings.maxMoves,
                        gameGrid: gameState.settings.generateGrid(),
                      ),
                    );
                  }

                  Navigator.pop(context);
                },
                child: Text(i18n.debugSetDefeat),
              ),

              SimpleDialogOption(
                onPressed: (gameState?.isFilling ?? false)
                    ? () {
                        gameStateCubit.debugFillStepForward();

                        Navigator.pop(context);
                      }
                    : null,
                child: Text(i18n.debugStepForward),
              ),
            ],
          ),
        );
      },
      mini: true,
      backgroundColor: Colors.red,
      foregroundColor: Colors.black,
      tooltip: i18n.debug,
      child: const Icon(Icons.bug_report),
    );
  }
}

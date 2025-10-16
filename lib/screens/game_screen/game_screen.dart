import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mzflood/bloc/app_settings/app_settings_bloc.dart';
import 'package:mzflood/bloc/app_settings/game_state_bloc.dart';
import 'package:mzflood/constants/game_grid_palette.dart';
import 'package:mzflood/domain/game_grid.dart';
import 'package:mzflood/l10n/app_localizations.dart';
import 'package:mzflood/screens/game_screen/widgets/color_selector.dart';
import 'package:mzflood/screens/game_screen/widgets/game_board.dart';
import 'package:mzflood/screens/game_screen/widgets/game_status_bar.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  static const Color warningColor = Colors.amber;
  static const Color defeatColor = Colors.red;
  static const Color victoryColor = Colors.green;

  static const Duration initializationDelay = Duration(microseconds: 500);

  static const int colorsPerRow = 5;

  void autoStartGame(GameStateCubit cubit, AppSettingsState settingsState) {
    cubit.initFromAppSettings(settingsState);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      floatingActionButton: kDebugMode
          ? FloatingActionButton(
              onPressed: () {
                GameStateCubit gameStateCubit = context.read<GameStateCubit>();
                GameState? gameState = gameStateCubit.state;

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text(localizations.debug),
                      children: <Widget>[
                        SimpleDialogOption(
                          onPressed: () {
                            if (gameState != null) {
                              gameStateCubit.setGameStateExplicitly(
                                gameState.copyWith(
                                  stepsDone: 0,
                                  gameGrid: GameGrid<int>.generate(
                                    width: gameState.settings.gridWidth,
                                    height: gameState.settings.gridHeight,
                                    valueGenerator: (_) => 0,
                                  ),
                                ),
                              );
                            }

                            Navigator.pop(context);
                          },
                          child: Text(localizations.debugSetVictory),
                        ),

                        SimpleDialogOption(
                          onPressed: () {
                            if (gameState != null) {
                              gameStateCubit.setGameStateExplicitly(
                                gameState.copyWith(
                                  stepsDone: gameState.settings.maxMoves,
                                  gameGrid: gameState.settings.getNewGrid(),
                                ),
                              );
                            }

                            Navigator.pop(context);
                          },
                          child: Text(localizations.debugSetDefeat),
                        ),

                        SimpleDialogOption(
                          onPressed: (gameState?.isFilling ?? false)
                              ? () {
                                  gameStateCubit.stepForward();

                                  Navigator.pop(context);
                                }
                              : null,
                          child: Text(localizations.debugStepForward),
                        ),
                      ],
                    );
                  },
                );
              },
              mini: true,
              backgroundColor: Colors.red,
              foregroundColor: Colors.black,
              tooltip: localizations.debug,
              child: Icon(Icons.bug_report),
            )
          : null,
      floatingActionButtonLocation: kDebugMode ? FloatingActionButtonLocation.miniEndFloat : null,
      body: SafeArea(
        child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
          builder: (context, settingsState) {
            return BlocBuilder<GameStateCubit, GameState?>(
              builder: (context, gameState) {
                // Couldn't come up with a better autostart solution yet. It works though.
                if (gameState == null) {
                  Future.delayed(initializationDelay).then((value) {
                    if (!context.mounted) return;

                    autoStartGame(context.read<GameStateCubit>(), settingsState);
                  });

                  return Center(child: CircularProgressIndicator());
                }

                Palette gameGridPalette = gameState.settings.getPalette();

                Color? stateColor;

                switch (gameState.winningState) {
                  case WinningState.inProgress:
                    if (gameState.fewMovesLeft) {
                      stateColor = warningColor;
                    }
                  case WinningState.victory:
                    stateColor = victoryColor;
                  case WinningState.defeat:
                    stateColor = defeatColor;
                }

                return Theme(
                  data: (stateColor != null)
                      ? ThemeData(
                          colorSchemeSeed: stateColor,
                          brightness: Theme.brightnessOf(context),
                        )
                      : Theme.of(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 8,
                      children: [
                        Card(child: GameStatusBar(gameState: gameState)),
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Stack(
                              fit: StackFit.expand,
                              alignment: Alignment.center,
                              children: [
                                Center(
                                  child: GameBoard(
                                    gameState: gameState,
                                    palette: gameGridPalette,
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  child: AnimatedOpacity(
                                    opacity:
                                        gameState.winningState ==
                                            WinningState.inProgress
                                        ? 0
                                        : 1,
                                    duration: Duration(milliseconds: 200),
                                    child: AnimatedSize(
                                      duration: Duration(milliseconds: 200),
                                      child: Container(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surface.withAlpha(210),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 16,
                                        ),
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          child: Builder(
                                            builder: (context) {
                                              switch (gameState.winningState) {
                                                case WinningState.inProgress:
                                                  return SizedBox();
                                                case WinningState.victory:
                                                  return Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.messageVictory,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.copyWith(
                                                          color: stateColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  );
                                                case WinningState.defeat:
                                                  return Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.messageDefeat,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.copyWith(
                                                          color: stateColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedCrossFade(
                          firstChild: Visibility(
                            visible:
                                settingsState.showColorPanel &&
                                gameState.gameGrid.totalUniqueValuesOnGrid > 1,
                            child: Card(
                              child: ColorSelector(
                                gameState: gameState,
                                palette: gameGridPalette,
                                colorsPerRow: colorsPerRow,
                              ),
                            ),
                          ),
                          secondChild: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: FittedBox(
                                child: Row(
                                  spacing: 16,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        context
                                            .read<GameStateCubit>()
                                            .startNewGame(gameState.settings);
                                      },
                                      style: ButtonStyle(
                                        padding:
                                            WidgetStateProperty.all<EdgeInsets>(
                                              EdgeInsets.symmetric(
                                                horizontal: 24,
                                                vertical: 20,
                                              ),
                                            ),
                                        iconSize:
                                            WidgetStateProperty.all<double>(30),
                                        textStyle:
                                            WidgetStateProperty.all<TextStyle>(
                                              TextStyle(fontSize: 30),
                                            ),
                                      ),
                                      icon: Icon(Icons.restore),
                                      label: Text(
                                        localizations.buttonRestartBoard,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        context
                                            .read<GameStateCubit>()
                                            .startNewGame(
                                              gameState.settings
                                                  .withNewAppSettings(
                                                    settingsState,
                                                  )
                                                  .copyWith(seed: () => null),
                                            );
                                      },
                                      style: ButtonStyle(
                                        padding:
                                            WidgetStateProperty.all<EdgeInsets>(
                                              EdgeInsets.symmetric(
                                                horizontal: 24,
                                                vertical: 20,
                                              ),
                                            ),
                                        iconSize:
                                            WidgetStateProperty.all<double>(30),
                                        textStyle:
                                            WidgetStateProperty.all<TextStyle>(
                                              TextStyle(fontSize: 30),
                                            ),
                                      ),
                                      icon: Icon(Icons.play_arrow),
                                      label: Text(localizations.buttonNewGame),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          crossFadeState:
                              gameState.winningState == WinningState.inProgress
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: Duration(milliseconds: 500),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

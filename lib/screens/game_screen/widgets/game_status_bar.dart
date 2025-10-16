import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mzflood/bloc/app_settings/app_settings_bloc.dart';
import 'package:mzflood/bloc/app_settings/game_state_bloc.dart';
import 'package:mzflood/l10n/app_localizations.dart';

class GameStatusBar extends StatelessWidget {
  final GameState gameState;

  const GameStatusBar({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    // TODO: Refactor this widget (extract each component)

    GameStateCubit gameStateCubit = context.read<GameStateCubit>();

    Color stateColor = HSLColor.fromColor(
      Theme.of(context).colorScheme.primary,
    ).withSaturation(1).toColor();

    double movesCounterFontSize = 40;
    double maxMovesFontSize = movesCounterFontSize * 0.5;

    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, settingsState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 24,
            children: [
              RichText(
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
                      text: " / ${gameState.settings.maxMoves}",
                      style: TextStyle(
                        fontSize: maxMovesFontSize,
                        color: stateColor.withAlpha(190),
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8,
                children: [
                  Tooltip(
                    message: AppLocalizations.of(context)!.buttonNewGame,
                    child: IconButton.filled(
                      onPressed: () {
                        gameStateCubit.startNewGame(
                          gameState.settings
                              .withNewAppSettings(settingsState)
                              .copyWith(seed: () => null),
                        );

                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(
                                context,
                              )!.messageNewGameStarted,
                            ),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: Icon(Icons.replay),
                    ),
                  ),

                  Tooltip(
                    message: AppLocalizations.of(context)!.buttonRestartBoard,
                    child: IconButton.filled(
                      onPressed: gameState.stepsDone > 0
                          ? () {
                              gameStateCubit.startNewGame(gameState.settings);

                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.messageBoardRestarted,
                                  ),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          : null,
                      icon: Icon(Icons.restore),
                    ),
                  ),

                  Tooltip(
                    message: AppLocalizations.of(context)!.titleSettings,
                    child: IconButton.filled(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/app-settings');
                      },
                      icon: Icon(Icons.settings),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

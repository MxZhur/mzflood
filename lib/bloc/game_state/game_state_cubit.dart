import 'dart:ui';

import 'package:bloc/bloc.dart';

import '/bloc/app_settings/app_settings_state.dart';
import '/domain/game_grid.dart';
import '/domain/game_settings.dart';
import 'game_state.dart';

class GameStateCubit extends Cubit<GameState?> {
  GameStateCubit({AppSettingsState? appSettings}) : super(null);

  void initFromAppSettings(AppSettingsState appSettings) {
    emit(GameState.withGameSettings(GameSettings.fromAppSettings(appSettings)));
  }

  void startGame(GameSettings settings) {
    final newGameState = GameState(
      settings: settings,
      gameGrid: settings.generateGrid(),
    );

    emit(newGameState);
  }

  void resetBoard() {
    if (state == null) {
      return;
    }

    startGame(state!.settings);
  }

  Future<void> makeMove(ColorIndex colorIndex) async {
    if (state == null) {
      return;
    }

    if (state!.fillingPointColor == colorIndex) {
      return;
    }

    final newState = state!.startMove(colorIndex);

    if (!state!.isFilling) {
      startTicker(newState);
    }
  }

  void startTicker(GameState oldState) async {
    if (state == null) {
      return;
    }

    var newState = oldState;

    do {
      newState = newState.propagateFill();
      if (newState.settings.fillDelay > 0) {
        emit(newState);

        if (newState.isFilling) {
          await Future.delayed(state!.settings.fillDelayDuration);
        }
      }
    } while (newState.isFilling);

    if (newState.settings.fillDelay == 0) {
      emit(newState);
    }
  }

  void debugFillStepForward() {
    if (state == null || !state!.isFilling) {
      return;
    }

    final newState = state!.propagateFill();

    emit(newState);
  }

  void setGameStateExplicitly(GameState newGameState) {
    emit(newGameState);
  }

  void debugSetCellAtIndex(GridIndex index, ColorIndex colorIndex) {
    final newState = state?.updateCellAtIndex(
      Map<GridIndex, ColorIndex>.fromEntries([MapEntry(index, colorIndex)]),
    );

    emit(newState);
  }

  void syncPaletteSettings({
    bool? monochromeMode,
    Color? Function()? monochromeSeedColor,
    double? saturationShift,
    double? lowestBrightness,
    double? highestBrightness,
  }) {
    if (state == null) {
      return;
    }

    emit(
      state!.copyWith(
        settings: state!.settings.withNewPaletteSettings(
          monochromeMode: monochromeMode,
          monochromeSeedColor: monochromeSeedColor,
          saturationShift: saturationShift,
          lowestBrightness: lowestBrightness,
          highestBrightness: highestBrightness,
        ),
      ),
    );
  }

  void syncNewAnimationSettings({int? fillDelay}) {
    if (state == null) {
      return;
    }

    emit(
      state!.copyWith(
        settings: state!.settings.withNewAnimationSettings(
          fillDelay: fillDelay,
        ),
      ),
    );
  }

  void clear() {
    emit(null);
  }
}

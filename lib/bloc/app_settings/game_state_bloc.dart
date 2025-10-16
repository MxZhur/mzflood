import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mzflood/bloc/app_settings/app_settings_bloc.dart';

import 'package:mzflood/domain/game_grid.dart';
import 'package:mzflood/domain/game_settings.dart';

class GameStateCubit extends Cubit<GameState?> {
  GameStateCubit({AppSettingsState? appSettings}) : super(null);

  void initFromAppSettings(AppSettingsState appSettings) {
    emit(
      GameState.withGameSettings(
        GameSettings.fromAppSettings(appSettings),
      ),
    );
  }

  void startNewGame(GameSettings settings) {
    final GameState newGameState = GameState(
      settings: settings,
      gameGrid: settings.getNewGrid(),
    );

    emit(newGameState);
  }

  Future<void> makeMove(int colorIndex) async {
    if (state == null) {
      return;
    }

    if (state!.fillingPointColor == colorIndex) {
      return;
    }

    GameState newState = state!.startMove(colorIndex);

    if (!state!.isFilling) {
      startTicker(newState);
    }
  }

  void startTicker(GameState oldState) async {
    if (state == null) {
      return;
    }

    GameState newState = oldState;

    do {
      newState = newState.propagateFill();
      if (newState.settings.fillDelay > 0) {
        if (newState.isFilling) {
          await Future.delayed(
            Duration(milliseconds: 20 * state!.settings.fillDelay),
          );
        }
        emit(newState);
      }
    } while (newState.isFilling);

    if (newState.settings.fillDelay == 0) {
      emit(newState);
    }
  }

  void stepForward() {
    if (state == null || !state!.isFilling) {
      return;
    }

    GameState newState = state!.propagateFill();

    emit(newState);
  }

  void setGameStateExplicitly(GameState newGameState) {
    emit(newGameState);
  }

  void setCellAtIndex(int index, int colorIndex) {
    final GameState? newState = state?.updateCellAtIndex(
      Map<int, int>.fromEntries([MapEntry(index, colorIndex)]),
    );

    emit(newState);
  }

  void syncPaletteSettings({
    bool? monochromeMode,
    ValueGetter<Color?>? monochromeSeedColor,
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

  void clear() {
    emit(null);
  }
}

enum WinningState { inProgress, victory, defeat }

class GameState extends Equatable {
  final GameSettings settings;
  final GameGrid<int> gameGrid;
  final GameGrid<int?>? propagationGrid;
  final int stepsDone;

  final List<FillingQueueItem> fillingQueue;

  bool get isFilling => fillingQueue.isNotEmpty;

  const GameState({
    required this.settings,
    this.gameGrid = const GameGrid(width: 0, height: 0, cells: []),
    this.stepsDone = 0,
    this.propagationGrid,
    this.fillingQueue = const [],
  });

  factory GameState.withGameSettings(GameSettings gameSettings) =>
      GameState(settings: gameSettings, gameGrid: gameSettings.getNewGrid());

  int get fillingPointColor => gameGrid.valueAtPoint(settings.fillSourcePoint);

  WinningState get winningState {
    if (isFilling) {
      return WinningState.inProgress;
    }

    if (gameGrid.totalUniqueValuesOnGrid == 1) {
      return WinningState.victory;
    } else if (stepsDone >= settings.maxMoves) {
      return WinningState.defeat;
    }

    return WinningState.inProgress;
  }

  bool get fewMovesLeft => (stepsDone / settings.maxMoves) >= 0.8;

  GameState updateCellAtIndex(Map<int, int> newColors) {
    GameGrid<int> updatedGameGrid = gameGrid.updateCellAtIndex(newColors);

    return copyWith(gameGrid: updatedGameGrid);
  }

  GameState startMove(int colorIndex) {
    if (fillingPointColor == colorIndex) {
      return this;
    }

    if (winningState == WinningState.victory) {
      return this;
    }

    if (stepsDone >= settings.maxMoves) {
      return this;
    }

    return copyWith(
      stepsDone: stepsDone + 1,
      fillingQueue:
          fillingQueue +
          <FillingQueueItem>[
            (colorIndexFrom: fillingPointColor, colorIndexTo: colorIndex),
          ],
      propagationGrid: () => GameGrid<int?>.generate(
        width: gameGrid.width,
        height: gameGrid.height,
        valueGenerator: (index) {
          if (index == gameGrid.indexAt(settings.fillSourcePoint)) {
            return colorIndex;
          } else {
            return propagationGrid?.valueAt(index);
          }
        },
      ),
    );
  }

  GameState propagateFill() {
    if (propagationGrid == null) {
      return copyWith(fillingQueue: []);
    }

    Map<GridIndex, ColorIndex> affectedCells = {};

    for (
      var gridIndex = 0;
      gridIndex < propagationGrid!.cells.length;
      gridIndex++
    ) {
      if (propagationGrid!.cells[gridIndex] != null) {
        affectedCells[gridIndex] = propagationGrid!.cells[gridIndex]!;
      }
    }

    GameGrid<int> updatedGameGrid = gameGrid.updateCellAtIndex(affectedCells);

    Map<GridIndex, ColorIndex> newPropagationCells = {};

    List<bool> fillingQueueStatus = List<bool>.filled(
      fillingQueue.length,
      false,
    );

    for (var queueIndex = 0; queueIndex < fillingQueue.length; queueIndex++) {
      FillingQueueItem fillingQueueItem = fillingQueue[queueIndex];

      affectedCells.entries
          .where((mapEntry) => mapEntry.value == fillingQueueItem.colorIndexTo)
          .forEach((mapEntry) {
            GridPoint pivotPoint = propagationGrid!.coordinatesAt(mapEntry.key);

            List<GridPoint> nextPropagationPoints =
                [
                  (x: pivotPoint.x, y: pivotPoint.y - 1),
                  (x: pivotPoint.x, y: pivotPoint.y + 1),
                  (x: pivotPoint.x - 1, y: pivotPoint.y),
                  (x: pivotPoint.x + 1, y: pivotPoint.y),
                ].where((candidatePoint) {
                  if (candidatePoint.x < 0 ||
                      candidatePoint.x >= propagationGrid!.width ||
                      candidatePoint.y < 0 ||
                      candidatePoint.y >= propagationGrid!.height) {
                    return false;
                  }

                  if (newPropagationCells.containsKey(mapEntry.key)) {
                    return false;
                  }

                  if (gameGrid.valueAtPoint(candidatePoint) !=
                      fillingQueueItem.colorIndexFrom) {
                    return false;
                  }

                  if (gameGrid.valueAtPoint(candidatePoint) ==
                      fillingQueueItem.colorIndexTo) {
                    return false;
                  }

                  return true;
                }).toList();

            fillingQueueStatus[queueIndex] =
                fillingQueueStatus[queueIndex] ||
                nextPropagationPoints.isNotEmpty;

            for (GridPoint element in nextPropagationPoints) {
              newPropagationCells[propagationGrid!.indexAt(element)] =
                  fillingQueueItem.colorIndexTo;
            }
          });
    }

    // Queue cleanup
    List<FillingQueueItem> newFillingQueue = fillingQueue
        .asMap()
        .entries
        .where((element) => fillingQueueStatus[element.key] != false)
        .map((e) => e.value)
        .toList();

    GameGrid<ColorIndex?> newPropagationGrid = GameGrid<ColorIndex?>.generate(
      width: propagationGrid!.width,
      height: propagationGrid!.height,
      valueGenerator: (index) {
        return newPropagationCells[index];
      },
    );

    return copyWith(
      fillingQueue: newFillingQueue,
      gameGrid: updatedGameGrid,
      propagationGrid: () => newPropagationGrid,
    );
  }

  @override
  List<Object?> get props {
    return [settings, gameGrid, propagationGrid, stepsDone, fillingQueue];
  }

  GameState copyWith({
    GameSettings? settings,
    GameGrid<int>? gameGrid,
    ValueGetter<GameGrid<int?>?>? propagationGrid,
    int? stepsDone,
    List<FillingQueueItem>? fillingQueue,
  }) {
    return GameState(
      settings: settings ?? this.settings,
      gameGrid: gameGrid ?? this.gameGrid,
      propagationGrid: propagationGrid != null
          ? propagationGrid()
          : this.propagationGrid,
      stepsDone: stepsDone ?? this.stepsDone,
      fillingQueue: fillingQueue ?? this.fillingQueue,
    );
  }
}

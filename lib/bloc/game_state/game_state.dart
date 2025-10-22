import 'package:equatable/equatable.dart';

import '/domain/game_grid.dart';
import '/domain/game_settings.dart';
import '/utils/range_functions.dart';

class GameState extends Equatable {
  static const double lowMovesCountPercentThreshold = 0.2;

  final GameSettings settings;
  final GameGrid<ColorIndex> gameGrid;
  final GameGrid<ColorIndex?>? propagationGrid;

  final int stepsDone;

  final List<FillingQueueItem> fillingQueue;

  const GameState({
    required this.settings,
    this.gameGrid = const GameGrid(width: 0, height: 0, cells: []),
    this.stepsDone = 0,
    this.propagationGrid,
    this.fillingQueue = const [],
  });

  factory GameState.withGameSettings(GameSettings gameSettings) =>
      GameState(settings: gameSettings, gameGrid: gameSettings.generateGrid());

  bool get fewMovesLeft =>
      settings.maxMoves != 0 &&
      (stepsDone / settings.maxMoves) >= (1 - lowMovesCountPercentThreshold);

  ColorIndex get fillingPointColor =>
      gameGrid.valueAtPoint(settings.fillSourcePoint);

  bool get isFilling => fillingQueue.isNotEmpty;

  @override
  List<Object?> get props => [
    settings,
    gameGrid,
    propagationGrid,
    stepsDone,
    fillingQueue,
  ];

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

  GameState copyWith({
    GameSettings? settings,
    GameGrid<ColorIndex>? gameGrid,
    GameGrid<ColorIndex?>? Function()? propagationGrid,
    int? stepsDone,
    List<FillingQueueItem>? fillingQueue,
  }) => GameState(
    settings: settings ?? this.settings,
    gameGrid: gameGrid ?? this.gameGrid,
    propagationGrid: propagationGrid != null
        ? propagationGrid()
        : this.propagationGrid,
    stepsDone: stepsDone ?? this.stepsDone,
    fillingQueue: fillingQueue ?? this.fillingQueue,
  );

  GameState propagateFill() {
    if (propagationGrid == null) {
      return copyWith(fillingQueue: []);
    }

    final affectedCells = <GridIndex, ColorIndex>{};

    for (
      var gridIndex = 0;
      gridIndex < propagationGrid!.cells.length;
      gridIndex++
    ) {
      if (propagationGrid!.cells[gridIndex] != null) {
        affectedCells[gridIndex] = propagationGrid!.cells[gridIndex]!;
      }
    }

    final updatedGameGrid = gameGrid.updateCellAtIndex(affectedCells);
    final newPropagationCells = <GridIndex, ColorIndex>{};
    final fillingQueueStatus = List<bool>.filled(fillingQueue.length, false);

    for (var queueIndex = 0; queueIndex < fillingQueue.length; queueIndex++) {
      final fillingQueueItem = fillingQueue[queueIndex];

      affectedCells.entries
          .where((mapEntry) => mapEntry.value == fillingQueueItem.colorIndexTo)
          .forEach((mapEntry) {
            final pivotPoint = propagationGrid!.coordinatesAt(mapEntry.key);

            final nextPropagationPoints =
                [
                  (x: pivotPoint.x, y: pivotPoint.y - 1),
                  (x: pivotPoint.x, y: pivotPoint.y + 1),
                  (x: pivotPoint.x - 1, y: pivotPoint.y),
                  (x: pivotPoint.x + 1, y: pivotPoint.y),
                ].where((candidatePoint) {
                  if (isOutOfArrayRange(
                        candidatePoint.x,
                        propagationGrid!.width,
                      ) ||
                      isOutOfArrayRange(
                        candidatePoint.y,
                        propagationGrid!.height,
                      )) {
                    return false;
                  }

                  // Prevent cell duplication in the queue
                  if (newPropagationCells.containsKey(mapEntry.key)) {
                    return false;
                  }

                  // Don't touch a different color
                  if (gameGrid.valueAtPoint(candidatePoint) !=
                      fillingQueueItem.colorIndexFrom) {
                    return false;
                  }

                  // Don't touch the color you're filling with
                  if (gameGrid.valueAtPoint(candidatePoint) ==
                      fillingQueueItem.colorIndexTo) {
                    return false;
                  }

                  return true;
                }).toList();

            fillingQueueStatus[queueIndex] =
                fillingQueueStatus[queueIndex] ||
                nextPropagationPoints.isNotEmpty;

            for (final propagationPoint in nextPropagationPoints) {
              newPropagationCells[propagationGrid!.indexAt(propagationPoint)] =
                  fillingQueueItem.colorIndexTo;
            }
          });
    }

    // Queue cleanup
    final newFillingQueue = fillingQueue
        .asMap()
        .entries
        .where((queueItem) => fillingQueueStatus[queueItem.key] != false)
        .map((e) => e.value)
        .toList();

    final newPropagationGrid = GameGrid<ColorIndex?>.generate(
      width: propagationGrid!.width,
      height: propagationGrid!.height,
      valueGenerator: (index) => newPropagationCells[index],
    );

    return copyWith(
      fillingQueue: newFillingQueue,
      gameGrid: updatedGameGrid,
      propagationGrid: () => newPropagationGrid,
    );
  }

  GameState startMove(ColorIndex colorIndex) {
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
      propagationGrid: () => GameGrid<ColorIndex?>.generate(
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

  GameState updateCellAtIndex(Map<GridIndex, ColorIndex> newColors) {
    final updatedGameGrid = gameGrid.updateCellAtIndex(newColors);
    return copyWith(gameGrid: updatedGameGrid);
  }
}

enum WinningState { inProgress, victory, defeat }

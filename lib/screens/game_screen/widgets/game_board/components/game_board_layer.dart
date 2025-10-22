import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '/bloc/app_settings/app_settings_state.dart';
import '/bloc/game_state/game_state.dart';
import '/domain/game_grid.dart';
import 'game_board_cell.dart';

class GameBoardLayer extends StatelessWidget {
  final GameGrid grid;
  final Color Function(GridIndex index) cellColorGenerator;
  final GameState gameState;
  final AppSettingsState settingsState;
  final bool showFillingPoint;
  final void Function(GridIndex gridIndex)? onCellPress;

  const GameBoardLayer({
    super.key,
    required this.grid,
    required this.cellColorGenerator,
    required this.gameState,
    required this.settingsState,
    this.showFillingPoint = true,
    this.onCellPress,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, constraints) {
      final maxWidthPerCell =
          constraints.maxWidth / gameState.settings.gridWidth;
      final maxHeightPerCell =
          constraints.maxHeight / gameState.settings.gridHeight;
      final shortestSize = min(maxWidthPerCell, maxHeightPerCell);

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: grid.cells
            .slices(gameState.settings.gridWidth)
            .mapIndexed<Widget>(
              (rowIndex, row) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: row.mapIndexed((columnIndex, colorIndex) {
                  final gridIndex = grid.indexAt((x: columnIndex, y: rowIndex));

                  final isFillingPoint =
                      gridIndex ==
                      grid.indexAt(gameState.settings.fillSourcePoint);

                  return GameBoardCell(
                    cellColor: cellColorGenerator(gridIndex),
                    cellEdgeType: gameState.gameGrid.edgeTypeByIndex(gridIndex),
                    connectionFlags: gameState.gameGrid.getConnectionsByIndex(
                      gridIndex,
                    ),
                    size: shortestSize,
                    separationRadius: shortestSize * 0.27,
                    separationPadding: shortestSize * 0.027,
                    animationDuration: gameState.settings.cellAnimationDuration,
                    colorIndex: colorIndex,
                    isFillingPoint: showFillingPoint && isFillingPoint,
                    colorAccessabilityMode:
                        settingsState.colorAccessabilityMode,
                    onPress:
                        (onCellPress != null &&
                            gameState.fillingPointColor != colorIndex)
                        ? () => onCellPress!(gridIndex)
                        : null,
                  );
                }).toList(),
              ),
            )
            .toList(),
      );
    },
  );
}

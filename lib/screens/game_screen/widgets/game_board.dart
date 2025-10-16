import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mzflood/bloc/app_settings/app_settings_bloc.dart';
import 'package:mzflood/bloc/app_settings/game_state_bloc.dart';
import 'package:mzflood/domain/game_grid.dart';
import 'package:mzflood/screens/game_screen/widgets/cell_accessability_mark.dart';
import 'package:mzflood/screens/game_screen/widgets/cell_filling_point_mark.dart';

class GameBoard extends StatelessWidget {
  final GameState gameState;
  final List<Color> palette;

  const GameBoard({super.key, required this.gameState, required this.palette});

  @override
  Widget build(BuildContext context) {
    // TODO: Refactor this widget

    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, settingsState) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                buildGridLayer(
                  context: context,
                  grid: gameState.gameGrid,
                  cellColorGenerator: (index) =>
                      palette[gameState.gameGrid.valueAt(index)],
                  gameState: gameState,
                  settingsState: settingsState,
                  constraints: constraints,
                  onCellPress: (gridIndex) {
                    context.read<GameStateCubit>().makeMove(
                      gameState.gameGrid.valueAt(gridIndex),
                    );
                  },
                  showFillingPoint:
                      gameState.winningState != WinningState.victory,
                ),
                if (gameState.propagationGrid != null)
                  IgnorePointer(
                    child: buildGridLayer(
                      context: context,
                      grid: gameState.propagationGrid!,
                      cellColorGenerator: (index) =>
                          gameState.propagationGrid!.valueAt(index) != null
                          ? Colors.white.withAlpha(127)
                          : Colors.white.withAlpha(0),
                      gameState: gameState,
                      settingsState: settingsState,
                      constraints: constraints,
                      showFillingPoint: false,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildGridLayer({
    required BuildContext context,
    required GameGrid grid,
    required Color Function(int index) cellColorGenerator,
    required GameState gameState,
    required AppSettingsState settingsState,
    required BoxConstraints constraints,
    bool showFillingPoint = true,
    void Function(GridIndex gridIndex)? onCellPress,
  }) {
    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: grid.cells
            .slices(gameState.settings.gridWidth)
            .mapIndexed<Widget>(
              (rowIndex, row) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: row.mapIndexed((columnIndex, cell) {
                  int gridIndex = grid.indexAt((x: columnIndex, y: rowIndex));
                  int? colorIndex = grid.valueAt(gridIndex);
      
                  final bool isFillingPoint =
                      gridIndex ==
                      grid.indexAt(gameState.settings.fillSourcePoint);
      
                  return GameBoardCell(
                    cellColor: cellColorGenerator(gridIndex),
                    cellEdgeType: gameState.gameGrid.edgeTypeByIndex(
                      gridIndex,
                    ),
                    connectionFlags: gameState.gameGrid.getConnectionsByIndex(
                      gridIndex,
                    ),
                    separationRadius:
                        min(constraints.maxWidth, constraints.maxHeight) *
                        0.025,
                    separationPadding:
                        min(constraints.maxWidth, constraints.maxHeight) *
                        0.0025,
                    colorIndex: colorIndex,
                    isFillingPoint: showFillingPoint && isFillingPoint,
                    colorAccessabilityMode:
                        settingsState.colorAccessabilityMode,
                    onPress:
                        (onCellPress != null &&
                            gameState.fillingPointColor != colorIndex)
                        ? () => onCellPress(gridIndex)
                        : null,
                  );
                }).toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}

class GameBoardCell extends StatelessWidget {
  const GameBoardCell({
    super.key,
    required this.cellColor,
    required this.isFillingPoint,
    required this.connectionFlags,
    this.separationRadius = 8,
    this.separationPadding = 8,
    this.cellEdgeType = CellEdgeType.inner,
    this.colorAccessabilityMode = false,
    this.colorIndex,
    this.onPress,
  });

  final bool isFillingPoint;

  final Color cellColor;
  final int? colorIndex;
  final CellEdgeType cellEdgeType;
  final CellNeighborsConnectionFlags connectionFlags;
  final bool colorAccessabilityMode;
  final double separationRadius;
  final double separationPadding;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    List<Widget> cellMarks = [
      if (colorAccessabilityMode && colorIndex != null)
        CellAccessabilityMark(
          colorIndex: colorIndex!,
          backgroundColor: cellColor,
        ),
      if (isFillingPoint)
        CellFillingPointMark(
          backgroundColor: cellColor,
          colorAccessabilityMode: colorAccessabilityMode,
        ),
    ];

    final BorderRadius cellBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(
        (cellEdgeType == CellEdgeType.cornerTopLeft ||
                (connectionFlags.northIsDifferent &&
                    connectionFlags.westIsDifferent))
            ? separationRadius
            : 0,
      ),
      topRight: Radius.circular(
        (cellEdgeType == CellEdgeType.cornerTopRight ||
                (connectionFlags.northIsDifferent &&
                    connectionFlags.eastIsDifferent))
            ? separationRadius
            : 0,
      ),
      bottomLeft: Radius.circular(
        (cellEdgeType == CellEdgeType.cornerBottomLeft ||
                (connectionFlags.southIsDifferent &&
                    connectionFlags.westIsDifferent))
            ? separationRadius
            : 0,
      ),
      bottomRight: Radius.circular(
        (cellEdgeType == CellEdgeType.cornerBottomRight ||
                (connectionFlags.southIsDifferent &&
                    connectionFlags.eastIsDifferent))
            ? separationRadius
            : 0,
      ),
    );

    final EdgeInsets separationInsets = EdgeInsets.only(
      top: connectionFlags.northIsDifferent ? separationPadding : 0,
      bottom: connectionFlags.southIsDifferent ? separationPadding : 0,
      left: connectionFlags.westIsDifferent ? separationPadding : 0,
      right: connectionFlags.eastIsDifferent ? separationPadding : 0,
    );

    Widget animatedContainer = SizedBox(
      width: 50,
      height: 50,
      child: AnimatedContainer(
        padding: separationInsets,
        duration: Duration(milliseconds: 250),
        child: Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            // clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: cellColor,
              borderRadius: cellBorderRadius,
            ),
            child: cellMarks.isNotEmpty
                ? Center(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Stack(
                        alignment: AlignmentGeometry.center,
                        fit: StackFit.passthrough,
                        children: cellMarks,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );

    if (onPress != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            if (onPress != null) {
              onPress!();
            }
          },
          child: animatedContainer,
        ),
      );
    } else {
      return animatedContainer;
    }
  }
}

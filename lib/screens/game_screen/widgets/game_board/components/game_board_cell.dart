import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/domain/game_grid.dart';
import '/widgets/cell_accessability_mark.dart';
import 'cell_filling_point_mark.dart';

class GameBoardCell extends StatelessWidget {
  final bool isFillingPoint;
  final Color cellColor;
  final ColorIndex? colorIndex;
  final CellEdgeType cellEdgeType;
  final CellNeighborsConnectionFlags connectionFlags;
  final bool colorAccessabilityMode;
  final double size;
  final double separationRadius;
  final double separationPadding;
  final Duration animationDuration;
  final void Function()? onPress;

  const GameBoardCell({
    super.key,
    required this.cellColor,
    required this.isFillingPoint,
    required this.connectionFlags,
    this.size = 50,
    this.separationRadius = 8,
    this.separationPadding = 8,
    this.animationDuration = Durations.medium2,
    this.cellEdgeType = CellEdgeType.inner,
    this.colorAccessabilityMode = false,
    this.colorIndex,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.only(
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

    final separationInsets = EdgeInsets.only(
      top: connectionFlags.northIsDifferent ? separationPadding : 0,
      bottom: connectionFlags.southIsDifferent ? separationPadding : 0,
      left: connectionFlags.westIsDifferent ? separationPadding : 0,
      right: connectionFlags.eastIsDifferent ? separationPadding : 0,
    );

    final cellMarks = <Widget>[
      if (colorAccessabilityMode && colorIndex != null)
        FittedBox(
          child: CellAccessabilityMark(
            colorIndex: colorIndex!,
            backgroundColor: cellColor,
          ),
        ),
      if (isFillingPoint)
        CellFillingPointMark(
          backgroundColor: cellColor,
          colorAccessabilityMode: colorAccessabilityMode,
        ),
    ];

    return GestureDetector(
      onTap: (onPress != null)
          ? () {
              HapticFeedback.mediumImpact();
              onPress!();
            }
          : null,
      child: MouseRegion(
        cursor: (onPress != null)
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        child: SizedBox(
          width: size,
          height: size,
          child: AnimatedContainer(
            padding: separationInsets,
            duration: animationDuration,
            curve: Curves.easeInOut,
            child: Center(
              child: AnimatedContainer(
                duration: animationDuration,
                curve: Curves.easeInOut,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: cellColor,
                  borderRadius: borderRadius,
                ),
                child: cellMarks.isNotEmpty
                    ? Center(
                        child: Stack(
                          alignment: AlignmentGeometry.center,
                          fit: StackFit.passthrough,
                          children: cellMarks,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

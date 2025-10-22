import 'package:equatable/equatable.dart';

import '/utils/range_functions.dart';

typedef CellNeighborsConnectionFlags = ({
  bool northIsDifferent,
  bool southIsDifferent,
  bool westIsDifferent,
  bool eastIsDifferent,
});

typedef ColorIndex = int;
typedef FillingQueueItem = ({
  ColorIndex colorIndexFrom,
  ColorIndex colorIndexTo,
});

typedef GridIndex = int;

typedef GridPoint = ({int x, int y});

enum CellEdgeType {
  inner,
  edgeTop,
  edgeBottom,
  edgeLeft,
  edgeRight,
  cornerTopLeft,
  cornerTopRight,
  cornerBottomLeft,
  cornerBottomRight,
}

class GameGrid<T> extends Equatable {
  final int width;
  final int height;
  final List<T> cells;

  const GameGrid({
    required this.width,
    required this.height,
    required this.cells,
  });

  factory GameGrid.generate({
    required int width,
    required int height,
    required T Function(ColorIndex index) valueGenerator,
  }) => GameGrid(
    width: width,
    height: height,
    cells: List<T>.generate(width * height, (index) => valueGenerator(index)),
  );

  @override
  List<Object> get props => [width, height, cells];

  int get totalCells => width * height;

  int get totalUniqueValuesOnGrid => cells.toSet().length;

  List<T> get uniqueValuesOnGrid => cells.toSet().toList();

  GridPoint coordinatesAt(GridIndex index) =>
      (x: index % width, y: index ~/ width);

  GridPoint get centerPoint => (x: width ~/ 2, y: height ~/ 2);

  GameGrid<T> copyWith({int? width, int? height, List<T>? cells}) =>
      GameGrid<T>(
        width: width ?? this.width,
        height: height ?? this.height,
        cells: cells ?? this.cells,
      );

  CellEdgeType edgeTypeByIndex(GridIndex index) {
    final coordinates = coordinatesAt(index);

    if (isOutOfArrayRange(coordinates.x, width) ||
        isOutOfArrayRange(coordinates.y, height)) {
      throw Exception(
        'Invalid coordinates at index'
        '$index (${coordinates.x}:${coordinates.y})',
      );
    }

    final isOnLeftEdge = isAtStartOfArrayRange(coordinates.x, width);
    final isOnRightEdge = isAtEndOfArrayRange(coordinates.x, width);
    final isOnTopEdge = isAtStartOfArrayRange(coordinates.y, height);
    final isOnBottomEdge = isAtEndOfArrayRange(coordinates.y, height);

    if (isOnTopEdge && isOnLeftEdge) return CellEdgeType.cornerTopLeft;
    if (isOnTopEdge && isOnRightEdge) return CellEdgeType.cornerTopRight;
    if (isOnBottomEdge && isOnLeftEdge) return CellEdgeType.cornerBottomLeft;
    if (isOnBottomEdge && isOnRightEdge) return CellEdgeType.cornerBottomRight;
    if (isOnLeftEdge) return CellEdgeType.edgeLeft;
    if (isOnRightEdge) return CellEdgeType.edgeRight;
    if (isOnTopEdge) return CellEdgeType.edgeTop;
    if (isOnBottomEdge) return CellEdgeType.edgeBottom;
    return CellEdgeType.inner;
  }

  CellNeighborsConnectionFlags getConnectionsByIndex(GridIndex index) {
    final coordinates = coordinatesAt(index);

    if (isOutOfArrayRange(coordinates.x, width) ||
        isOutOfArrayRange(coordinates.y, height)) {
      throw Exception(
        'Invalid coordinates at index'
        '$index (${coordinates.x}:${coordinates.y})',
      );
    }

    final northPoint = (x: coordinates.x, y: coordinates.y - 1);
    final southPoint = (x: coordinates.x, y: coordinates.y + 1);
    final westPoint = (x: coordinates.x - 1, y: coordinates.y);
    final eastPoint = (x: coordinates.x + 1, y: coordinates.y);

    return (
      northIsDifferent:
          northPoint.y >= 0 && cells[index] != cells[indexAt(northPoint)],
      southIsDifferent:
          southPoint.y < height && cells[index] != cells[indexAt(southPoint)],
      westIsDifferent:
          westPoint.x >= 0 && cells[index] != cells[indexAt(westPoint)],
      eastIsDifferent:
          eastPoint.x < width && cells[index] != cells[indexAt(eastPoint)],
    );
  }

  GridIndex indexAt(GridPoint point) => (point.y * width) + point.x;

  GameGrid<T> updateCellAtIndex(Map<GridIndex, T> newValues) {
    final updatedCells = [...cells];

    newValues.forEach((key, value) {
      updatedCells[key] = value;
    });

    return copyWith(cells: updatedCells);
  }

  T valueAt(GridIndex index) => cells[index];

  T valueAtPoint(GridPoint point) => cells[indexAt(point)];
}

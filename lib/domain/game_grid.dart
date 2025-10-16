import 'package:equatable/equatable.dart';

typedef GridPoint = ({int x, int y});

typedef ColorIndex = int;
typedef GridIndex = int;

typedef FillingQueueItem = ({ColorIndex colorIndexFrom, ColorIndex colorIndexTo});

typedef CellNeighborsConnectionFlags = ({
  bool northIsDifferent,
  bool southIsDifferent,
  bool westIsDifferent,
  bool eastIsDifferent,
});

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

  @override
  List<Object> get props => [width, height, cells];

  int get totalCells => width * height;

  GridIndex indexAt(GridPoint point) => (point.y * width) + point.x;

  GridPoint coordinatesAt(GridIndex index) => (x: index % width, y: index ~/ width);

  T valueAt(int index) => cells[index];
  T valueAtPoint(GridPoint point) => cells[indexAt(point)];

  List<T> get uniqueValuesOnGrid => cells.toSet().toList();
  int get totalUniqueValuesOnGrid => cells.toSet().length;

  CellEdgeType edgeTypeByIndex(int index) {
    GridPoint coordinates = coordinatesAt(index);

    if (coordinates.x < 0 ||
        coordinates.x >= width ||
        coordinates.y < 0 ||
        coordinates.y >= height) {
      throw Exception(
        'Invalid coordinates at index $index (${coordinates.x}:${coordinates.y})',
      );
    }

    bool isOnLeftEdge = coordinates.x == 0;
    bool isOnRightEdge = coordinates.x == width - 1;
    bool isOnTopEdge = coordinates.y == 0;
    bool isOnBottomEdge = coordinates.y == height - 1;

    bool isInTopLeftCorner = isOnTopEdge && isOnLeftEdge;
    bool isInTopRightCorner = isOnTopEdge && isOnRightEdge;
    bool isInBottomLeftCorner = isOnBottomEdge && isOnLeftEdge;
    bool isInBottomRightCorner = isOnBottomEdge && isOnRightEdge;

    if (isInTopLeftCorner) {
      return CellEdgeType.cornerTopLeft;
    } else if (isInTopRightCorner) {
      return CellEdgeType.cornerTopRight;
    } else if (isInBottomLeftCorner) {
      return CellEdgeType.cornerBottomLeft;
    } else if (isInBottomRightCorner) {
      return CellEdgeType.cornerBottomRight;
    } else if (isOnLeftEdge) {
      return CellEdgeType.edgeLeft;
    } else if (isOnRightEdge) {
      return CellEdgeType.edgeRight;
    } else if (isOnTopEdge) {
      return CellEdgeType.edgeTop;
    } else if (isOnBottomEdge) {
      return CellEdgeType.edgeBottom;
    }

    return CellEdgeType.inner;
  }

  CellNeighborsConnectionFlags getConnectionsByIndex(int index) {
    GridPoint coordinates = coordinatesAt(index);

    if (coordinates.x < 0 ||
        coordinates.x >= width ||
        coordinates.y < 0 ||
        coordinates.y >= height) {
      throw Exception(
        'Invalid coordinates at index $index (${coordinates.x}:${coordinates.y})',
      );
    }

    final GridPoint northPoint = (x: coordinates.x, y: coordinates.y - 1);
    final GridPoint southPoint = (x: coordinates.x, y: coordinates.y + 1);
    final GridPoint westPoint = (x: coordinates.x - 1, y: coordinates.y);
    final GridPoint eastPoint = (x: coordinates.x + 1, y: coordinates.y);

    final bool northIsDifferent =
        northPoint.y >= 0 && cells[index] != cells[indexAt(northPoint)];

    final bool southIsDifferent =
        southPoint.y < height && cells[index] != cells[indexAt(southPoint)];

    final bool westIsDifferent =
        westPoint.x >= 0 && cells[index] != cells[indexAt(westPoint)];

    final bool eastIsDifferent =
        eastPoint.x < width && cells[index] != cells[indexAt(eastPoint)];

    return (
      northIsDifferent: northIsDifferent,
      southIsDifferent: southIsDifferent,
      westIsDifferent: westIsDifferent,
      eastIsDifferent: eastIsDifferent,
    );
  }

  GameGrid<T> updateCellAtIndex(Map<int, T> newValues) {
    List<T> updatedCells = [...cells];

    newValues.forEach((key, value) {
      updatedCells[key] = value;
    });

    return copyWith(cells: updatedCells);
  }

  factory GameGrid.generate({
    required int width,
    required int height,
    required T Function(int index) valueGenerator,
  }) {
    return GameGrid(
      width: width,
      height: height,
      cells: List<T>.generate(width * height, (index) => valueGenerator(index)),
    );
  }

  GameGrid<T> copyWith({int? width, int? height, List<T>? cells}) {
    return GameGrid<T>(
      width: width ?? this.width,
      height: height ?? this.height,
      cells: cells ?? this.cells,
    );
  }
}

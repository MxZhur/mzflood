import 'package:flutter/material.dart';

import '/domain/game_grid.dart';
import '/widgets/cell_accessability_mark.dart';

class PalettePreview extends StatelessWidget {
  static const cornerRadius = Radius.circular(12);

  static const leftEdgeRadius = BorderRadius.horizontal(left: cornerRadius);
  static const rightEdgeRadius = BorderRadius.horizontal(right: cornerRadius);
  final List<Color> palette;

  final bool colorAccessabilityMode;
  final double maxWidth;

  const PalettePreview({
    super.key,
    required this.palette,
    this.colorAccessabilityMode = false,
    this.maxWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(maxWidth: maxWidth),
    child: Row(
      spacing: 4,
      children: List<Widget>.generate(
        palette.length,
        (colorIndex) => Expanded(
          child: PalettePreviewSwatch(
            color: palette[colorIndex],
            colorIndex: colorIndex,
            borderRadius: colorIndex == 0
                ? leftEdgeRadius
                : colorIndex == palette.length - 1
                ? rightEdgeRadius
                : BorderRadius.zero,
            colorAccessabilityMode: colorAccessabilityMode,
          ),
        ),
      ),
    ),
  );
}

class PalettePreviewSwatch extends StatelessWidget {
  final Color color;
  final ColorIndex colorIndex;
  final BorderRadius borderRadius;
  final bool colorAccessabilityMode;

  const PalettePreviewSwatch({
    super.key,
    required this.color,
    required this.colorIndex,
    required this.borderRadius,
    required this.colorAccessabilityMode,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: color, borderRadius: borderRadius),
    height: 50,
    child: FittedBox(
      child: colorAccessabilityMode
          ? CellAccessabilityMark(
              colorIndex: colorIndex,
              backgroundColor: color,
            )
          : null,
    ),
  );
}

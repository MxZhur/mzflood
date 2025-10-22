import 'package:flutter/material.dart';

import '/domain/game_grid.dart';
import '/extensions/color_extension.dart';

class CellAccessabilityMark extends StatelessWidget {
  final ColorIndex colorIndex;

  final Color? backgroundColor;
  final double? fontSize;

  const CellAccessabilityMark({
    super.key,
    required this.colorIndex,
    this.backgroundColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = backgroundColor != null
        ? (backgroundColor!.isDark ? Colors.white : Colors.black)
        : null;

    return Text(
      (colorIndex + 1).toString(),
      style: TextStyle(color: textColor, fontSize: fontSize ?? 100),
    );
  }
}

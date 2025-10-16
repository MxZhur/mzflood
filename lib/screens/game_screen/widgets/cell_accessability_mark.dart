import 'package:flutter/material.dart';
import 'package:mzflood/extensions/color_extension.dart';

class CellAccessabilityMark extends StatelessWidget {
  const CellAccessabilityMark({
    super.key,
    required this.colorIndex,
    this.backgroundColor,
    this.fontSize,
  });

  final int colorIndex;
  final Color? backgroundColor;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final Color? textColor = backgroundColor != null ? (backgroundColor!.isDark ? Colors.white : Colors.black) : null;

    return Text(
      (colorIndex + 1).toString(),
      style: TextStyle(color: textColor, fontSize: fontSize ?? 100),
    );
  }
}

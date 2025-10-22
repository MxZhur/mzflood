import 'package:flutter/material.dart';

import '/constants/measures.dart';

class ResponsiveLayoutBox extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double? spacingHorizontal;
  final double? spacingVertical;

  const ResponsiveLayoutBox({
    super.key,
    this.children = const <Widget>[],
    this.spacing = 8.0,
    this.spacingHorizontal,
    this.spacingVertical,
  });

  @override
  Widget build(BuildContext context) =>
      screenIsSmall(MediaQuery.sizeOf(context).width)
      ? Column(spacing: spacingVertical ?? spacing, children: children)
      : Row(
          spacing: spacingHorizontal ?? spacing,
          children: [for (final child in children) Flexible(child: child)],
        );
}

import 'package:flutter/material.dart';

import '/extensions/color_extension.dart';
import '/utils/range_functions.dart';

class CellFillingPointMark extends StatefulWidget {
  final Color backgroundColor;

  final bool colorAccessabilityMode;

  const CellFillingPointMark({
    super.key,
    required this.backgroundColor,
    this.colorAccessabilityMode = false,
  });

  @override
  State<CellFillingPointMark> createState() => _CellFillingPointMarkState();
}

class _CellFillingPointMarkState extends State<CellFillingPointMark>
    with SingleTickerProviderStateMixin {
  static const double highestOpacity = 1.0;
  static const double lowestOpacity = 0.2;

  static const double biggestSize = 1.0;
  static const double smallestSize = 0.7;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Durations.extralong4,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 0,
        ).chain(CurveTween(curve: Curves.ease)),
        weight: 75.0,
      ),
    ]).animate(_animationController);

    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final markColor = widget.backgroundColor.isDark
        ? Colors.black
        : Colors.white;

    return LayoutBuilder(
      builder: (context, constraints) => AnimatedBuilder(
        animation: _animation,
        builder: (_, child) => Opacity(
          opacity: mapRange(
            _animation.value,
            0,
            1,
            lowestOpacity,
            highestOpacity,
          ),
          child: Icon(
            Icons.format_color_fill,
            color: markColor,
            size:
                constraints.maxHeight *
                0.85 *
                mapRange(_animation.value, 0, 1, smallestSize, biggestSize),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

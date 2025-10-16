import 'package:flutter/material.dart';
import 'package:mzflood/extensions/color_extension.dart';

class CellFillingPointMark extends StatefulWidget {
  const CellFillingPointMark({
    super.key,
    required this.backgroundColor,
    this.colorAccessabilityMode = false,
    this.highestOpacity = 1.0,
    this.lowestOpacity = 0.2,
  });

  final Color backgroundColor;
  final bool colorAccessabilityMode;
  final double highestOpacity;
  final double lowestOpacity;

  @override
  State<CellFillingPointMark> createState() => _CellFillingPointMarkState();
}

class _CellFillingPointMarkState extends State<CellFillingPointMark>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    TweenSequence<double> tween = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: widget.highestOpacity, end: widget.lowestOpacity),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.lowestOpacity, end: widget.highestOpacity),
        weight: 50.0,
      ),
    ]);

    _animation = _animationController.drive<double>(tween);

    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final Color markColor = widget.backgroundColor.isDark
        ? Colors.white
        : Colors.black;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Icon(
            Icons.format_color_fill,
            color: markColor,
            size: widget.colorAccessabilityMode ? 150 : 35,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

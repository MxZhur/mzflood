import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/bloc/game_state/game_state.dart';
import '/domain/game_grid.dart';
import '/widgets/cell_accessability_mark.dart';

class ColorSelectorButton extends StatelessWidget {
  static const double defaultCellAccessabilityMarkFontSize = 50.0;
  static const borderRadius = BorderRadius.all(Radius.circular(8.0));

  final GameState gameState;
  final Color color;
  final ColorIndex colorIndex;

  final bool colorAccessabilityMode;

  final void Function()? onPressed;

  const ColorSelectorButton({
    super.key,
    required this.gameState,
    required this.color,
    required this.colorIndex,
    this.colorAccessabilityMode = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final buttonStyle = ButtonStyle(
      padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.zero),
      mouseCursor: WidgetStateProperty.resolveWith<MouseCursor?>((states) {
        if (states.contains(WidgetState.disabled)) {
          return SystemMouseCursors.basic;
        }
        return null;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return color.withAlpha(0);
        }
        return color;
      }),
      shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states) {
        if (states.contains(WidgetState.disabled)) {
          return RoundedRectangleBorder(
            side: BorderSide(color: color, width: 8),
            borderRadius: borderRadius,
          );
        }
        return const RoundedRectangleBorder(borderRadius: borderRadius);
      }),
    );

    return ElevatedButton(
      onPressed: onPressed != null
          ? () {
              HapticFeedback.mediumImpact();
              onPressed!();
            }
          : null,
      style: buttonStyle,
      child: SizedBox(
        width: theme.buttonTheme.minWidth,
        height: theme.buttonTheme.height * 2,
        child: Center(
          child: colorAccessabilityMode
              ? FittedBox(
                  child: CellAccessabilityMark(
                    colorIndex: colorIndex,
                    backgroundColor: (gameState.fillingPointColor != colorIndex)
                        ? color
                        : null,
                    fontSize: defaultCellAccessabilityMarkFontSize,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

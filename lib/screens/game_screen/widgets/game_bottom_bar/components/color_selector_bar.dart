import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '/bloc/game_state/game_state.dart';
import '/commands/commands.dart';
import 'color_selector_button.dart';

class ColorSelectorBar extends StatelessWidget {
  static const int colorsPerRow = 5;

  final GameState gameState;
  final List<Color> palette;
  final bool colorAccessabilityMode;

  const ColorSelectorBar({
    super.key,
    required this.gameState,
    required this.palette,
    this.colorAccessabilityMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: const EdgeInsets.all(8),
        child: Visibility(
          visible: gameState.gameGrid.totalUniqueValuesOnGrid > 1,
          replacement: Center(
            child: Icon(
              Icons.check,
              size: theme.textTheme.displayMedium?.fontSize,
              color: Colors.greenAccent,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
                <Widget>[
                      for (final (colorIndex, color) in palette.indexed)
                        if (gameState.gameGrid.uniqueValuesOnGrid.contains(
                          colorIndex,
                        ))
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: ColorSelectorButton(
                                gameState: gameState,
                                color: color,
                                colorIndex: colorIndex,
                                colorAccessabilityMode: colorAccessabilityMode,
                                onPressed:
                                    (gameState.fillingPointColor != colorIndex)
                                    ? () => makeMove(
                                        context,
                                        colorIndex: colorIndex,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                    ]
                    .slices(colorsPerRow)
                    .map(
                      (row) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: row,
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }
}

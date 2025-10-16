import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mzflood/bloc/app_settings/app_settings_bloc.dart';
import 'package:mzflood/bloc/app_settings/game_state_bloc.dart';
import 'package:mzflood/screens/game_screen/widgets/cell_accessability_mark.dart';

class ColorSelector extends StatelessWidget {
  final GameState gameState;
  final List<Color> palette;
  final int colorsPerRow;

  const ColorSelector({
    super.key,
    required this.gameState,
    required this.palette,
    this.colorsPerRow = 5,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Refactor this widget

    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, settingsState) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: gameState.gameGrid.totalUniqueValuesOnGrid > 1,
                replacement: Center(
                  child: Icon(
                    Icons.check,
                    size: Theme.of(context).textTheme.displayMedium?.fontSize,
                    color: Colors.greenAccent,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: palette
                      .sublist(0, gameState.settings.colorsAmount)
                      .asMap()
                      .map(
                        (colorIndex, color) => MapEntry(
                          colorIndex,
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed:
                                    (gameState.fillingPointColor !=
                                        colorIndex)
                                    ? () {
                                        HapticFeedback.mediumImpact();
                                        context
                                            .read<GameStateCubit>()
                                            .makeMove(colorIndex);
                                      }
                                    : null,
                                style: ButtonStyle(
                                  padding:
                                      WidgetStateProperty.all<EdgeInsets>(
                                        EdgeInsets.zero,
                                      ),
                                  mouseCursor:
                                      WidgetStateProperty.resolveWith<
                                        MouseCursor?
                                      >((Set<WidgetState> states) {
                                        if (states.contains(
                                          WidgetState.disabled,
                                        )) {
                                          return SystemMouseCursors.basic;
                                        }
                                        return null;
                                      }),
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith<Color>((
                                        Set<WidgetState> states,
                                      ) {
                                        if (states.contains(
                                          WidgetState.disabled,
                                        )) {
                                          return color.withAlpha(0);
                                        }
                                        return color;
                                      }),
                                  shape:
                                      WidgetStateProperty.resolveWith<
                                        OutlinedBorder
                                      >((Set<WidgetState> states) {
                                        if (states.contains(
                                          WidgetState.disabled,
                                        )) {
                                          return RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: color,
                                              width: 8,
                                            ),
                                            borderRadius:
                                                BorderRadiusGeometry.all(
                                                  Radius.circular(8.0),
                                                ),
                                          );
                                        }
                                        return RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.all(
                                                Radius.circular(8.0),
                                              ),
                                        );
                                      }),
                                ),
                                child: SizedBox(
                                  width: Theme.of(context).buttonTheme.minWidth,
                                  height: Theme.of(context).buttonTheme.height * 2,
                                  child: Center(
                                    child: settingsState.colorAccessabilityMode
                                        ? FittedBox(
                                          child: CellAccessabilityMark(
                                              colorIndex: colorIndex,
                                              backgroundColor: (gameState.fillingPointColor != colorIndex) ?
                                                  palette[colorIndex] : null,
                                              fontSize: 50,
                                            ),
                                        )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .entries
                      .where(
                        (element) => gameState.gameGrid.uniqueValuesOnGrid
                            .contains(element.key),
                      )
                      .map((e) => e.value)
                      .slices(colorsPerRow)
                      .map(
                        (row) => Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: row,
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

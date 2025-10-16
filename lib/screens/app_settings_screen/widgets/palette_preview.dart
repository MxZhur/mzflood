import 'package:flutter/material.dart';
import 'package:mzflood/constants/game_grid_palette.dart';
import 'package:mzflood/l10n/app_localizations.dart';
import 'package:mzflood/screens/game_screen/widgets/cell_accessability_mark.dart';

class PalettePreview extends StatelessWidget {
  const PalettePreview({
    super.key,
    required this.palette,
    this.colorAccessabilityMode = false,
  });

  final Palette palette;
  final bool colorAccessabilityMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Text(
          AppLocalizations.of(context)!.titlePalettePreview,
          style: TextTheme.of(context).labelMedium,
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            Orientation orientation = MediaQuery.orientationOf(context);

            return Row(
              children: [
                if (orientation == Orientation.landscape) Spacer(),

                Flexible(
                  flex: 4,
                  child: Row(
                    spacing: 4,
                    children: List<Widget>.generate(
                      palette.length,
                      (colorIndex) => Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: palette[colorIndex],
                            borderRadius: BorderRadius.only(
                              topLeft: colorIndex == 0
                                  ? Radius.circular(12)
                                  : Radius.zero,
                              bottomLeft: colorIndex == 0
                                  ? Radius.circular(12)
                                  : Radius.zero,
                              topRight: colorIndex == palette.length - 1
                                  ? Radius.circular(12)
                                  : Radius.zero,
                              bottomRight: colorIndex == palette.length - 1
                                  ? Radius.circular(12)
                                  : Radius.zero,
                            ),
                          ),
                          height: 50,
                          child: FittedBox(
                            child: colorAccessabilityMode
                                ? CellAccessabilityMark(
                                    colorIndex: colorIndex,
                                    backgroundColor: palette[colorIndex],
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                if (orientation == Orientation.landscape) Spacer(),
              ],
            );
          },
        ),
      ],
    );
  }
}

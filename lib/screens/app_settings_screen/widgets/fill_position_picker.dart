import 'package:flutter/material.dart';
import 'package:mzflood/domain/game_settings.dart';
import 'package:mzflood/l10n/app_localizations.dart';

class FillPositionPicker extends StatelessWidget {
  final StartingPositionType currentValue;
  final void Function(StartingPositionType newValue) onChanged;

  const FillPositionPicker({
    super.key,
    required this.currentValue,
    required this.onChanged,
  });

  static const double cellSpacing = 4;

  @override
  Widget build(BuildContext context) {
    List<List<StartingPositionType>> typeGrid = [
      [
        StartingPositionType.topLeft,
        StartingPositionType.topCenter,
        StartingPositionType.topRight,
      ],
      [
        StartingPositionType.middleLeft,
        StartingPositionType.center,
        StartingPositionType.middleRight,
      ],
      [
        StartingPositionType.bottomLeft,
        StartingPositionType.bottomCenter,
        StartingPositionType.bottomRight,
      ],
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: cellSpacing * 2,
      children: [
        Column(
          spacing: cellSpacing,
          children: typeGrid
              .map<Widget>(
                (row) => Row(
                  spacing: cellSpacing,
                  children: row
                      .map<Widget>(
                        (tileType) => FillPositionPickerTile(
                          tileType: tileType,
                          isSelected: currentValue == tileType,
                          onPressed: onChanged,
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),
        Column(
          spacing: 2,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FillPositionPickerTile(
              tileType: StartingPositionType.random,
              isSelected: currentValue == StartingPositionType.random,
              onPressed: onChanged,
            ),
            Text(
              AppLocalizations.of(context)!.settingsStartingPositionRandom,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
          //  settingsStartingPositionRandom
        ),
      ],
    );
  }
}

class FillPositionPickerTile extends StatelessWidget {
  final StartingPositionType tileType;
  final bool isSelected;
  final void Function(StartingPositionType tileType) onPressed;

  static const double cellWidth = 50;
  static const Radius cellBorderRadius = Radius.circular(16);

  const FillPositionPickerTile({
    super.key,
    required this.tileType,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;

    switch (tileType) {
      case StartingPositionType.topLeft:
        borderRadius = BorderRadius.only(topLeft: cellBorderRadius);
      case StartingPositionType.topRight:
        borderRadius = BorderRadius.only(topRight: cellBorderRadius);
        break;
      case StartingPositionType.bottomRight:
        borderRadius = BorderRadius.only(bottomRight: cellBorderRadius);
        break;
      case StartingPositionType.bottomLeft:
        borderRadius = BorderRadius.only(bottomLeft: cellBorderRadius);
        break;
      case StartingPositionType.random:
        borderRadius = BorderRadius.all(cellBorderRadius);
        break;
      default:
        borderRadius = BorderRadius.zero;
        break;
    }

    return Material(
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.onPrimary,
      borderRadius: borderRadius,
      elevation: 5,
      child: InkWell(
        child: SizedBox(
          height: cellWidth,
          width: cellWidth,
          child: isSelected
              ? Center(child: Icon(Icons.format_color_fill, size: cellWidth * 0.6))
              : null,
        ),
        onTap: () => onPressed(tileType),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '/domain/game_settings.dart';
import '/l10n/app_localizations.dart';

class FillPositionPicker extends StatelessWidget {
  static const double cellSpacing = 4;
  static const typeGrid = <List<StartingPositionType>>[
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

  final StartingPositionType currentValue;

  final void Function(StartingPositionType newValue) onChanged;

  const FillPositionPicker({
    super.key,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: cellSpacing * 2,
      children: [
        Column(
          spacing: cellSpacing,
          children: [
            for (final row in typeGrid)
              Row(
                spacing: cellSpacing,
                children: [
                  for (final tileType in row)
                    FillPositionPickerButton(
                      tileType: tileType,
                      isSelected: currentValue == tileType,
                      onPressed: onChanged,
                    ),
                ],
              ),
          ],
        ),
        Column(
          spacing: 2,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FillPositionPickerButton(
              tileType: StartingPositionType.random,
              isSelected: currentValue == StartingPositionType.random,
              onPressed: onChanged,
            ),
            Text(
              i18n.settingsStartingPositionRandom,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
    );
  }
}

class FillPositionPickerButton extends StatelessWidget {
  static const double cellWidth = 50;
  static const Radius cellBorderRadius = Radius.circular(16);

  final StartingPositionType tileType;
  final bool isSelected;
  final void Function(StartingPositionType tileType) onPressed;

  const FillPositionPickerButton({
    super.key,
    required this.tileType,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = switch (tileType) {
      StartingPositionType.topLeft => const BorderRadius.only(
        topLeft: cellBorderRadius,
      ),
      StartingPositionType.topRight => const BorderRadius.only(
        topRight: cellBorderRadius,
      ),
      StartingPositionType.bottomRight => const BorderRadius.only(
        bottomRight: cellBorderRadius,
      ),
      StartingPositionType.bottomLeft => const BorderRadius.only(
        bottomLeft: cellBorderRadius,
      ),
      StartingPositionType.random => const BorderRadius.all(cellBorderRadius),
      _ => BorderRadius.zero,
    };

    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isSelected ? colorScheme.primaryContainer : colorScheme.onPrimary,
      borderRadius: borderRadius,
      elevation: 5,
      type: MaterialType.button,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isSelected ? null : () => onPressed(tileType),
        child: Container(
          height: cellWidth,
          width: cellWidth,
          alignment: Alignment.center,
          child: isSelected
              ? const Icon(Icons.format_color_fill, size: cellWidth * 0.6)
              : null,
        ),
      ),
    );
  }
}

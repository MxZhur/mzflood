import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '/bloc/app_settings/app_settings_state.dart';
import '/constants/animation.dart';
import '/constants/palette.dart';
import '/domain/game_grid.dart';
import '/extensions/palette_extension.dart';
import '/utils/range_functions.dart';
import '/utils/vector.dart';

class GameSettings extends Equatable {
  static const int minWidth = 8;
  static const int maxWidth = 20;
  static const int defaultWidth = 12;

  static const int minHeight = 8;
  static const int maxHeight = 20;
  static const int defaultHeight = 12;

  static const int minColorsAmount = 3;
  static const int maxColorsAmount = 10;
  static const int defaultColorsAmount = 4;

  static const StartingPositionType defaultStartingPositionType =
      StartingPositionType.topLeft;

  late final int gridWidth;
  late final int gridHeight;
  late final int colorsAmount;
  late final int seed;
  late final GridPoint fillSourcePoint;
  late final int fillDelay;
  final StartingPositionType startingPositionType;

  late final bool monochromeMode;
  late final Color? monochromeSeedColor;
  late final double saturationShift;
  late final double lowestBrightness;
  late final double highestBrightness;

  GameSettings({
    int gridWidth = defaultWidth,
    int gridHeight = defaultHeight,
    int colorsAmount = defaultColorsAmount,
    int? seed,
    int? fillDelay,
    this.startingPositionType = defaultStartingPositionType,
    this.monochromeMode = false,
    this.monochromeSeedColor,
    double saturationShift = 0,
    double lowestBrightness = 0,
    double highestBrightness = 1,
  }) {
    this.gridWidth = gridWidth.clamp(minWidth, maxWidth);
    this.gridHeight = gridHeight.clamp(minHeight, maxHeight);
    this.colorsAmount = colorsAmount.clamp(minColorsAmount, maxColorsAmount);

    this.saturationShift = saturationShift.clamp(-1, 1);
    this.lowestBrightness = lowestBrightness.clamp(0, 1);
    this.highestBrightness = highestBrightness.clamp(0, 1);

    this.fillDelay = max(fillDelay ?? 0, 0);

    this.seed =
        seed ?? Random(DateTime.now().millisecondsSinceEpoch).nextInt(1 << 32);

    fillSourcePoint = getStartingPositionByType(startingPositionType);
  }

  factory GameSettings.fromAppSettings(AppSettingsState appSettings) =>
      GameSettings(
        gridWidth: appSettings.defaultWidth,
        gridHeight: appSettings.defaultHeight,
        colorsAmount: appSettings.defaultColorsAmount,
        fillDelay: appSettings.fillDelay,
        startingPositionType: appSettings.startingPositionType,
        monochromeMode: appSettings.monochromeMode,
        monochromeSeedColor: appSettings.monochromeSeedColor,
        saturationShift: appSettings.saturationShift,
        lowestBrightness: appSettings.lowestBrightness,
        highestBrightness: appSettings.highestBrightness,
      );

  Duration get cellAnimationDuration => fillDelay == 0
      ? Durations.medium2
      : Duration(
          milliseconds:
              ((frameDurationMilliseconds * fillDelay) +
                      (frameDurationMilliseconds * 5))
                  .clamp(
                    frameDurationMilliseconds * 5,
                    frameDurationMilliseconds * 45,
                  ),
        );

  Duration get fillDelayDuration => frameDuration * fillDelay;

  GridPoint get gridCenterPoint => (x: gridWidth ~/ 2, y: gridHeight ~/ 2);
  Vector2 get gridCenterVector =>
      Vector2(x: gridWidth ~/ 2, y: gridHeight ~/ 2);

  Vector2 get fillSourcePointVector =>
      Vector2(x: fillSourcePoint.x, y: fillSourcePoint.y);

  int get maxMoves =>
      (sqrt(gridWidth * gridHeight) *
              colorsAmount /
              mapRange(
                (fillSourcePointVector - gridCenterVector).length,
                0,
                max(gridWidth.toDouble(), gridHeight.toDouble()),
                3.6,
                2.7,
              ))
          .ceil();

  @override
  List<Object?> get props => [
    gridWidth,
    gridHeight,
    colorsAmount,
    seed,
    fillSourcePoint,
    fillDelay,
    startingPositionType,
    monochromeMode,
    monochromeSeedColor,
    saturationShift,
    lowestBrightness,
    highestBrightness,
  ];

  int get totalCells => gridWidth * gridHeight;

  GameSettings copyWith({
    int? gridWidth,
    int? gridHeight,
    int? colorsAmount,
    StartingPositionType? startingPositionType,
    int? Function()? seed,
    int? fillDelay,
    bool? monochromeMode,
    Color? Function()? monochromeSeedColor,
    double? saturationShift,
    double? lowestBrightness,
    double? highestBrightness,
  }) => GameSettings(
    gridWidth: gridWidth ?? this.gridWidth,
    gridHeight: gridHeight ?? this.gridHeight,
    colorsAmount: colorsAmount ?? this.colorsAmount,
    seed: seed != null ? seed() : this.seed,
    startingPositionType: startingPositionType ?? this.startingPositionType,
    fillDelay: fillDelay ?? this.fillDelay,
    monochromeMode: monochromeMode ?? this.monochromeMode,
    monochromeSeedColor: monochromeSeedColor != null
        ? monochromeSeedColor()
        : this.monochromeSeedColor,
    saturationShift: saturationShift ?? this.saturationShift,
    lowestBrightness: lowestBrightness ?? this.lowestBrightness,
    highestBrightness: highestBrightness ?? this.highestBrightness,
  );

  GameGrid<int> generateGrid() {
    final randomGenerator = Random(seed);

    return GameGrid<int>.generate(
      width: gridWidth,
      height: gridHeight,
      valueGenerator: (_) => randomGenerator.nextInt(colorsAmount),
    );
  }

  Palette generatePalette() => MappablePalette.generatePalette(
    colorsAmount: colorsAmount,
    monochromeMode: monochromeMode,
    monochromeSeedColor: monochromeSeedColor,
    saturationShift: saturationShift,
    lowestBrightness: lowestBrightness,
    highestBrightness: highestBrightness,
  );

  GridPoint getRandomPositionOnGrid() {
    final randomGenerator = Random(seed);

    return (
      x: randomGenerator.nextInt(gridWidth),
      y: randomGenerator.nextInt(gridHeight),
    );
  }

  GridPoint getStartingPositionByType(StartingPositionType type) {
    final centerX = gridWidth ~/ 2;
    final middleY = gridHeight ~/ 2;

    return switch (type) {
      StartingPositionType.topLeft => (x: 0, y: 0),
      StartingPositionType.topCenter => (x: centerX, y: 0),
      StartingPositionType.topRight => (x: gridWidth - 1, y: 0),
      StartingPositionType.middleRight => (x: gridWidth - 1, y: middleY),
      StartingPositionType.bottomRight => (x: gridWidth - 1, y: gridHeight - 1),
      StartingPositionType.bottomCenter => (x: centerX, y: gridHeight - 1),
      StartingPositionType.bottomLeft => (x: 0, y: gridHeight - 1),
      StartingPositionType.middleLeft => (x: 0, y: middleY),
      StartingPositionType.center => (x: centerX, y: middleY),
      StartingPositionType.random => getRandomPositionOnGrid(),
    };
  }

  GameSettings withNewAnimationSettings({int? fillDelay}) =>
      copyWith(fillDelay: fillDelay);

  GameSettings withNewAppSettings(AppSettingsState appSettings) => copyWith(
    seed: () => null,
    gridWidth: appSettings.defaultWidth,
    gridHeight: appSettings.defaultHeight,
    colorsAmount: appSettings.defaultColorsAmount,
    fillDelay: appSettings.fillDelay,
    startingPositionType: appSettings.startingPositionType,
    monochromeMode: appSettings.monochromeMode,
    monochromeSeedColor: () => appSettings.monochromeSeedColor,
    saturationShift: appSettings.saturationShift,
    lowestBrightness: appSettings.lowestBrightness,
    highestBrightness: appSettings.highestBrightness,
  );

  GameSettings withNewPaletteSettings({
    bool? monochromeMode,
    Color? Function()? monochromeSeedColor,
    double? saturationShift,
    double? lowestBrightness,
    double? highestBrightness,
  }) => copyWith(
    monochromeMode: monochromeMode,
    monochromeSeedColor: monochromeSeedColor,
    saturationShift: saturationShift,
    lowestBrightness: lowestBrightness,
    highestBrightness: highestBrightness,
  );
}

enum StartingPositionType {
  topLeft,
  topCenter,
  topRight,
  middleRight,
  bottomRight,
  bottomCenter,
  bottomLeft,
  middleLeft,
  center,
  random,
}

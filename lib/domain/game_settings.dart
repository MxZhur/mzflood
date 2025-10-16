import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:mzflood/bloc/app_settings/app_settings_bloc.dart';
import 'package:mzflood/constants/game_grid_palette.dart';
import 'package:mzflood/domain/game_grid.dart';

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

class GameSettings extends Equatable {
  static const int minWidth = 8;
  static const int maxWidth = 20;
  static const int defaultWidth = 12;

  static const int minHeight = 8;
  static const int maxHeight = 20;
  static const int defaultHeight = 12;

  static const int minColors = 3;
  static const int maxColors = 10;
  static const int defaultColors = 4;

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

  int get maxMoves =>
      (sqrt(gridWidth * gridHeight) * colorsAmount / 2.75).ceil();

  int get totalCells => gridWidth * gridHeight;

  GameSettings({
    int gridWidth = defaultWidth,
    int gridHeight = defaultHeight,
    int colorsAmount = defaultColors,
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
    this.colorsAmount = colorsAmount.clamp(minColors, maxColors);

    this.saturationShift = saturationShift.clamp(-1, 1);
    this.lowestBrightness = lowestBrightness.clamp(0, 1);
    this.highestBrightness = highestBrightness.clamp(0, 1);

    this.fillDelay = fillDelay ?? 0;

    this.seed =
        seed ?? Random(DateTime.now().millisecondsSinceEpoch).nextInt(1 << 32);

    fillSourcePoint = getStartingPositionByType(startingPositionType);
  }

  GameGrid<int> getNewGrid() {
    final Random randomGenerator = Random(seed);

    return GameGrid<int>.generate(
      width: gridWidth,
      height: gridHeight,
      valueGenerator: (_) => randomGenerator.nextInt(colorsAmount),
    );
  }

  GridPoint getRandomPositionOnGrid() {
    final Random randomGenerator = Random(seed);

    return (
      x: randomGenerator.nextInt(gridWidth),
      y: randomGenerator.nextInt(gridHeight),
    );
  }

  GridPoint getStartingPositionByType(StartingPositionType type) {
    int centerX = gridWidth ~/ 2;
    int middleY = gridHeight ~/ 2;

    switch (type) {
      case StartingPositionType.topLeft:
        return (x: 0, y: 0);
      case StartingPositionType.topCenter:
        return (x: centerX, y: 0);
      case StartingPositionType.topRight:
        return (x: gridWidth - 1, y: 0);
      case StartingPositionType.middleRight:
        return (x: gridWidth - 1, y: middleY);
      case StartingPositionType.bottomRight:
        return (x: gridWidth - 1, y: gridHeight - 1);
      case StartingPositionType.bottomCenter:
        return (x: centerX, y: gridHeight - 1);
      case StartingPositionType.bottomLeft:
        return (x: 0, y: gridHeight - 1);
      case StartingPositionType.middleLeft:
        return (x: 0, y: middleY);
      case StartingPositionType.center:
        return (x: centerX, y: middleY);
      case StartingPositionType.random:
        return getRandomPositionOnGrid();
    }
  }

  Palette getPalette() {
    return generatePalette(
      colorsAmount: colorsAmount,
      monochromeMode: monochromeMode,
      monochromeSeedColor: monochromeSeedColor,
      saturationShift: saturationShift,
      lowestBrightness: lowestBrightness,
      highestBrightness: highestBrightness,
    );
  }

  @override
  List<Object?> get props {
    return [
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
  }

  factory GameSettings.fromAppSettings(AppSettingsState appSettings) =>
      GameSettings(
        gridWidth: appSettings.defaultWidth,
        gridHeight: appSettings.defaultHeight,
        colorsAmount: appSettings.defaultColors,
        fillDelay: appSettings.fillDelay,
        startingPositionType: appSettings.startingPositionType,
        monochromeMode: appSettings.monochromeMode,
        monochromeSeedColor: appSettings.monochromeSeedColor,
        saturationShift: appSettings.saturationShift,
        lowestBrightness: appSettings.lowestBrightness,
        highestBrightness: appSettings.highestBrightness,
      );

  GameSettings withNewAppSettings(AppSettingsState appSettings) => copyWith(
    seed: () => null,
    gridWidth: appSettings.defaultWidth,
    gridHeight: appSettings.defaultHeight,
    colorsAmount: appSettings.defaultColors,
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
    ValueGetter<Color?>? monochromeSeedColor,
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

  GameSettings copyWith({
    int? gridWidth,
    int? gridHeight,
    int? colorsAmount,
    StartingPositionType? startingPositionType,
    ValueGetter<int?>? seed,
    int? fillDelay,
    bool? monochromeMode,
    ValueGetter<Color?>? monochromeSeedColor,
    double? saturationShift,
    double? lowestBrightness,
    double? highestBrightness,
  }) {
    return GameSettings(
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
  }
}

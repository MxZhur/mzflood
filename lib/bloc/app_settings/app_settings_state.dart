import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '/constants/palette.dart';
import '/domain/game_settings.dart';
import '/extensions/palette_extension.dart';

class AppSettingsState extends Equatable {
  final ThemeMode brightnessMode;

  final String? language;
  final bool isColorPanelVisible;
  final int defaultWidth;
  final int defaultHeight;
  final int defaultColorsAmount;
  final bool colorAccessabilityMode;
  final int fillDelay;
  final StartingPositionType startingPositionType;
  final bool monochromeMode;

  final Color? monochromeSeedColor;
  final double saturationShift;
  final double lowestBrightness;
  final double highestBrightness;

  const AppSettingsState({
    this.brightnessMode = ThemeMode.system,
    this.language,
    this.isColorPanelVisible = true,
    this.defaultWidth = GameSettings.defaultWidth,
    this.defaultHeight = GameSettings.defaultHeight,
    this.defaultColorsAmount = GameSettings.defaultColorsAmount,
    this.colorAccessabilityMode = false,
    this.fillDelay = 1,
    this.startingPositionType = GameSettings.defaultStartingPositionType,

    this.monochromeMode = false,
    this.monochromeSeedColor,
    this.saturationShift = 0,
    this.lowestBrightness = 0,
    this.highestBrightness = 1,
  });

  @override
  List<Object?> get props => [
    brightnessMode,
    language,
    isColorPanelVisible,
    defaultWidth,
    defaultHeight,
    defaultColorsAmount,
    colorAccessabilityMode,
    fillDelay,
    startingPositionType,
    monochromeMode,
    monochromeSeedColor,
    saturationShift,
    lowestBrightness,
    highestBrightness,
  ];

  AppSettingsState copyWith({
    ThemeMode? brightnessMode,
    String? Function()? language,
    bool? isColorPanelVisible,
    int? defaultWidth,
    int? defaultHeight,
    int? defaultColorsAmount,
    bool? colorAccessabilityMode,
    int? fillDelay,
    StartingPositionType? startingPositionType,
    bool? monochromeMode,
    Color? Function()? monochromeSeedColor,
    double? saturationShift,
    double? lowestBrightness,
    double? highestBrightness,
  }) => AppSettingsState(
    brightnessMode: brightnessMode ?? this.brightnessMode,
    language: language != null ? language() : this.language,
    isColorPanelVisible: isColorPanelVisible ?? this.isColorPanelVisible,
    defaultWidth: defaultWidth ?? this.defaultWidth,
    defaultHeight: defaultHeight ?? this.defaultHeight,
    defaultColorsAmount: defaultColorsAmount ?? this.defaultColorsAmount,
    colorAccessabilityMode:
        colorAccessabilityMode ?? this.colorAccessabilityMode,
    fillDelay: fillDelay ?? this.fillDelay,
    startingPositionType: startingPositionType ?? this.startingPositionType,
    monochromeMode: monochromeMode ?? this.monochromeMode,
    monochromeSeedColor: monochromeSeedColor != null
        ? monochromeSeedColor()
        : this.monochromeSeedColor,
    saturationShift: saturationShift ?? this.saturationShift,
    lowestBrightness: lowestBrightness ?? this.lowestBrightness,
    highestBrightness: highestBrightness ?? this.highestBrightness,
  );

  Palette generatePalette() => MappablePalette.generatePalette(
    colorsAmount: defaultColorsAmount,
    monochromeMode: monochromeMode,
    monochromeSeedColor: monochromeSeedColor,
    saturationShift: saturationShift,
    lowestBrightness: lowestBrightness,
    highestBrightness: highestBrightness,
  );
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mzflood/constants/game_grid_palette.dart';

import 'package:mzflood/domain/game_settings.dart';

class AppSettingsCubit extends HydratedCubit<AppSettingsState> {
  AppSettingsCubit() : super(AppSettingsState());

  void updateSettings(AppSettingsState newSettings) {
    emit(newSettings);
  }

  void resetToDefault() {
    emit(AppSettingsState());
  }

  @override
  AppSettingsState fromJson(Map<String, dynamic> json) {
    AppSettingsState defaultSettings = AppSettingsState();

    return AppSettingsState(
      brightnessMode:
          ThemeMode.values.asNameMap()[json['brightnessMode']] ??
          defaultSettings.brightnessMode,
      language: json['language'] ?? defaultSettings.language,
      showColorPanel: json['showColorPanel'] ?? defaultSettings.showColorPanel,
      defaultWidth: json['defaultWidth'] ?? defaultSettings.defaultWidth,
      defaultHeight: json['defaultHeight'] ?? defaultSettings.defaultHeight,
      defaultColors: json['defaultColors'] ?? defaultSettings.defaultColors,
      colorAccessabilityMode:
          json['colorAccessabilityMode'] ??
          defaultSettings.colorAccessabilityMode,
      fillDelay: json['fillDelay'] ?? defaultSettings.fillDelay,
      startingPositionType:
          StartingPositionType.values
              .asNameMap()[json['startingPositionType']] ??
          defaultSettings.startingPositionType,

      monochromeMode: json['monochromeMode'] ?? defaultSettings.monochromeMode,
      monochromeSeedColor: json['monochromeSeedColor'] != null
          ? Color(int.parse(json['monochromeSeedColor'], radix: 16))
          : defaultSettings.monochromeSeedColor,
      saturationShift:
          json['saturationShift'] ?? defaultSettings.saturationShift,
      lowestBrightness:
          json['lowestBrightness'] ?? defaultSettings.lowestBrightness,
      highestBrightness:
          json['highestBrightness'] ?? defaultSettings.highestBrightness,
    );
  }

  @override
  Map<String, dynamic> toJson(AppSettingsState state) {
    return <String, dynamic>{
      'brightnessMode': state.brightnessMode.name,
      'language': state.language,
      'showColorPanel': state.showColorPanel,
      'defaultWidth': state.defaultWidth,
      'defaultHeight': state.defaultHeight,
      'defaultColors': state.defaultColors,
      'colorAccessabilityMode': state.colorAccessabilityMode,
      'fillDelay': state.fillDelay,
      'startingPositionType': state.startingPositionType.name,
      'monochromeMode': state.monochromeMode,
      'monochromeSeedColor': state.monochromeSeedColor
          ?.toARGB32()
          .toRadixString(16),
      'saturationShift': state.saturationShift,
      'lowestBrightness': state.lowestBrightness,
      'highestBrightness': state.highestBrightness,
    };
  }
}

class AppSettingsState extends Equatable {
  const AppSettingsState({
    this.brightnessMode = ThemeMode.system,
    this.language,
    this.showColorPanel = true,
    this.defaultWidth = GameSettings.defaultWidth,
    this.defaultHeight = GameSettings.defaultHeight,
    this.defaultColors = GameSettings.defaultColors,
    this.colorAccessabilityMode = false,
    this.fillDelay = 1,
    this.startingPositionType = GameSettings.defaultStartingPositionType,

    this.monochromeMode = false,
    this.monochromeSeedColor,
    this.saturationShift = 0,
    this.lowestBrightness = 0,
    this.highestBrightness = 1,
  });

  final ThemeMode brightnessMode;
  final String? language;
  final bool showColorPanel;
  final int defaultWidth;
  final int defaultHeight;
  final int defaultColors;
  final bool colorAccessabilityMode;
  final int fillDelay;
  final StartingPositionType startingPositionType;

  final bool monochromeMode;
  final Color? monochromeSeedColor;
  final double saturationShift;
  final double lowestBrightness;
  final double highestBrightness;

  Palette getPalette() => generatePalette(
    colorsAmount: defaultColors,
    monochromeMode: monochromeMode,
    monochromeSeedColor: monochromeSeedColor,
    saturationShift: saturationShift,
    lowestBrightness: lowestBrightness,
    highestBrightness: highestBrightness,
  );

  AppSettingsState copyWith({
    ThemeMode? brightnessMode,
    ValueGetter<String?>? language,
    bool? showColorPanel,
    int? defaultWidth,
    int? defaultHeight,
    int? defaultColors,
    bool? colorAccessabilityMode,
    int? fillDelay,
    StartingPositionType? startingPositionType,
    bool? monochromeMode,
    ValueGetter<Color?>? monochromeSeedColor,
    double? saturationShift,
    double? lowestBrightness,
    double? highestBrightness,
  }) {
    return AppSettingsState(
      brightnessMode: brightnessMode ?? this.brightnessMode,
      language: language != null ? language() : this.language,
      showColorPanel: showColorPanel ?? this.showColorPanel,
      defaultWidth: defaultWidth ?? this.defaultWidth,
      defaultHeight: defaultHeight ?? this.defaultHeight,
      defaultColors: defaultColors ?? this.defaultColors,
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
  }

  @override
  List<Object?> get props {
    return [
      brightnessMode,
      language,
      showColorPanel,
      defaultWidth,
      defaultHeight,
      defaultColors,
      colorAccessabilityMode,
      fillDelay,
      startingPositionType,
      monochromeMode,
      monochromeSeedColor,
      saturationShift,
      lowestBrightness,
      highestBrightness,
    ];
  }
}

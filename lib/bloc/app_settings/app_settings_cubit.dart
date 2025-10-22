import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '/domain/game_settings.dart';
import 'app_settings_state.dart';

class AppSettingsCubit extends HydratedCubit<AppSettingsState> {
  AppSettingsCubit() : super(AppSettingsState());

  @override
  AppSettingsState fromJson(Map<String, dynamic> json) {
    const defaultSettings = AppSettingsState();

    return AppSettingsState(
      brightnessMode:
          ThemeMode.values.asNameMap()[json['brightnessMode']] ??
          defaultSettings.brightnessMode,
      language: json['language'] ?? defaultSettings.language,
      isColorPanelVisible:
          json['isColorPanelVisible'] ?? defaultSettings.isColorPanelVisible,
      defaultWidth: json['defaultWidth'] ?? defaultSettings.defaultWidth,
      defaultHeight: json['defaultHeight'] ?? defaultSettings.defaultHeight,
      defaultColorsAmount:
          json['defaultColorsAmount'] ?? defaultSettings.defaultColorsAmount,
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

  void resetToDefault() {
    emit(AppSettingsState());
  }

  @override
  Map<String, dynamic> toJson(AppSettingsState state) => <String, dynamic>{
    'brightnessMode': state.brightnessMode.name,
    'language': state.language,
    'isColorPanelVisible': state.isColorPanelVisible,
    'defaultWidth': state.defaultWidth,
    'defaultHeight': state.defaultHeight,
    'defaultColorsAmount': state.defaultColorsAmount,
    'colorAccessabilityMode': state.colorAccessabilityMode,
    'fillDelay': state.fillDelay,
    'startingPositionType': state.startingPositionType.name,
    'monochromeMode': state.monochromeMode,
    'monochromeSeedColor': state.monochromeSeedColor?.toARGB32().toRadixString(
      16,
    ),
    'saturationShift': state.saturationShift,
    'lowestBrightness': state.lowestBrightness,
    'highestBrightness': state.highestBrightness,
  };

  void updateSettings(AppSettingsState newSettings) {
    emit(newSettings);
  }
}

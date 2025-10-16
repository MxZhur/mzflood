import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mzflood/bloc/app_settings/app_settings_bloc.dart';
import 'package:mzflood/bloc/app_settings/game_state_bloc.dart';
import 'package:mzflood/constants/game_grid_palette.dart';
import 'package:mzflood/domain/game_settings.dart';
import 'package:mzflood/l10n/app_localizations.dart';
import 'package:mzflood/l10n/language_names.dart';
import 'package:mzflood/screens/app_settings_screen/widgets/about_app_tile.dart';
import 'package:mzflood/screens/app_settings_screen/widgets/app_setting_item.dart';
import 'package:mzflood/screens/app_settings_screen/widgets/color_picker_button.dart';
import 'package:mzflood/screens/app_settings_screen/widgets/deferred_slider.dart';
import 'package:mzflood/screens/app_settings_screen/widgets/fill_position_picker.dart';
import 'package:mzflood/screens/app_settings_screen/widgets/palette_preview.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.titleSettings),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(localizations.buttonResetSettings),
                  content: Text(localizations.messageWarningYouSure),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(localizations.no),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AppSettingsCubit>().resetToDefault();

                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              localizations.messageSettingsWereReset,
                            ),
                            duration: Duration(seconds: 1),
                          ),
                        );

                        Navigator.pop(context);
                      },
                      child: Text(localizations.yes),
                    ),
                  ],
                ),
              );
            },
            tooltip: localizations.buttonResetSettings,
            icon: Icon(Icons.settings_backup_restore),
          ),
        ],
      ),
      body: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, settingsState) {
          Palette palette = settingsState.getPalette();

          AppSettingsCubit appSettingsCubit = context.read<AppSettingsCubit>();
          GameStateCubit gameStateCubit = context.read<GameStateCubit>();

          return ListView(
            children: [
              buildSection(
                context,
                localizations.settingsSectionUserInterface,
                [
                  AppSettingItem<String>.dropDown(
                    icon: Icons.language,
                    title: localizations.settingsLanguage,
                    options: {
                      null: localizations.settingsLanguageSystem,
                      ...languageNames,
                    },
                    currentValue: settingsState.language,
                    onChanged: (value) {
                      appSettingsCubit.updateSettings(
                        settingsState.copyWith(language: () => value),
                      );
                    },
                  ),

                  AppSettingItem<ThemeMode>.dropDown(
                    icon: Icons.settings_brightness,
                    title: localizations.settingsThemeMode,
                    options: {
                      ThemeMode.system: localizations.settingsThemeModeSystem,
                      ThemeMode.light: localizations.settingsThemeModeLight,
                      ThemeMode.dark: localizations.settingsThemeModeDark,
                    },
                    currentValue: settingsState.brightnessMode,
                    onChanged: (value) {
                      appSettingsCubit.updateSettings(
                        settingsState.copyWith(brightnessMode: value),
                      );
                    },
                  ),
                  AppSettingItem<bool>.switcher(
                    icon: Icons.view_column,
                    title: localizations.settingsShowColorPanel,
                    subtitleWhenOn: Text(localizations.settingsShowColorPanelSubtitle),
                    subtitleWhenOff: Text(
                      localizations.settingsShowColorPanelSubtitle,
                    ),
                    currentValue: settingsState.showColorPanel,
                    onChanged: (value) {
                      appSettingsCubit.updateSettings(
                        settingsState.copyWith(showColorPanel: value),
                      );
                    },
                  ),
                  AppSettingItem<bool>.switcher(
                    icon: Icons.accessibility_new,
                    title: localizations.settingsColorAccessabilityMode,
                    currentValue: settingsState.colorAccessabilityMode,
                    onChanged: (value) {
                      appSettingsCubit.updateSettings(
                        settingsState.copyWith(colorAccessabilityMode: value),
                      );
                    },
                  ),
                ],
              ),
              buildSection(context, localizations.settingsSectionGame, [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning, color: Colors.white),
                      Flexible(
                        child: Text(
                          localizations.messageSettingsNewGameOnly,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                LayoutBuilder(
                  builder: (context, constraints) {
                    bool wideMode = constraints.maxWidth >= 500;

                    TextStyle? currentSliderValueStyle = Theme.of(
                      context,
                    ).textTheme.bodyLarge;

                    Widget currentValuesDisplay = Row(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Text(localizations.width)],
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Text(
                            '${settingsState.defaultWidth}\u00D7${settingsState.defaultHeight}',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [Text(localizations.height)],
                          ),
                        ),
                      ],
                    );
                    Widget widthSlider = Row(
                      spacing: 8,
                      children: [
                        if (!wideMode)
                          Container(
                            width:
                                (currentSliderValueStyle?.fontSize ?? 16) * 1.5,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              localizations.widthShort,
                              style: currentSliderValueStyle,
                            ),
                          ),
                        Expanded(
                          child: DeferredSlider(
                            sliderType: DeferredSliderType.singleValue,
                            currentValue: settingsState.defaultWidth.toDouble(),
                            min: GameSettings.minWidth.toDouble(),
                            max: GameSettings.maxWidth.toDouble(),
                            divisions:
                                GameSettings.maxWidth - GameSettings.minWidth,
                            onChangedValue: (newValue) {
                              appSettingsCubit.updateSettings(
                                settingsState.copyWith(
                                  defaultWidth: newValue.round(),
                                ),
                              );
                            },
                            labelLeft: GameSettings.minWidth.toString(),
                            labelRight: GameSettings.maxWidth.toString(),
                            showThumbLabel: true,
                            roundThumbLabelValue: true,
                          ),
                        ),
                      ],
                    );

                    Widget heightSlider = Row(
                      spacing: 8,
                      children: [
                        if (!wideMode)
                          Container(
                            width:
                                (currentSliderValueStyle?.fontSize ?? 16) * 1.5,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              localizations.heightShort,
                              style: currentSliderValueStyle,
                            ),
                          ),
                        Expanded(
                          child: DeferredSlider(
                            sliderType: DeferredSliderType.singleValue,
                            currentValue: settingsState.defaultHeight
                                .toDouble(),
                            min: GameSettings.minHeight.toDouble(),
                            max: GameSettings.maxHeight.toDouble(),
                            divisions:
                                GameSettings.maxHeight - GameSettings.minHeight,
                            onChangedValue: (newValue) {
                              appSettingsCubit.updateSettings(
                                settingsState.copyWith(
                                  defaultHeight: newValue.round(),
                                ),
                              );
                            },
                            labelLeft: GameSettings.minHeight.toString(),
                            labelRight: GameSettings.maxHeight.toString(),
                            showThumbLabel: true,
                            roundThumbLabelValue: true,
                          ),
                        ),
                      ],
                    );

                    Widget slidersCombined;

                    if (wideMode) {
                      slidersCombined = Row(
                        spacing: 8,
                        children: [
                          Expanded(child: widthSlider),
                          Expanded(child: heightSlider),
                        ],
                      );
                    } else {
                      slidersCombined = Column(
                        children: [widthSlider, heightSlider],
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Text(
                            localizations.settingsBoardSize,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          currentValuesDisplay,
                          slidersCombined,
                        ],
                      ),
                    );
                  },
                ),
                Divider(),
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool wideMode = constraints.maxWidth >= 500;

                    Widget colorsAmountSlider = Column(
                      children: [
                        Text(
                          localizations.settingsColorsAmount,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        DeferredSlider(
                          sliderType: DeferredSliderType.singleValue,
                          currentValue: settingsState.defaultColors.toDouble(),
                          min: GameSettings.minColors.toDouble(),
                          max: GameSettings.maxColors.toDouble(),
                          divisions:
                              GameSettings.maxColors - GameSettings.minColors,
                          onChangedValue: (newValue) {
                            appSettingsCubit.updateSettings(
                              settingsState.copyWith(
                                defaultColors: newValue.round(),
                              ),
                            );
                          },
                          labelLeft: GameSettings.minColors.toString(),
                          labelRight: GameSettings.maxColors.toString(),
                          showThumbLabel: true,
                          roundThumbLabelValue: true,
                        ),
                      ],
                    );

                    Widget fillDelaySlider = Column(
                      children: [
                        Text(
                          localizations.settingsFillSpeed,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        DeferredSlider(
                          sliderType: DeferredSliderType.singleValue,
                          currentValue: settingsState.fillDelay.toDouble(),
                          min: 0,
                          max: 5,
                          divisions: 5,
                          onChangedValue: (newValue) {
                            appSettingsCubit.updateSettings(
                              settingsState.copyWith(
                                fillDelay: newValue.round(),
                              ),
                            );
                          },
                          labelLeft: localizations.settingsFillSpeedFaster,
                          labelRight: localizations.settingsFillSpeedSlower,
                        ),
                      ],
                    );

                    if (wideMode) {
                      return Row(
                        spacing: 8,
                        children: [
                          Expanded(child: colorsAmountSlider),
                          Expanded(child: fillDelaySlider),
                        ],
                      );
                    } else {
                      return Column(
                        children: [colorsAmountSlider, fillDelaySlider],
                      );
                    }
                  },
                ),
                Divider(),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            localizations.settingsStartingPosition,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),

                          FillPositionPicker(
                            currentValue: settingsState.startingPositionType,
                            onChanged: (newValue) {
                              appSettingsCubit.updateSettings(
                                settingsState.copyWith(
                                  startingPositionType: newValue,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ]),
              buildSection(context, localizations.settingsSectionColorPalette, [
                LayoutBuilder(
                  builder: (context, constraints) {
                    Widget saturationSlider = DeferredSlider(
                      sliderType: DeferredSliderType.singleValue,
                      currentValue: settingsState.saturationShift,
                      min: -1,
                      max: 1,
                      divisions: 20,
                      onChangedValue: (newValue) {
                        appSettingsCubit.updateSettings(
                          settingsState.copyWith(saturationShift: newValue),
                        );

                        gameStateCubit.syncPaletteSettings(
                          saturationShift: newValue,
                        );
                      },
                      labelLeft:
                          localizations.settingsPaletteSaturationGrayscale,
                      labelRight:
                          localizations.settingsPaletteSaturationColorful,
                    );

                    Widget brightnessSlider = DeferredSlider(
                      sliderType: DeferredSliderType.valueRange,
                      currentValueRange: RangeValues(
                        settingsState.lowestBrightness,
                        settingsState.highestBrightness,
                      ),
                      min: 0,
                      max: 1,
                      divisions: 20,
                      onChangedRange: (newValue) {
                        appSettingsCubit.updateSettings(
                          settingsState.copyWith(
                            lowestBrightness: newValue.start,
                            highestBrightness: newValue.end,
                          ),
                        );
                        gameStateCubit.syncPaletteSettings(
                          lowestBrightness: newValue.start,
                          highestBrightness: newValue.end,
                        );
                      },
                      labelLeft: localizations.settingsBrightnessContrastDarker,
                      labelRight:
                          localizations.settingsBrightnessContrastLighter,
                    );

                    double screenWidth = MediaQuery.sizeOf(context).width;

                    if (screenWidth >= 700) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          spacing: 24,
                          children: [
                            Flexible(child: saturationSlider),
                            Flexible(child: brightnessSlider),
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [saturationSlider, brightnessSlider],
                        ),
                      );
                    }
                  },
                ),

                AppSettingItem<bool>.switcher(
                  icon: Icons.monochrome_photos,
                  title: localizations.settingsMonochromeMode,
                  currentValue: settingsState.monochromeMode,
                  onChanged: (value) {
                    appSettingsCubit.updateSettings(
                      settingsState.copyWith(monochromeMode: value),
                    );

                    gameStateCubit.syncPaletteSettings(monochromeMode: value);
                  },
                ),

                AppSettingItem<bool>.custom(
                  icon: Icons.colorize,
                  title: localizations.settingsMonochromeSeedColor,
                  enabled: settingsState.monochromeMode,
                  control: ColorPickerButton(
                    currentValue:
                        settingsState.monochromeSeedColor ??
                        defaultMonochromeColor,
                    defaultValue: defaultMonochromeColor,
                    enabled: settingsState.monochromeMode,
                    enableAlpha: false,
                    dialogTitle: localizations.settingsMonochromeSeedColor,
                    pickerType: ColorPickerButtonType.block,
                    onChanged: (newValue) {
                      appSettingsCubit.updateSettings(
                        settingsState.copyWith(
                          monochromeSeedColor: () => newValue,
                        ),
                      );

                      gameStateCubit.syncPaletteSettings(
                        monochromeSeedColor: () => newValue,
                      );
                    },
                  ),
                ),
                Divider(),
                PalettePreview(
                  palette: palette,
                  colorAccessabilityMode: settingsState.colorAccessabilityMode,
                ),
              ]),
              buildSection(context, localizations.settingsSectionInformation, [
                AboutAppTile(),
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget buildSection(
    BuildContext context,
    String sectionTitle,
    List<Widget> children,
  ) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [buildSectionHeader(context, sectionTitle), ...children],
      ),
    ),
  );

  Widget buildSectionHeader(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

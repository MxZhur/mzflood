import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/app_settings/app_settings_cubit.dart';
import '/bloc/app_settings/app_settings_state.dart';
import '/bloc/game_state/game_state_cubit.dart';
import '/constants/measures.dart';
import '/constants/palette.dart';
import '/domain/game_settings.dart';
import '/l10n/app_localizations.dart';
import '/l10n/language_names.dart';
import '/screens/app_settings_screen/widgets/about_app_tile.dart';
import '/screens/app_settings_screen/widgets/color_picker_button.dart';
import '/screens/app_settings_screen/widgets/deferred_slider.dart';
import '/screens/app_settings_screen/widgets/fill_position_picker.dart';
import '/screens/app_settings_screen/widgets/palette_preview.dart';
import '/utils/notifications.dart';
import '/widgets/responsive_alternative.dart';
import '/widgets/responsive_layout_box.dart';
import 'widgets/app_setting_list_tile.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentSliderValueStyle = theme.textTheme.bodyLarge;

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.titleSettings),
        actions: [ResetAppSettingsButton()],
      ),
      body: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, settingsState) {
          final palette = settingsState.generatePalette();
          final appSettingsCubit = context.read<AppSettingsCubit>();
          final gameStateCubit = context.read<GameStateCubit>();

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: mediumScreenSizeBreakpoint.toDouble(),
              ),
              child: ListView(
                children: [
                  AppSettingsSection(
                    sectionTitle: i18n.settingsSectionUserInterface,
                    children: [
                      AppSettingListTile<String>.dropDown(
                        icon: Icons.language,
                        title: i18n.settingsLanguage,
                        options: {
                          null: i18n.settingsLanguageSystem,
                          ...languageNames,
                        },
                        currentValue: settingsState.language,
                        onChanged: (value) {
                          appSettingsCubit.updateSettings(
                            settingsState.copyWith(language: () => value),
                          );
                        },
                      ),

                      AppSettingListTile<ThemeMode>.dropDown(
                        icon: Icons.settings_brightness,
                        title: i18n.settingsThemeMode,
                        options: {
                          ThemeMode.system: i18n.settingsThemeModeSystem,
                          ThemeMode.light: i18n.settingsThemeModeLight,
                          ThemeMode.dark: i18n.settingsThemeModeDark,
                        },
                        currentValue: settingsState.brightnessMode,
                        onChanged: (value) {
                          appSettingsCubit.updateSettings(
                            settingsState.copyWith(brightnessMode: value),
                          );
                        },
                      ),
                      AppSettingListTile<bool>.switcher(
                        icon: Icons.view_column,
                        title: i18n.settingsIsColorPanelVisible,
                        subtitleWhenOn: Text(
                          i18n.settingsIsColorPanelVisibleSubtitle,
                        ),
                        subtitleWhenOff: Text(
                          i18n.settingsIsColorPanelVisibleSubtitle,
                        ),
                        currentValue: settingsState.isColorPanelVisible,
                        onChanged: (value) {
                          appSettingsCubit.updateSettings(
                            settingsState.copyWith(isColorPanelVisible: value),
                          );
                        },
                      ),
                      AppSettingListTile<bool>.switcher(
                        icon: Icons.accessibility_new,
                        title: i18n.settingsColorAccessabilityMode,
                        currentValue: settingsState.colorAccessabilityMode,
                        onChanged: (value) {
                          appSettingsCubit.updateSettings(
                            settingsState.copyWith(
                              colorAccessabilityMode: value,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  AppSettingsSection(
                    sectionTitle: i18n.settingsSectionGame,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red[700],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning, color: Colors.white),
                            Flexible(
                              child: Text(
                                i18n.messageSettingsNewGameOnly,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          children: [
                            Text(
                              i18n.settingsBoardSize,
                              style: theme.textTheme.labelLarge,
                            ),
                            Row(
                              spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [Text(i18n.width)],
                                  ),
                                ),
                                Expanded(
                                  flex: 0,
                                  child: Text(
                                    '${settingsState.defaultWidth}'
                                    '\u00D7'
                                    '${settingsState.defaultHeight}',
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [Text(i18n.height)],
                                  ),
                                ),
                              ],
                            ),
                            ResponsiveLayoutBox(
                              children: [
                                Row(
                                  spacing: 8,
                                  children: [
                                    ResponsiveAlternative(
                                      childSmall: Container(
                                        width:
                                            (currentSliderValueStyle
                                                    ?.fontSize ??
                                                16) *
                                            1.5,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          i18n.widthShort,
                                          style: currentSliderValueStyle,
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: DeferredSlider(
                                        sliderType:
                                            DeferredSliderType.singleValue,
                                        currentValue: settingsState.defaultWidth
                                            .toDouble(),
                                        min: GameSettings.minWidth.toDouble(),
                                        max: GameSettings.maxWidth.toDouble(),
                                        divisions:
                                            GameSettings.maxWidth -
                                            GameSettings.minWidth,
                                        onChangedValue: (newValue) {
                                          appSettingsCubit.updateSettings(
                                            settingsState.copyWith(
                                              defaultWidth: newValue.round(),
                                            ),
                                          );
                                        },
                                        labelLeft: GameSettings.minWidth
                                            .toString(),
                                        labelRight: GameSettings.maxWidth
                                            .toString(),
                                        showThumbLabel: true,
                                        roundThumbLabelValue: true,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 8,
                                  children: [
                                    ResponsiveAlternative(
                                      childSmall: Container(
                                        width:
                                            (currentSliderValueStyle
                                                    ?.fontSize ??
                                                16) *
                                            1.5,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          i18n.heightShort,
                                          style: currentSliderValueStyle,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: DeferredSlider(
                                        sliderType:
                                            DeferredSliderType.singleValue,
                                        currentValue: settingsState
                                            .defaultHeight
                                            .toDouble(),
                                        min: GameSettings.minHeight.toDouble(),
                                        max: GameSettings.maxHeight.toDouble(),
                                        divisions:
                                            GameSettings.maxHeight -
                                            GameSettings.minHeight,
                                        onChangedValue: (newValue) {
                                          appSettingsCubit.updateSettings(
                                            settingsState.copyWith(
                                              defaultHeight: newValue.round(),
                                            ),
                                          );
                                        },
                                        labelLeft: GameSettings.minHeight
                                            .toString(),
                                        labelRight: GameSettings.maxHeight
                                            .toString(),
                                        showThumbLabel: true,
                                        roundThumbLabelValue: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      ResponsiveLayoutBox(
                        children: [
                          Column(
                            children: [
                              Text(
                                i18n.settingsColorsAmount,
                                style: theme.textTheme.labelLarge,
                              ),
                              DeferredSlider(
                                sliderType: DeferredSliderType.singleValue,
                                currentValue: settingsState.defaultColorsAmount
                                    .toDouble(),
                                min: GameSettings.minColorsAmount.toDouble(),
                                max: GameSettings.maxColorsAmount.toDouble(),
                                divisions:
                                    GameSettings.maxColorsAmount -
                                    GameSettings.minColorsAmount,
                                onChangedValue: (newValue) {
                                  appSettingsCubit.updateSettings(
                                    settingsState.copyWith(
                                      defaultColorsAmount: newValue.round(),
                                    ),
                                  );
                                },
                                labelLeft: GameSettings.minColorsAmount
                                    .toString(),
                                labelRight: GameSettings.maxColorsAmount
                                    .toString(),
                                showThumbLabel: true,
                                roundThumbLabelValue: true,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                i18n.settingsFillSpeed,
                                style: theme.textTheme.labelLarge,
                              ),
                              DeferredSlider(
                                sliderType: DeferredSliderType.singleValue,
                                currentValue: settingsState.fillDelay
                                    .toDouble(),
                                min: 0,
                                max: 25,
                                divisions: 25,
                                onChangedValue: (newValue) {
                                  final newValueRounded = newValue.round();

                                  appSettingsCubit.updateSettings(
                                    settingsState.copyWith(
                                      fillDelay: newValueRounded,
                                    ),
                                  );

                                  gameStateCubit.syncNewAnimationSettings(
                                    fillDelay: newValueRounded,
                                  );
                                },
                                labelLeft: i18n.settingsFillSpeedFaster,
                                labelRight: i18n.settingsFillSpeedSlower,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 8,
                          children: [
                            Text(
                              i18n.settingsStartingPosition,
                              style: theme.textTheme.labelLarge,
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
                      ),
                    ],
                  ),
                  AppSettingsSection(
                    sectionTitle: i18n.settingsSectionColorPalette,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ResponsiveLayoutBox(
                          spacingHorizontal: 24,
                          children: [
                            DeferredSlider(
                              sliderType: DeferredSliderType.singleValue,
                              currentValue: settingsState.saturationShift,
                              min: -1,
                              max: 1,
                              divisions: 20,
                              onChangedValue: (newValue) {
                                appSettingsCubit.updateSettings(
                                  settingsState.copyWith(
                                    saturationShift: newValue,
                                  ),
                                );

                                gameStateCubit.syncPaletteSettings(
                                  saturationShift: newValue,
                                );
                              },
                              labelLeft:
                                  i18n.settingsPaletteSaturationGrayscale,
                              labelRight:
                                  i18n.settingsPaletteSaturationColorful,
                            ),
                            DeferredSlider(
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
                              labelLeft: i18n.settingsBrightnessContrastDarker,
                              labelRight:
                                  i18n.settingsBrightnessContrastLighter,
                            ),
                          ],
                        ),
                      ),

                      AppSettingListTile<bool>.switcher(
                        icon: Icons.monochrome_photos,
                        title: i18n.settingsMonochromeMode,
                        currentValue: settingsState.monochromeMode,
                        onChanged: (value) {
                          appSettingsCubit.updateSettings(
                            settingsState.copyWith(monochromeMode: value),
                          );

                          gameStateCubit.syncPaletteSettings(
                            monochromeMode: value,
                          );
                        },
                      ),

                      AppSettingListTile<bool>.custom(
                        icon: Icons.colorize,
                        title: i18n.settingsMonochromeSeedColor,
                        enabled: settingsState.monochromeMode,
                        control: ColorPickerButton(
                          currentValue:
                              settingsState.monochromeSeedColor ??
                              defaultMonochromeColor,
                          defaultValue: defaultMonochromeColor,
                          enabled: settingsState.monochromeMode,
                          alphaAllowed: false,
                          dialogTitle: i18n.settingsMonochromeSeedColor,
                          pickerType: ColorPickerDialogType.block,
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
                      Column(
                        spacing: 8,
                        children: [
                          Text(
                            i18n.titlePalettePreview,
                            style: theme.textTheme.labelMedium,
                          ),
                          PalettePreview(
                            palette: palette,
                            colorAccessabilityMode:
                                settingsState.colorAccessabilityMode,
                            maxWidth: min(
                              70.0 * palette.length,
                              smallScreenSizeBreakpoint.toDouble(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  AppSettingsSection(
                    sectionTitle: i18n.settingsSectionInformation,
                    children: [AboutAppTile()],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AppSettingsSection extends StatelessWidget {
  final String sectionTitle;

  final List<Widget> children;
  const AppSettingsSection({
    super.key,
    required this.sectionTitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              sectionTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ...children,
        ],
      ),
    ),
  );
}

class ResetAppSettingsButton extends StatelessWidget {
  const ResetAppSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(i18n.buttonResetSettings),
            content: Text(i18n.messageWarningYouSure),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(i18n.no),
              ),
              TextButton(
                onPressed: () {
                  context.read<AppSettingsCubit>().resetToDefault();

                  showNotification(context, i18n.messageSettingsWereReset);

                  Navigator.pop(context);
                },
                child: Text(i18n.yes),
              ),
            ],
          ),
        );
      },
      tooltip: i18n.buttonResetSettings,
      icon: const Icon(Icons.settings_backup_restore),
    );
  }
}

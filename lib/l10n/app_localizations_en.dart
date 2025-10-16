// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MZFlood';

  @override
  String get authorName => 'Maxim Zhuravlev (MxZhur)';

  @override
  String get buttonPlay => 'Play';

  @override
  String get titleSettings => 'Settings';

  @override
  String get messageVictory => 'Well Done!';

  @override
  String get messageDefeat => 'No more moves';

  @override
  String get buttonNewGame => 'New Game';

  @override
  String get buttonRestartBoard => 'Restart Board';

  @override
  String get debug => 'Debug';

  @override
  String get debugSetVictory => 'Instant Victory';

  @override
  String get debugSetDefeat => 'Instant Defeat';

  @override
  String get debugStepForward => 'Fill Step Forward';

  @override
  String get messageNewGameStarted => 'Started a new Board.';

  @override
  String get messageBoardRestarted => 'Board reverted.';

  @override
  String get infoAppDescriptionStart =>
      'A nicer, smoother implementation of the';

  @override
  String get infoAppBasedOn =>
      'Flood game from Simon Tatham\'s Portable Puzzle Collection';

  @override
  String get infoGameRules =>
      'In Flood, you play on a randomly colored grid or cells.\n\nEach turn, pick a color you want to flood-fill the area.\n\nThe goal is to make the entire field single-color within a limited amount of moves.\n\nGood luck!';

  @override
  String get poweredByFlutter => 'Powered by Flutter';

  @override
  String get settingsSectionUserInterface => 'User Interface';

  @override
  String get settingsSectionColorPalette => 'Color Palette';

  @override
  String get settingsSectionGame => 'Game';

  @override
  String get settingsSectionInformation => 'Information';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsThemeMode => 'Light/Dark mode';

  @override
  String get settingsThemeModeSystem => 'System';

  @override
  String get settingsThemeModeLight => 'Light';

  @override
  String get settingsThemeModeDark => 'Dark';

  @override
  String get settingsColorAccessabilityMode => 'Mark cells with numbers';

  @override
  String get settingsShowColorPanel => 'Show Color Selection Panel';

  @override
  String get settingsShowColorPanelSubtitle =>
      'You can always tap cells on the board to flood-fill with their color.';

  @override
  String get settingsMonochromeMode => 'Monochrome Mode';

  @override
  String get settingsMonochromeSeedColor => 'Monochrome Tint Color';

  @override
  String get settingsTitlePaletteSaturation => 'Saturation Modifier';

  @override
  String get settingsPaletteSaturationGrayscale => 'Grayscale';

  @override
  String get settingsPaletteSaturationColorful => 'More Colorful';

  @override
  String get settingsTitleBrightnessContrast => 'Brightness / Contrast';

  @override
  String get settingsBrightnessContrastDarker => 'Darker';

  @override
  String get settingsBrightnessContrastLighter => 'Lighter';

  @override
  String get titlePalettePreview => 'Palette Preview';

  @override
  String get messageSettingsNewGameOnly =>
      'Changes of game settings only apply after you start a new game.\nThe current game board will still use the old game settings.';

  @override
  String get settingsBoardSize => 'Grid Size';

  @override
  String get width => 'Width';

  @override
  String get height => 'Height';

  @override
  String get widthShort => 'W';

  @override
  String get heightShort => 'H';

  @override
  String get settingsFillSpeed => 'Flood-Fill Effect Speed';

  @override
  String get settingsFillSpeedFaster => 'Faster';

  @override
  String get settingsFillSpeedSlower => 'Slower';

  @override
  String get settingsColorsAmount => 'Amount of Colors';

  @override
  String get settingsStartingPosition => 'Filling Point Position';

  @override
  String get settingsStartingPositionRandom => 'Random';

  @override
  String get buttonResetSettings => 'Reset Settings';

  @override
  String get messageWarningYouSure => 'Are you sure?';

  @override
  String get messageSettingsWereReset => 'Settings have been reset.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';
}

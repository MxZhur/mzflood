import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// App Title
  ///
  /// In en, this message translates to:
  /// **'MZFlood'**
  String get appTitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Maxim Zhuravlev (MxZhur)'**
  String get authorName;

  ///
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get buttonPlay;

  ///
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get titleSettings;

  ///
  ///
  /// In en, this message translates to:
  /// **'Well Done!'**
  String get messageVictory;

  ///
  ///
  /// In en, this message translates to:
  /// **'No more moves'**
  String get messageDefeat;

  ///
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get buttonNewGame;

  ///
  ///
  /// In en, this message translates to:
  /// **'Restart Board'**
  String get buttonRestartBoard;

  ///
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debug;

  ///
  ///
  /// In en, this message translates to:
  /// **'Instant Victory'**
  String get debugSetVictory;

  ///
  ///
  /// In en, this message translates to:
  /// **'Instant Defeat'**
  String get debugSetDefeat;

  ///
  ///
  /// In en, this message translates to:
  /// **'Fill Step Forward'**
  String get debugStepForward;

  ///
  ///
  /// In en, this message translates to:
  /// **'Started a new Board.'**
  String get messageNewGameStarted;

  ///
  ///
  /// In en, this message translates to:
  /// **'Board reverted.'**
  String get messageBoardRestarted;

  ///
  ///
  /// In en, this message translates to:
  /// **'A nicer, smoother implementation of the'**
  String get infoAppDescriptionStart;

  ///
  ///
  /// In en, this message translates to:
  /// **'Flood game from Simon Tatham\'s Portable Puzzle Collection'**
  String get infoAppBasedOn;

  ///
  ///
  /// In en, this message translates to:
  /// **'In Flood, you play on a randomly colored grid or cells.\n\nEach turn, pick a color you want to flood-fill the area.\n\nThe goal is to make the entire field single-color within a limited amount of moves.\n\nGood luck!'**
  String get infoGameRules;

  ///
  ///
  /// In en, this message translates to:
  /// **'Powered by Flutter'**
  String get poweredByFlutter;

  ///
  ///
  /// In en, this message translates to:
  /// **'User Interface'**
  String get settingsSectionUserInterface;

  ///
  ///
  /// In en, this message translates to:
  /// **'Color Palette'**
  String get settingsSectionColorPalette;

  ///
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get settingsSectionGame;

  ///
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get settingsSectionInformation;

  ///
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  ///
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsLanguageSystem;

  ///
  ///
  /// In en, this message translates to:
  /// **'Light/Dark mode'**
  String get settingsThemeMode;

  ///
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeModeSystem;

  ///
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeModeLight;

  ///
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeModeDark;

  ///
  ///
  /// In en, this message translates to:
  /// **'Mark cells with numbers'**
  String get settingsColorAccessabilityMode;

  ///
  ///
  /// In en, this message translates to:
  /// **'Show Color Selection Panel'**
  String get settingsShowColorPanel;

  ///
  ///
  /// In en, this message translates to:
  /// **'You can always tap cells on the board to flood-fill with their color.'**
  String get settingsShowColorPanelSubtitle;

  ///
  ///
  /// In en, this message translates to:
  /// **'Monochrome Mode'**
  String get settingsMonochromeMode;

  ///
  ///
  /// In en, this message translates to:
  /// **'Monochrome Tint Color'**
  String get settingsMonochromeSeedColor;

  ///
  ///
  /// In en, this message translates to:
  /// **'Saturation Modifier'**
  String get settingsTitlePaletteSaturation;

  ///
  ///
  /// In en, this message translates to:
  /// **'Grayscale'**
  String get settingsPaletteSaturationGrayscale;

  ///
  ///
  /// In en, this message translates to:
  /// **'More Colorful'**
  String get settingsPaletteSaturationColorful;

  ///
  ///
  /// In en, this message translates to:
  /// **'Brightness / Contrast'**
  String get settingsTitleBrightnessContrast;

  ///
  ///
  /// In en, this message translates to:
  /// **'Darker'**
  String get settingsBrightnessContrastDarker;

  ///
  ///
  /// In en, this message translates to:
  /// **'Lighter'**
  String get settingsBrightnessContrastLighter;

  ///
  ///
  /// In en, this message translates to:
  /// **'Palette Preview'**
  String get titlePalettePreview;

  ///
  ///
  /// In en, this message translates to:
  /// **'Changes of game settings only apply after you start a new game.\nThe current game board will still use the old game settings.'**
  String get messageSettingsNewGameOnly;

  ///
  ///
  /// In en, this message translates to:
  /// **'Grid Size'**
  String get settingsBoardSize;

  ///
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  ///
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  ///
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get widthShort;

  ///
  ///
  /// In en, this message translates to:
  /// **'H'**
  String get heightShort;

  ///
  ///
  /// In en, this message translates to:
  /// **'Flood-Fill Effect Speed'**
  String get settingsFillSpeed;

  ///
  ///
  /// In en, this message translates to:
  /// **'Faster'**
  String get settingsFillSpeedFaster;

  ///
  ///
  /// In en, this message translates to:
  /// **'Slower'**
  String get settingsFillSpeedSlower;

  ///
  ///
  /// In en, this message translates to:
  /// **'Amount of Colors'**
  String get settingsColorsAmount;

  ///
  ///
  /// In en, this message translates to:
  /// **'Filling Point Position'**
  String get settingsStartingPosition;

  ///
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get settingsStartingPositionRandom;

  ///
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get buttonResetSettings;

  ///
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get messageWarningYouSure;

  ///
  ///
  /// In en, this message translates to:
  /// **'Settings have been reset.'**
  String get messageSettingsWereReset;

  ///
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  ///
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

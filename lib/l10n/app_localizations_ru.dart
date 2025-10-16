// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Заливка';

  @override
  String get authorName => 'Максим Журавлёв (MxZhur)';

  @override
  String get buttonPlay => 'Играть';

  @override
  String get titleSettings => 'Настройки';

  @override
  String get messageVictory => 'Победа!';

  @override
  String get messageDefeat => 'Ходов не хватило';

  @override
  String get buttonNewGame => 'Новая игра';

  @override
  String get buttonRestartBoard => 'Переиграть заново';

  @override
  String get debug => 'Отладка';

  @override
  String get debugSetVictory => 'Мгновенная победа';

  @override
  String get debugSetDefeat => 'Мгновенное поражение';

  @override
  String get debugStepForward => 'Обработать шаг заливки';

  @override
  String get messageNewGameStarted => 'Начата новая игра.';

  @override
  String get messageBoardRestarted => 'Игра сброшена в начало.';

  @override
  String get infoAppDescriptionStart => 'Более красивая и плавная реализация';

  @override
  String get infoAppBasedOn =>
      'игры Flood (\"Заливка\") с сайта Simon Tatham\'s Portable Puzzle Collection';

  @override
  String get infoGameRules =>
      'В этой игре, Вы начинаете с поля из клеток, закрашенных цветами в случайном порядке.\n\nКаждый ход, Вы выбираете цвет, которым хотите \"залить\" поле из специально промаркированной клетки (по аналогии с Заливкой из MS Paint).\n\nВаша цель — заполнить всё поле так, чтобы на нём остался только один цвет, за ограниченное число ходов.\n\nУдачи!';

  @override
  String get poweredByFlutter =>
      'Приложение сделано с помощью технологии Flutter';

  @override
  String get settingsSectionUserInterface => 'Интерфейс';

  @override
  String get settingsSectionColorPalette => 'Палитра цветов';

  @override
  String get settingsSectionGame => 'Игра';

  @override
  String get settingsSectionInformation => 'Информация';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLanguageSystem => 'Как в системе';

  @override
  String get settingsThemeMode => 'Светлая/тёмная тема';

  @override
  String get settingsThemeModeSystem => 'Как в системе';

  @override
  String get settingsThemeModeLight => 'Светлая';

  @override
  String get settingsThemeModeDark => 'Тёмная';

  @override
  String get settingsColorAccessabilityMode => 'Отмечать клетки числами';

  @override
  String get settingsShowColorPanel => 'Показывать панель выбора цвета';

  @override
  String get settingsShowColorPanelSubtitle =>
      'Вы всегда можете нажимать на клетки на игровом поле, чтобы делать заливку их цветом.';

  @override
  String get settingsMonochromeMode => 'Режим монохромной палитры';

  @override
  String get settingsMonochromeSeedColor => 'Тон монохромной палитры';

  @override
  String get settingsTitlePaletteSaturation => 'Модификатор насыщенности';

  @override
  String get settingsPaletteSaturationGrayscale => 'Оттенки серого';

  @override
  String get settingsPaletteSaturationColorful => 'Максимальная насыщенность';

  @override
  String get settingsTitleBrightnessContrast => 'Яркость / Контраст';

  @override
  String get settingsBrightnessContrastDarker => 'Темнее';

  @override
  String get settingsBrightnessContrastLighter => 'Светлее';

  @override
  String get titlePalettePreview => 'Предпросмотр палитры';

  @override
  String get messageSettingsNewGameOnly =>
      'Изменения настроек игры вступят в силу, когда Вы начнёте новую игру.\nТекущее игровое поле продолжит использовать старые настройки.';

  @override
  String get settingsBoardSize => 'Размер поля';

  @override
  String get width => 'Ширина';

  @override
  String get height => 'Высота';

  @override
  String get widthShort => 'Ш';

  @override
  String get heightShort => 'В';

  @override
  String get settingsFillSpeed => 'Скорость эффекта заливки';

  @override
  String get settingsFillSpeedFaster => 'Быстрее';

  @override
  String get settingsFillSpeedSlower => 'Медленнее';

  @override
  String get settingsColorsAmount => 'Количество цветов';

  @override
  String get settingsStartingPosition => 'Положение точки заливки';

  @override
  String get settingsStartingPositionRandom => 'Случайное';

  @override
  String get buttonResetSettings => 'Сбросить настройки';

  @override
  String get messageWarningYouSure => 'Вы уверены?';

  @override
  String get messageSettingsWereReset => 'Настройки сброшены.';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';
}

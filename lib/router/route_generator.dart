import 'package:flutter/material.dart';
import 'package:mzflood/screens/app_settings_screen/app_settings_screen.dart';
import 'package:mzflood/screens/game_screen/game_screen.dart';

abstract class RouteGenerator {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) => GameScreen());
    }

    if (settings.name == '/app-settings') {
      return MaterialPageRoute(builder: (context) => AppSettingsScreen());
    }

    return null;
  }
}

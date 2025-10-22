import 'package:flutter/material.dart';

import '/screens/app_settings_screen/app_settings_screen.dart';
import '/screens/game_screen/game_screen.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  if (settings.name == '/') {
    return MaterialPageRoute(builder: (_) => GameScreen());
  }

  if (settings.name == '/app-settings') {
    return MaterialPageRoute(builder: (_) => AppSettingsScreen());
  }

  return null;
}

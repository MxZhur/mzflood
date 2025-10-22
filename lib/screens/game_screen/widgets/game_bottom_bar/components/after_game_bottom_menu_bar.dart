import 'package:flutter/material.dart';

import '/commands/commands.dart';
import '/l10n/app_localizations.dart';

class AfterGameBottomMenuBar extends StatelessWidget {
  static const _buttonStyle = ButtonStyle(
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    ),
    iconSize: WidgetStatePropertyAll(30.0),
    textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 30)),
  );

  const AfterGameBottomMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: FittedBox(
          child: Row(
            spacing: 16,
            children: [
              ElevatedButton.icon(
                onPressed: () => resetBoard(context),
                style: _buttonStyle,
                icon: const Icon(Icons.restore),
                label: Text(i18n.buttonRestartBoard),
              ),
              ElevatedButton.icon(
                onPressed: () => startNewGame(context),
                style: _buttonStyle,
                icon: const Icon(Icons.play_arrow),
                label: Text(i18n.buttonNewGame),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

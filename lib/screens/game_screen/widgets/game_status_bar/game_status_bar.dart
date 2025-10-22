import 'package:flutter/material.dart';

import 'components/game_tool_bar.dart';
import 'components/moves_count_display.dart';

class GameStatusBar extends StatelessWidget {
  const GameStatusBar({super.key});

  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 24,
        children: [MovesCountDisplay(), GameToolBar()],
      ),
    ),
  );
}

import 'package:flutter/material.dart';

void showNotification(
  BuildContext context,
  String message, {
  bool clearPreviousNotifications = true,
}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  if (clearPreviousNotifications) {
    scaffoldMessenger.clearSnackBars();
  }

  scaffoldMessenger.showSnackBar(
    SnackBar(content: Text(message), duration: Durations.extralong4),
  );
}

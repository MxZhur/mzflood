import 'package:flutter/material.dart';

class AppSettingItem<T> extends StatelessWidget {
  const AppSettingItem({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.enabled = true,
    this.busy = false,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool enabled;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      enabled: enabled && !busy,
    );
  }

  factory AppSettingItem.dropDown({
    required String title,
    required Map<T?, String> options,
    required ValueChanged<T?> onChanged,
    bool enabled = true,
    bool busy = false,
    T? currentValue,
    IconData? icon,
  }) {
    List<DropdownMenuItem<T?>> items = options.entries
        .map((e) => DropdownMenuItem<T?>(value: e.key, child: Text(e.value)))
        .toList();

    return AppSettingItem(
      leading: Icon(icon),
      title: Text(title),
      enabled: enabled,
      busy: busy,
      trailing: DropdownButton<T?>(
        items: items,
        value: currentValue,
        onChanged: enabled && !busy ? onChanged : null,
      ),
    );
  }

  factory AppSettingItem.switcher({
    required String title,
    required ValueChanged<bool> onChanged,
    required bool currentValue,
    Widget? subtitleWhenOn,
    Widget? subtitleWhenOff,
    bool enabled = true,
    bool busy = false,
    IconData? icon,
  }) {
    return AppSettingItem(
      leading: Icon(icon),
      title: Text(title),
      enabled: enabled,
      busy: busy,
      subtitle: currentValue ? subtitleWhenOn : subtitleWhenOff,
      trailing: Switch(
        value: currentValue,
        onChanged: (enabled && !busy) ? onChanged : null,
      ),
    );
  }

  factory AppSettingItem.custom({
    required String title,
    required Widget control,
    bool enabled = true,
    bool busy = false,
    IconData? icon,
  }) {
    return AppSettingItem(
      leading: Icon(icon),
      title: Text(title),
      enabled: enabled,
      busy: busy,

      trailing: control,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerButton extends StatelessWidget {
  static const double buttonPadding = 8;
  static const double buttonBorderRadius = 10;
  final Color currentValue;
  final Color? defaultValue;
  final void Function(Color newValue) onChanged;
  final String? dialogTitle;
  final bool enabled;

  final bool alphaAllowed;
  final ColorPickerDialogType pickerType;

  const ColorPickerButton({
    super.key,
    required this.currentValue,
    required this.onChanged,
    this.defaultValue,
    this.dialogTitle,
    this.enabled = true,
    this.alphaAllowed = false,
    this.pickerType = ColorPickerDialogType.normal,
  });

  @override
  Widget build(BuildContext context) {
    final buttonInnerBorderRadius = buttonBorderRadius - buttonPadding;

    final buttonTheme = Theme.of(context).buttonTheme;

    final swatchMinWidth =
        buttonTheme.minWidth -
        buttonTheme.padding.horizontal -
        (buttonPadding * 2);
    final swatchHeight = buttonTheme.height - (buttonPadding * 2);

    return ElevatedButton(
      onPressed: enabled
          ? () {
              showDialog(
                context: context,
                builder: (_) => ColorPickerDialog(
                  alphaAllowed: alphaAllowed,
                  currentValue: currentValue,
                  onChanged: onChanged,
                  pickerType: pickerType,
                  defaultValue: defaultValue,
                  dialogTitle: dialogTitle,
                ),
              );
            }
          : null,
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder?>(
          RoundedRectangleBorder(
            borderRadius: const BorderRadiusGeometry.all(
              Radius.circular(buttonBorderRadius),
            ),
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
      ),
      child: Padding(
        padding: const EdgeInsets.all(buttonPadding),
        child: Container(
          width: swatchMinWidth,
          height: swatchHeight,
          decoration: BoxDecoration(
            color: currentValue,
            borderRadius: BorderRadius.circular(buttonInnerBorderRadius),
          ),
        ),
      ),
    );
  }
}

class ColorPickerDialog extends StatefulWidget {
  final Color currentValue;
  final Color? defaultValue;
  final void Function(Color newValue) onChanged;
  final String? dialogTitle;
  final bool alphaAllowed;
  final ColorPickerDialogType pickerType;

  const ColorPickerDialog({
    super.key,
    required this.currentValue,
    this.defaultValue,
    required this.onChanged,
    this.dialogTitle,
    required this.alphaAllowed,
    required this.pickerType,
  });

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

enum ColorPickerDialogType { normal, block, material }

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color pickerColor = Color(0xff443a49);

  @override
  Widget build(BuildContext context) {
    final Widget picker = switch (widget.pickerType) {
      ColorPickerDialogType.normal => ColorPicker(
        enableAlpha: widget.alphaAllowed,
        displayThumbColor: true,
        pickerColor: pickerColor,
        portraitOnly: true,
        onColorChanged: updatePickerColor,
      ),
      ColorPickerDialogType.block => BlockPicker(
        useInShowDialog: true,
        pickerColor: pickerColor,
        onColorChanged: updatePickerColor,
      ),
      ColorPickerDialogType.material => MaterialPicker(
        portraitOnly: false,
        pickerColor: pickerColor,
        onColorChanged: updatePickerColor,
      ),
    };

    return AlertDialog(
      title: widget.dialogTitle != null ? Text(widget.dialogTitle!) : null,
      content: SingleChildScrollView(child: picker),
      actions: <Widget>[
        if (widget.defaultValue != null)
          ElevatedButton(
            onPressed: (widget.defaultValue != widget.currentValue)
                ? () {
                    widget.onChanged(widget.defaultValue!);
                    Navigator.pop(context);
                  }
                : null,
            child: const Icon(Icons.settings_backup_restore),
          ),

        ElevatedButton(
          child: const Icon(Icons.close),
          onPressed: () {
            resetPicker();
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: const Icon(Icons.check),
          onPressed: () {
            widget.onChanged(pickerColor);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    pickerColor = widget.currentValue;
  }

  void resetPicker() {
    setState(() => pickerColor = widget.currentValue);
  }

  void updatePickerColor(Color color) {
    setState(() => pickerColor = color);
  }
}

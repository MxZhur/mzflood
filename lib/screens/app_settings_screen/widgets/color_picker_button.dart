import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

enum ColorPickerButtonType {
  normal,
  block,
  material,
}

class ColorPickerButton extends StatefulWidget {
  final Color currentValue;
  final Color? defaultValue;
  final void Function(Color newValue) onChanged;
  final String? dialogTitle;
  final bool enabled;
  final bool enableAlpha;
  final ColorPickerButtonType pickerType;

  const ColorPickerButton({
    super.key,
    required this.currentValue,
    required this.onChanged,
    this.defaultValue,
    this.dialogTitle,
    this.enabled = true,
    this.enableAlpha = false,
    this.pickerType = ColorPickerButtonType.normal,
  });

  @override
  State<ColorPickerButton> createState() => _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  Color pickerColor = Color(0xff443a49);

  @override
  void initState() {
    super.initState();
    pickerColor = widget.currentValue;
  }

  void updatePickerColor(Color color) {
    setState(() => pickerColor = color);
  }

  void resetPicker() {
    setState(() => pickerColor = widget.currentValue);
  }

  @override
  Widget build(BuildContext context) {
    double buttonPadding = 8;
    double buttonBorderRadius = 10;
    double buttonInnerBorderRadius = buttonBorderRadius - buttonPadding;

    ButtonThemeData buttonTheme = Theme.of(context).buttonTheme;

    double swatchMinWidth = buttonTheme.minWidth - buttonTheme.padding.horizontal - (buttonPadding * 2);
    double swatchHeight = buttonTheme.height - (buttonPadding * 2);

    return ElevatedButton(
      onPressed: widget.enabled ? () {
        resetPicker();

        final Widget picker;

        switch (widget.pickerType) {

          case ColorPickerButtonType.normal:
            picker = ColorPicker(
                // useInShowDialog: true,
                enableAlpha: widget.enableAlpha,
                displayThumbColor: true,
                pickerColor: pickerColor,
                portraitOnly: true,
                onColorChanged: updatePickerColor,

              );
          case ColorPickerButtonType.block:
            picker = BlockPicker(
                useInShowDialog: true,
                pickerColor: pickerColor,
                onColorChanged: updatePickerColor,
              );
          case ColorPickerButtonType.material:
            picker = MaterialPicker(
                portraitOnly: false,
                pickerColor: pickerColor,
                onColorChanged: updatePickerColor,
              );
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: widget.dialogTitle != null
                ? Text(widget.dialogTitle!)
                : null,
            content: SingleChildScrollView(
              child: picker,
            ),
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
          ),
        );
      } : null,
      style: ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder?>(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(
              Radius.circular(buttonBorderRadius),
            ),
          ),
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(
          EdgeInsets.zero,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(buttonPadding),
        child: Container(
          width: swatchMinWidth,
          height: swatchHeight,
          decoration: BoxDecoration(
            color: widget.currentValue,
            borderRadius: BorderRadius.circular(buttonInnerBorderRadius),
          ),
        ),
      ),
    );
  }
}

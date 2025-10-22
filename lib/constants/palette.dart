import 'package:flutter/material.dart';

import '/utils/range_functions.dart';

const Palette defaultMinimalGameGridPalette = [
  Colors.blueAccent,
  Colors.greenAccent,
  Colors.amber,
  Colors.red,
];
const Color defaultMonochromeColor = Colors.grey;

Palette getMonochromePalette({
  required Color seedColor,
  required int colorsAmount,
}) => Palette.generate(
  colorsAmount,
  (index) => HSLColor.fromColor(
    seedColor,
  ).withLightness(mapRange(index / colorsAmount, 0, 1, 0.1, 0.9)).toColor(),
);

typedef HSLPalette = List<HSLColor>;
typedef Palette = List<Color>;

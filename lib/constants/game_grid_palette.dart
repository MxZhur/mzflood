import 'dart:math';

import 'package:flutter/material.dart';

typedef Palette = List<Color>;
typedef HSLPalette = List<HSLColor>;

extension MappableHSLPalette on HSLPalette {
  Palette toRGBPalette() => map((e) => e.toColor()).toList();
}

extension MappablePalette on Palette {
  Palette withScaledSaturation([double saturationShift = 0]) =>
      map((Color oldColor) {
        if (saturationShift > 0) {
          HSLColor oldColorHSL = HSLColor.fromColor(oldColor);

          double mappedSaturation = mapRange(
            oldColorHSL.saturation,
            0,
            1,
            saturationShift.clamp(0, 1),
            1,
          );

          return oldColorHSL.withSaturation(mappedSaturation).toColor();
        }

        if (saturationShift < 0) {
          HSLColor oldColorHSL = HSLColor.fromColor(oldColor);
          double mappedSaturation =
              oldColorHSL.saturation * (1 - saturationShift.abs().clamp(0, 1));

          return oldColorHSL.withSaturation(mappedSaturation).toColor();
        }

        return oldColor;
      }).toList();

  Palette withScaledBrightnessRange([
    double lowestBrightness = 0,
    double highestBrightness = 1,
  ]) => map((Color oldColor) {
    HSLColor oldColorHSL = HSLColor.fromColor(oldColor);

    double mappedBrightness = mapRange(
      oldColorHSL.lightness,
      0,
      1,
      min<double>(lowestBrightness, highestBrightness).clamp(0, 1),
      max<double>(lowestBrightness, highestBrightness).clamp(0, 1),
    );

    return HSLColor.fromColor(
      oldColor,
    ).withLightness(mappedBrightness).toColor();
  }).toList();

  Palette forAmount(int maxColors) {
    if (maxColors < length) {
      return sublist(0, maxColors);
    }

    int pseudoRandomSeed = 67; // Should be a prime number to prevent repetition
    int pseudoRandomRange = 1000;

    if (maxColors > length) {
      return this +
          HSLPalette.generate(
            maxColors - length,
            (index) => HSLColor.fromAHSL(
              1,
              (index * pseudoRandomSeed) % 360,
              mapRange(
                ((index * pseudoRandomSeed) % pseudoRandomRange).toDouble(),
                1,
                pseudoRandomRange.toDouble(),
                0.75,
                1,
              ),
              mapRange(
                ((index * pseudoRandomSeed) % pseudoRandomRange).toDouble(),
                1,
                pseudoRandomRange.toDouble(),
                0.4,
                0.8,
              ),
            ),
          ).toRGBPalette();
    }

    return this;
  }

  HSLPalette toHSLPalette() => map((e) => HSLColor.fromColor(e)).toList();
}

const Color defaultMonochromeColor = Colors.grey;

Palette generatePalette({
  required int colorsAmount,
  bool monochromeMode = false,
  Color? monochromeSeedColor,
  double saturationShift = 0,
  lowestBrightness = 0,
  highestBrightness = 1,
}) {
  monochromeSeedColor ??= defaultMonochromeColor;

  Palette palette;

  if (monochromeMode) {
    palette = getMonochromePalette(
      seedColor: HSLColor.fromColor(monochromeSeedColor).toColor(),
      colorsAmount: colorsAmount,
    );
  } else {
    palette = defaultMinimalGameGridPalette.forAmount(colorsAmount);
  }

  return palette
      .withScaledSaturation(saturationShift)
      .withScaledBrightnessRange(lowestBrightness, highestBrightness);
}

Palette getMonochromePalette({
  required Color seedColor,
  required int colorsAmount,
}) => Palette.generate(
  colorsAmount,
  (index) => HSLColor.fromColor(
    seedColor,
  ).withLightness(mapRange(index / colorsAmount, 0, 1, 0.1, 0.9)).toColor(),
);

const Palette defaultMinimalGameGridPalette = [
  Colors.blueAccent,
  Colors.greenAccent,
  Colors.amber,
  Colors.red,
];

double mapRange(
  double input,
  double inputStart,
  double inputEnd,
  double outputStart,
  double outputEnd,
) =>
    outputStart +
    ((outputEnd - outputStart) / (inputEnd - inputStart)) *
        (input - inputStart);

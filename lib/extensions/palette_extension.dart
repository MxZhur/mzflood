import 'dart:math';

import 'package:flutter/widgets.dart';

import '/constants/palette.dart';
import '/utils/range_functions.dart';

extension MappableHSLPalette on HSLPalette {
  Palette toRGBPalette() => map((e) => e.toColor()).toList();
}

extension MappablePalette on Palette {
  Palette forAmount(int maxColorsAmount) {
    if (maxColorsAmount < length) {
      return sublist(0, maxColorsAmount);
    }

    // pseudoRandomSeed should be a prime number to prevent repetition.
    final pseudoRandomSeed = 67;
    final pseudoRandomRange = 1000;

    if (maxColorsAmount > length) {
      return this +
          HSLPalette.generate(
            maxColorsAmount - length,
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

  HSLPalette toHSLPalette() => map(HSLColor.fromColor).toList();

  Palette withScaledBrightnessRange([
    double lowestBrightness = 0,
    double highestBrightness = 1,
  ]) => toHSLPalette()
      .map<HSLColor>(
        (oldColor) => oldColor.withLightness(
          mapRange(
            oldColor.lightness,
            0,
            1,
            min<double>(lowestBrightness, highestBrightness).clamp(0, 1),
            max<double>(lowestBrightness, highestBrightness).clamp(0, 1),
          ),
        ),
      )
      .toList()
      .toRGBPalette();

  Palette withScaledSaturation([double saturationShift = 0]) => toHSLPalette()
      .map<HSLColor>((oldColor) {
        if (saturationShift > 0) {
          final mappedSaturation = mapRange(
            oldColor.saturation,
            0,
            1,
            saturationShift.clamp(0, 1),
            1,
          );

          return oldColor.withSaturation(mappedSaturation);
        } else if (saturationShift < 0) {
          final mappedSaturation =
              oldColor.saturation * (1 - saturationShift.abs().clamp(0, 1));

          return oldColor.withSaturation(mappedSaturation);
        }

        return oldColor;
      })
      .toList()
      .toRGBPalette();

  static Palette generatePalette({
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
}

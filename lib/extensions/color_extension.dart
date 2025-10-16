import 'dart:ui';

extension ColorWithDarknessDetection on Color {
  bool get isDark => ((r * 29.9 + g * 58.7 + b * 11.4) / 100) < 0.5;
}

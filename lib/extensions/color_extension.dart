import 'dart:ui';

extension ColorWithDarknessDetection on Color {
  bool get isDark => (r * 0.29 + g * 0.58 + b * 0.11) < 0.6;
}

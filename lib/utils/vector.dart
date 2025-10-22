import 'dart:math';

class Vector2<T extends num> {
  T x;
  T y;
  Vector2({required this.x, required this.y});

  double get length => sqrt(pow(x, 2) + pow(y, 2));

  Vector2 get normalized => this / length;

  Vector2<T> copyWith({T? x, T? y}) =>
      Vector2<T>(x: x ?? this.x, y: y ?? this.y);

  Vector2 operator +(Vector2 other) => Vector2(x: x + other.x, y: y + other.y);
  Vector2 operator -(Vector2 other) => Vector2(x: x - other.x, y: y - other.y);
  Vector2 operator *(num multiplier) =>
      Vector2(x: x * multiplier, y: y * multiplier);
  Vector2 operator /(num divisor) => Vector2(x: x / divisor, y: y / divisor);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Vector2<T> && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

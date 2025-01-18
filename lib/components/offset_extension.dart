import 'dart:math';
import 'dart:ui';

extension OffsetExtension on Offset {
  Point<int> toPointInt() => Point(dx.toInt(), dy.toInt());
}

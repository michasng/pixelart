import 'dart:math';

import 'package:image/image.dart' as img;

extension ImageExtension on img.Image {
  bool containsPoint(Point<int> point) {
    return point.x >= 0 && point.x < width && point.y >= 0 && point.y < height;
  }
}

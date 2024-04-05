import 'dart:math';
import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:pixelart/components/canvas/image_change.dart';
import 'package:pixelart/components/copy_matrix.dart';

@immutable
class RandomAccessImage {
  final int width;
  final int height;
  final List<List<Color?>> pixels;

  const RandomAccessImage._({
    required this.width,
    required this.height,
    required this.pixels,
  });

  bool containsPoint(Point<int> point) {
    return point.x >= 0 && point.x < width && point.y >= 0 && point.y < height;
  }

  factory RandomAccessImage.filled({
    required int width,
    required int height,
    required Color? color,
  }) {
    return RandomAccessImage._(
      width: width,
      height: height,
      pixels: List.generate(
        height,
        (index) => List.filled(width, color),
      ),
    );
  }

  RandomAccessImage copyWithChange(ImageChange change) {
    final copiedPixels = copyMatrix(pixels);

    for (var MapEntry(key: position, value: color)
        in change.pixelChanges.entries) {
      copiedPixels[position.y][position.x] = color;
    }

    return RandomAccessImage._(
      width: width,
      height: height,
      pixels: copiedPixels,
    );
  }
}

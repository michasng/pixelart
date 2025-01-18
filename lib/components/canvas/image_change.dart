import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:meta/meta.dart';
import 'package:pixelart/components/canvas/colors/colors.dart';

@immutable
class ImageChange {
  final Map<Point<int>, img.Color?> pixelChanges;

  const ImageChange({
    required this.pixelChanges,
  });

  ImageChange copyWith({
    Map<Point<int>, img.Color?>? pixelChanges,
  }) =>
      ImageChange(
        pixelChanges: pixelChanges ?? this.pixelChanges,
      );

  img.Image apply(img.Image image) {
    final copy = img.Image.from(image);
    for (var MapEntry(key: position, value: color) in pixelChanges.entries) {
      copy.setPixel(position.x, position.y, color ?? PixelColors.transparent);
    }
    return copy;
  }
}

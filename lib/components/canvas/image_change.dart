import 'dart:math';
import 'dart:ui';

import 'package:meta/meta.dart';

@immutable
class ImageChange {
  final Map<Point<int>, Color?> pixelChanges;

  const ImageChange({
    required this.pixelChanges,
  });

  ImageChange copyWith({
    Map<Point<int>, Color?>? pixelChanges,
  }) =>
      ImageChange(
        pixelChanges: pixelChanges ?? this.pixelChanges,
      );
}

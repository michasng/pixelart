import 'dart:ui';

import 'package:pixelart/components/copy_matrix.dart';

class CanvasPainterState {
  final List<List<Color?>> pixels;

  const CanvasPainterState({
    required this.pixels,
  });

  CanvasPainterState deepCopy() {
    return CanvasPainterState(
      pixels: copyMatrix(pixels),
    );
  }
}

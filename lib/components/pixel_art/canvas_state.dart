import 'dart:ui';

import 'package:pixelart/components/copy_matrix.dart';

class CanvasState {
  final List<List<Color?>> pixels;

  const CanvasState({
    required this.pixels,
  });

  CanvasState deepCopy() {
    return CanvasState(
      pixels: copyMatrix(pixels),
    );
  }
}

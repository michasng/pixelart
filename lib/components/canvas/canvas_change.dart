import 'dart:math';
import 'dart:ui';

import 'package:pixelart/components/canvas/canvas_painter.dart';
import 'package:pixelart/components/copy_matrix.dart';

class CanvasChange {
  final List<({Point<int> position, Color? color})> pixelChanges;

  const CanvasChange({
    required this.pixelChanges,
  });

  CanvasChange createReverseChange(CanvasPainter painter) {
    return CanvasChange(
      pixelChanges: pixelChanges
          .map((change) => (
                position: change.position,
                color: painter.pixels[change.position.y][change.position.x],
              ))
          .toList(),
    );
  }

  CanvasPainter apply(CanvasPainter painter) {
    final pixelCopy = copyMatrix(painter.pixels);
    for (var change in pixelChanges) {
      pixelCopy[change.position.y][change.position.x] = change.color;
    }

    return CanvasPainter(
      pixels: pixelCopy,
      showGrid: painter.showGrid,
      gridColor: painter.gridColor,
    );
  }
}

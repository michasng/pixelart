import 'dart:math';
import 'dart:ui';

import 'package:pixelart/components/canvas/canvas_painter.dart';

class CanvasToolContext {
  final CanvasPainter canvasPainter;
  final Color? selectedColor;
  final Point<int> position;

  const CanvasToolContext({
    required this.canvasPainter,
    required this.selectedColor,
    required this.position,
  });
}

import 'dart:math';
import 'dart:ui';

import 'package:pixelart/components/canvas/canvas_painter_state.dart';
import 'package:pixelart/components/canvas/events/canvas_event.dart';

class CanvasDrawEvent implements CanvasEvent {
  final Point<int> position;
  final Color color;

  const CanvasDrawEvent({
    required this.position,
    required this.color,
  });

  @override
  void apply(CanvasPainterState canvasState) {
    canvasState.pixels[position.y][position.x] = color;
  }
}

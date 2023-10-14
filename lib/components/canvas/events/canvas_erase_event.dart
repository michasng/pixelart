import 'dart:math';

import 'package:pixelart/components/canvas/canvas_painter_state.dart';
import 'package:pixelart/components/canvas/events/canvas_event.dart';

class CanvasEraseEvent implements CanvasEvent {
  final Point<int> position;

  const CanvasEraseEvent({
    required this.position,
  });

  @override
  void apply(CanvasPainterState canvasState) {
    canvasState.pixels[position.y][position.x] = null;
  }
}

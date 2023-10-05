import 'dart:math';

import 'package:pixelart/components/pixel_art/canvas_state.dart';
import 'package:pixelart/components/pixel_art/events/pixel_art_event.dart';

class PixelArtEraseEvent implements PixelArtEvent {
  final Point<int> position;

  const PixelArtEraseEvent({
    required this.position,
  });

  @override
  void apply(CanvasState canvasState) {
    canvasState.pixels[position.y][position.x] = null;
  }
}

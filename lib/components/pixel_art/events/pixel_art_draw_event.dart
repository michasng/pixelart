import 'dart:math';
import 'dart:ui';

import 'package:pixelart/components/pixel_art/canvas_state.dart';
import 'package:pixelart/components/pixel_art/events/pixel_art_event.dart';

class PixelArtDrawEvent implements PixelArtEvent {
  final Point<int> position;
  final Color color;

  const PixelArtDrawEvent({
    required this.position,
    required this.color,
  });

  @override
  void apply(CanvasState canvasState) {
    canvasState.pixels[position.y][position.x] = color;
  }
}

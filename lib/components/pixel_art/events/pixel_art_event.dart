import 'package:pixelart/components/pixel_art/canvas_state.dart';

abstract interface class PixelArtEvent {
  void apply(CanvasState canvasState);
}

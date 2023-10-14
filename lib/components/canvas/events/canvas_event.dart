import 'package:pixelart/components/canvas/canvas_painter_state.dart';

abstract interface class CanvasEvent {
  void apply(CanvasPainterState canvasState);
}

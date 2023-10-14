import 'package:flutter/rendering.dart';
import 'package:pixelart/components/canvas/canvas_painter_state.dart';

class CanvasPainter extends CustomPainter {
  final CanvasPainterState canvasState;
  final bool showGrid;
  final Color gridColor;

  const CanvasPainter({
    required this.canvasState,
    required this.showGrid,
    this.gridColor = const Color.fromARGB(255, 0, 0, 0),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final CanvasPainterState(:pixels) = canvasState;

    for (int y = 0; y < pixels.length; y++) {
      for (int x = 0; x < pixels[y].length; x++) {
        if (pixels[y][x] != null) {
          paint.color = pixels[y][x]!;
          paint.style = PaintingStyle.fill;
          canvas.drawRect(
            Rect.fromLTWH(x.toDouble(), y.toDouble(), 1.0, 1.0),
            paint,
          );
        }
        paint.style = PaintingStyle.stroke;
        if (showGrid) {
          paint.color = gridColor;
        }
        canvas.drawRect(
          Rect.fromLTWH(x.toDouble(), y.toDouble(), 1.0, 1.0),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) => true;
}

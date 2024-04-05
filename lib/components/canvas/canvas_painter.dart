import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';
import 'package:pixelart/components/canvas/canvas_settings.dart';
import 'package:pixelart/components/canvas/random_access_image.dart';

@immutable
class CanvasPainter extends CustomPainter {
  final RandomAccessImage image;
  final CanvasSettings settings;

  const CanvasPainter({
    required this.image,
    required this.settings,
  });

  CanvasPainter copyWith({
    RandomAccessImage? image,
    CanvasSettings? settings,
  }) =>
      CanvasPainter(
        image: image ?? this.image,
        settings: settings ?? this.settings,
      );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final pixels = image.pixels;

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
        if (settings.showGrid) {
          paint.color = settings.gridColor;
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

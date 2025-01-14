import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:meta/meta.dart';
import 'package:pixelart/components/canvas/canvas_settings.dart';
import 'package:pixelart/components/canvas/colors.dart';

@immutable
class CanvasPainter extends CustomPainter {
  final img.Image image;
  final CanvasSettings settings;

  const CanvasPainter({
    required this.image,
    required this.settings,
  });

  CanvasPainter copyWith({
    img.Image? image,
    CanvasSettings? settings,
  }) =>
      CanvasPainter(
        image: image ?? this.image,
        settings: settings ?? this.settings,
      );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);

        if (pixel.a != 0) {
          paint.color = toUiColor(pixel);
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

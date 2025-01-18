import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:meta/meta.dart';
import 'package:pixelart/components/canvas/canvas_settings.dart';
import 'package:pixelart/components/canvas/colors/colors.dart';

@immutable
class CanvasPainter extends CustomPainter {
  final img.Image image;
  final CanvasSettings Function() getSettings;
  final double scale;

  const CanvasPainter({
    required this.image,
    required this.getSettings,
    this.scale = 1.0,
  });

  CanvasPainter copyWith({
    img.Image? image,
    CanvasSettings Function()? getSettings,
    double? scale,
  }) =>
      CanvasPainter(
        image: image ?? this.image,
        getSettings: getSettings ?? this.getSettings,
        scale: scale ?? this.scale,
      );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final settings = getSettings();
    final actuallyShowGrid =
        settings.showGrid && scale >= settings.minScaleToShowGrid;

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

        if (actuallyShowGrid) {
          paint.color = settings.gridColor;
          paint.style = PaintingStyle.stroke;
          canvas.drawRect(
            Rect.fromLTWH(x.toDouble(), y.toDouble(), 1.0, 1.0),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) => true;
}

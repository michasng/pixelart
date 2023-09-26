import 'package:flutter/material.dart';

class PixelArtCanvas extends StatefulWidget {
  final int width, height;
  final Color? initialFillColor;
  final Color? Function() getColor;

  const PixelArtCanvas({
    super.key,
    required this.width,
    required this.height,
    required this.initialFillColor,
    required this.getColor,
  });

  @override
  State<PixelArtCanvas> createState() => _PixelArtCanvasState();
}

class _PixelArtCanvasState extends State<PixelArtCanvas> {
  late PixelArtPainter _pixelPainter;
  late double _scale;

  @override
  void initState() {
    super.initState();

    final pixels = _generatePixels(widget.initialFillColor);
    _pixelPainter = PixelArtPainter(pixels: pixels);
    _scale = 20;
  }

  List<List<Color?>> _generatePixels(Color? color) {
    return List.generate(
      widget.height,
      (index) => List.filled(widget.width, color),
    );
  }

  (int x, int y) localToPixel(Offset localPosition) {
    var pixelPosition = localPosition / _scale;
    return (pixelPosition.dx.toInt(), pixelPosition.dy.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        var (x, y) = localToPixel(details.localPosition);
        setState(() {
          final pixels = _pixelPainter.pixels;
          pixels[y][x] = widget.getColor();
          setState(() {
            _pixelPainter = PixelArtPainter(pixels: pixels);
          });
        });
      },
      child: Transform.scale(
        alignment: Alignment.topLeft,
        scale: _scale,
        child: CustomPaint(
          willChange: true,
          isComplex: true,
          painter: _pixelPainter,
          size: Size(widget.width * _scale, widget.height * _scale),
        ),
      ),
    );
  }
}

class PixelArtPainter extends CustomPainter {
  static const pixelSize = 1.0;

  List<List<Color?>> pixels;

  PixelArtPainter({required this.pixels});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int y = 0; y < pixels.length; y++) {
      for (int x = 0; x < pixels[y].length; x++) {
        if (pixels[y][x] == null) continue;
        paint.color = pixels[y][x]!;
        canvas.drawRect(
          Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(PixelArtPainter oldDelegate) => true;
}

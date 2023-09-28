import 'package:flutter/material.dart';

class PixelArtCanvas extends StatefulWidget {
  final BoxConstraints constraints;
  final int width, height;
  final Color? initialFillColor;
  final Color? Function() getColor;

  const PixelArtCanvas({
    super.key,
    required this.constraints,
    required this.width,
    required this.height,
    required this.initialFillColor,
    required this.getColor,
  });

  @override
  State<PixelArtCanvas> createState() => _PixelArtCanvasState();
}

class _PixelArtCanvasState extends State<PixelArtCanvas> {
  late final TransformationController transformationController;
  late PixelArtPainter _pixelPainter;

  @override
  void initState() {
    super.initState();

    final pixels = _generatePixels(widget.initialFillColor);
    _pixelPainter = PixelArtPainter(pixels: pixels);

    final initialTransform = Matrix4.identity()
      ..translate((widget.constraints.maxWidth - widget.width) / 2,
          (widget.constraints.maxHeight - widget.height) / 2);
    transformationController = TransformationController(initialTransform);
  }

  List<List<Color?>> _generatePixels(Color? color) {
    return List.generate(
      widget.height,
      (index) => List.filled(widget.width, color),
    );
  }

  (int x, int y) localToPixel(Offset localPosition) {
    var pixelPosition = localPosition;
    return (pixelPosition.dx.toInt(), pixelPosition.dy.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: transformationController,
      constrained: false,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      maxScale: 50,
      minScale: 0.1,
      child: GestureDetector(
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
        child: CustomPaint(
          willChange: true,
          isComplex: true,
          painter: _pixelPainter,
          size: Size(widget.width.toDouble(), widget.height.toDouble()),
        ),
      ),
    );
  }
}

class PixelArtPainter extends CustomPainter {
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
          Rect.fromLTWH(x.toDouble(), y.toDouble(), 1.0, 1.0),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(PixelArtPainter oldDelegate) => true;
}

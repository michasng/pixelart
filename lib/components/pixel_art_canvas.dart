import 'package:flutter/material.dart';

class PixelArtCanvas extends StatefulWidget {
  final BoxConstraints constraints;
  final int width, height;
  final Color? initialFillColor;
  final Color? Function() getColor;
  final bool showGrid;
  final int minScaleToShowGrid;

  const PixelArtCanvas({
    super.key,
    required this.constraints,
    required this.width,
    required this.height,
    required this.initialFillColor,
    required this.getColor,
    required this.showGrid,
    this.minScaleToShowGrid = 5,
  });

  @override
  State<PixelArtCanvas> createState() => _PixelArtCanvasState();
}

class _PixelArtCanvasState extends State<PixelArtCanvas> {
  late final TransformationController transformationController;
  late PixelArtPainter _pixelPainter;

  bool get showGrid {
    final scale = transformationController.value.getMaxScaleOnAxis();
    return widget.showGrid && scale >= widget.minScaleToShowGrid;
  }

  @override
  void initState() {
    super.initState();

    final pixels = _generatePixels(widget.initialFillColor);

    final initialTransform = Matrix4.identity()
      ..translate((widget.constraints.maxWidth - widget.width) / 2,
          (widget.constraints.maxHeight - widget.height) / 2);
    transformationController = TransformationController(initialTransform);

    _pixelPainter = PixelArtPainter(
      pixels: pixels,
      showGrid: showGrid,
    );
  }

  List<List<Color?>> _generatePixels(Color? color) {
    return List.generate(
      widget.height,
      (index) => List.filled(widget.width, color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: transformationController,
      constrained: false,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      maxScale: 100,
      minScale: 1,
      onInteractionEnd: (_) {
        setState(() {
          _pixelPainter = PixelArtPainter(
            pixels: _pixelPainter.pixels,
            showGrid: showGrid,
          );
        });
      },
      child: GestureDetector(
        onTapDown: (details) {
          var (x, y) = (details.localPosition.dx, details.localPosition.dy);
          setState(() {
            final pixels = _pixelPainter.pixels;
            pixels[y.toInt()][x.toInt()] = widget.getColor();
            setState(() {
              _pixelPainter = PixelArtPainter(
                pixels: pixels,
                showGrid: showGrid,
              );
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
  bool showGrid;
  Color gridColor;

  PixelArtPainter({
    required this.pixels,
    required this.showGrid,
    this.gridColor = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int y = 0; y < pixels.length; y++) {
      for (int x = 0; x < pixels[y].length; x++) {
        if (pixels[y][x] == null) continue;
        paint.color = pixels[y][x]!;
        paint.style = PaintingStyle.fill;
        canvas.drawRect(
          Rect.fromLTWH(x.toDouble(), y.toDouble(), 1.0, 1.0),
          paint,
        );
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
  bool shouldRepaint(PixelArtPainter oldDelegate) => true;
}

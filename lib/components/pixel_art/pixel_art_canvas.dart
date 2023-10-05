import 'package:flutter/material.dart';
import 'package:pixelart/components/unconstrained_interactive_viewer.dart';

class PixelArtCanvas extends StatefulWidget {
  final int width, height;
  final Color? initialFillColor;
  final Color? Function() getColor;
  final bool showGrid;
  final int minScaleToShowGrid;
  final double maxScale;

  const PixelArtCanvas({
    super.key,
    required this.width,
    required this.height,
    required this.initialFillColor,
    required this.getColor,
    required this.showGrid,
    this.minScaleToShowGrid = 5,
    this.maxScale = 100,
  });

  @override
  State<PixelArtCanvas> createState() => _PixelArtCanvasState();
}

class _PixelArtCanvasState extends State<PixelArtCanvas> {
  final _unconstrainedInteractiveViewerKey =
      GlobalKey<UnconstrainedInteractiveViewerState>();
  late PixelArtPainter _pixelPainter;

  Size get size => Size(widget.width.toDouble(), widget.height.toDouble());

  bool get showGrid {
    final scale = _unconstrainedInteractiveViewerKey.currentState?.scale;
    return widget.showGrid &&
        (scale == null || scale >= widget.minScaleToShowGrid);
  }

  @override
  void initState() {
    super.initState();

    final pixels = _generatePixels(widget.initialFillColor);
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

  void interactWithPixel(Offset localPosition) {
    var (x, y) = (localPosition.dx.toInt(), localPosition.dy.toInt());

    if (x < 0 || x >= widget.width || y < 0 || y >= widget.height) return;

    final pixels = _pixelPainter.pixels;
    pixels[y][x] = widget.getColor();
    updatePixelPainter();
  }

  void updatePixelPainter() {
    setState(() {
      _pixelPainter = PixelArtPainter(
        pixels: _pixelPainter.pixels,
        showGrid: showGrid,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return UnconstrainedInteractiveViewer(
      key: _unconstrainedInteractiveViewerKey,
      contentSize: size,
      minScale: 1,
      onInteractionEnd: (_) => updatePixelPainter(),
      child: GestureDetector(
        onTapDown: (details) => interactWithPixel(details.localPosition),
        onVerticalDragUpdate: (details) =>
            interactWithPixel(details.localPosition),
        onHorizontalDragUpdate: (details) =>
            interactWithPixel(details.localPosition),
        child: CustomPaint(
          willChange: true,
          isComplex: true,
          painter: _pixelPainter,
          size: size,
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
  bool shouldRepaint(PixelArtPainter oldDelegate) => true;
}

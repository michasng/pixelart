import 'package:flutter/material.dart';

class PixelArtCanvas extends StatefulWidget {
  final BoxConstraints constraints;
  final int width, height;
  final Color? initialFillColor;
  final Color? Function() getColor;
  final bool showGrid;
  final int minScaleToShowGrid;
  final double maxScale;

  const PixelArtCanvas({
    super.key,
    required this.constraints,
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
  late final TransformationController transformationController;
  late PixelArtPainter _pixelPainter;

  bool get showGrid {
    final scale = transformationController.value.getMaxScaleOnAxis();
    return widget.showGrid && scale >= widget.minScaleToShowGrid;
  }

  @override
  void initState() {
    super.initState();

    final initialTransform = createCenterTransform(
      widget.constraints,
      widget.width,
      widget.height,
    );
    transformationController = TransformationController(initialTransform);

    final pixels = _generatePixels(widget.initialFillColor);
    _pixelPainter = PixelArtPainter(
      pixels: pixels,
      showGrid: showGrid,
    );
  }

  Matrix4 createCenterTransform(
    BoxConstraints constraints,
    int width,
    int height,
  ) {
    final constrainsRatio = constraints.maxWidth / constraints.maxHeight;
    final canvasRatio = width / height;
    late final double initialScale;
    if (constrainsRatio < canvasRatio) {
      initialScale = constraints.maxWidth / width;
    } else {
      initialScale = constraints.maxHeight / height;
    }
    final emptyWidth = constraints.maxWidth - (width * initialScale);
    final emptyHeight = constraints.maxHeight - (height * initialScale);

    return Matrix4.identity()
      ..translate(emptyWidth / 2, emptyHeight / 2)
      ..scale(initialScale);
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

    setState(() {
      final pixels = _pixelPainter.pixels;
      pixels[y][x] = widget.getColor();
      setState(() {
        _pixelPainter = PixelArtPainter(
          pixels: pixels,
          showGrid: showGrid,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: transformationController,
      constrained: false,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      maxScale: widget.maxScale,
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
        onTapDown: (details) => interactWithPixel(details.localPosition),
        onVerticalDragUpdate: (details) =>
            interactWithPixel(details.localPosition),
        onHorizontalDragUpdate: (details) =>
            interactWithPixel(details.localPosition),
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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pixelart/components/canvas/canvas_painter.dart';
import 'package:pixelart/components/canvas/canvas_painter_state.dart';
import 'package:pixelart/components/canvas/events/canvas_draw_event.dart';
import 'package:pixelart/components/canvas/events/canvas_erase_event.dart';
import 'package:pixelart/components/canvas/events/canvas_event.dart';
import 'package:pixelart/components/unconstrained_interactive_viewer.dart';

class Canvas extends StatefulWidget {
  final int width, height;
  final Color? initialFillColor;
  final Color? selectedColor;
  final bool showGrid;
  final int minScaleToShowGrid;
  final double maxScale;
  final void Function({required bool canUndo, required bool canRedo})
      onHistoryChanged;

  const Canvas({
    super.key,
    required this.width,
    required this.height,
    required this.initialFillColor,
    required this.selectedColor,
    required this.showGrid,
    required this.onHistoryChanged,
    this.minScaleToShowGrid = 5,
    this.maxScale = 100,
  });

  @override
  State<Canvas> createState() => CanvasState();
}

class CanvasState extends State<Canvas> {
  final _unconstrainedInteractiveViewerKey =
      GlobalKey<UnconstrainedInteractiveViewerState>();
  late CanvasPainter _pixelPainter;

  final List<CanvasPainterState> _canvasStateHistory = [];
  final List<CanvasEvent> _eventHistory = [];
  final List<CanvasEvent> _undoneEvents = [];

  Size get size => Size(widget.width.toDouble(), widget.height.toDouble());

  bool get showGrid {
    final scale = _unconstrainedInteractiveViewerKey.currentState?.scale;
    return widget.showGrid &&
        (scale == null || scale >= widget.minScaleToShowGrid);
  }

  bool get canUndo => _eventHistory.isNotEmpty;
  bool get canRedo => _undoneEvents.isNotEmpty;

  @override
  void initState() {
    super.initState();

    final pixels = _generatePixels(widget.initialFillColor);
    _pixelPainter = CanvasPainter(
      canvasState: CanvasPainterState(pixels: pixels),
      showGrid: showGrid,
    );
  }

  List<List<Color?>> _generatePixels(Color? color) {
    return List.generate(
      widget.height,
      (index) => List.filled(widget.width, color),
    );
  }

  bool isInCanvasBounds(Point<int> point) {
    return point.x >= 0 &&
        point.x < widget.width &&
        point.y >= 0 &&
        point.y < widget.height;
  }

  void interactWithPixel(Offset localPosition) {
    final position = Point(localPosition.dx.toInt(), localPosition.dy.toInt());
    if (!isInCanvasBounds(position)) return;

    final currentColor =
        _pixelPainter.canvasState.pixels[position.y][position.x];
    final selectedColor = widget.selectedColor;
    if (currentColor == selectedColor) return;
    if (selectedColor == null) {
      dispatchEvent(CanvasEraseEvent(position: position));
    } else {
      dispatchEvent(CanvasDrawEvent(position: position, color: selectedColor));
    }
  }

  void dispatchEvent(CanvasEvent event, [bool clearUndoneEvents = true]) {
    if (clearUndoneEvents) _undoneEvents.clear();

    _canvasStateHistory.add(_pixelPainter.canvasState);
    _eventHistory.add(event);

    final canvasStateCopy = _pixelPainter.canvasState.deepCopy();
    event.apply(canvasStateCopy);
    _updatePixelPainter(canvasStateCopy);
    _historyChanged();
  }

  void undo() {
    if (!canUndo) return;

    final event = _eventHistory.removeLast();
    _undoneEvents.add(event);

    final canvasState = _canvasStateHistory.removeLast();
    _updatePixelPainter(canvasState);
    _historyChanged();
  }

  void redo() {
    if (!canRedo) return;

    final event = _undoneEvents.removeLast();
    dispatchEvent(event, false);
  }

  void _historyChanged() {
    widget.onHistoryChanged(
      canUndo: canUndo,
      canRedo: canRedo,
    );
  }

  void _updatePixelPainter([CanvasPainterState? updatedCanvasState]) {
    setState(() {
      _pixelPainter = CanvasPainter(
        canvasState: updatedCanvasState ?? _pixelPainter.canvasState,
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
      onInteractionEnd: (_) => _updatePixelPainter(),
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

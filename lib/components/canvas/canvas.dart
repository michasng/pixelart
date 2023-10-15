import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pixelart/components/canvas/canvas_change.dart';
import 'package:pixelart/components/canvas/canvas_history_item.dart';
import 'package:pixelart/components/canvas/canvas_painter.dart';
import 'package:pixelart/components/canvas/tools/canvas_draw_tool.dart';
import 'package:pixelart/components/canvas/tools/canvas_erase_tool.dart';
import 'package:pixelart/components/canvas/tools/canvas_tool.dart';
import 'package:pixelart/components/canvas/tools/canvas_tool_context.dart';
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
  late CanvasPainter _painter;

  final List<CanvasHistoryItem> _history = [];
  final List<CanvasHistoryItem> _undoneHistory = [];

  Size get size => Size(widget.width.toDouble(), widget.height.toDouble());

  bool get showGrid {
    final scale = _unconstrainedInteractiveViewerKey.currentState?.scale;
    return widget.showGrid &&
        (scale == null || scale >= widget.minScaleToShowGrid);
  }

  bool get canUndo => _history.isNotEmpty;
  bool get canRedo => _undoneHistory.isNotEmpty;

  @override
  void initState() {
    super.initState();

    final pixels = _generatePixels(widget.initialFillColor);
    _painter = CanvasPainter(
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

  bool isInCanvasBounds(Point<int> point) {
    return point.x >= 0 &&
        point.x < widget.width &&
        point.y >= 0 &&
        point.y < widget.height;
  }

  void interactWithPixel(Offset localPosition) {
    final position = Point(localPosition.dx.toInt(), localPosition.dy.toInt());
    if (!isInCanvasBounds(position)) return;

    final currentColor = _painter.pixels[position.y][position.x];
    final selectedColor = widget.selectedColor;
    if (currentColor == selectedColor) return;

    final CanvasTool tool;
    if (selectedColor == null) {
      tool = CanvasEraseTool();
    } else {
      tool = CanvasDrawTool();
    }

    final toolContext = CanvasToolContext(
      canvasPainter: _painter,
      selectedColor: selectedColor,
      position: position,
    );
    final change = tool.use(toolContext);
    _undoneHistory.clear();
    applyChange(change);
  }

  void applyChange(CanvasChange change) {
    _history.add(CanvasHistoryItem(
      change: change,
      reverseChange: change.createReverseChange(_painter),
    ));

    final updatedPainter = change.apply(_painter);
    setState(() {
      _painter = updatedPainter;
    });
    _historyChanged();
  }

  void undo() {
    if (!canUndo) return;

    final historyItem = _history.removeLast();
    _undoneHistory.add(historyItem);

    final updatedPainter = historyItem.reverseChange.apply(_painter);
    setState(() {
      _painter = updatedPainter;
    });
    _historyChanged();
  }

  void redo() {
    if (!canRedo) return;

    final historyItem = _undoneHistory.removeLast();
    applyChange(historyItem.change);
  }

  void _historyChanged() {
    widget.onHistoryChanged(
      canUndo: canUndo,
      canRedo: canRedo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return UnconstrainedInteractiveViewer(
      key: _unconstrainedInteractiveViewerKey,
      contentSize: size,
      minScale: 1,
      onInteractionEnd: (_) => setState(() {
        _painter = CanvasPainter(
          pixels: _painter.pixels,
          showGrid: showGrid,
        );
      }),
      child: GestureDetector(
        onTapDown: (details) => interactWithPixel(details.localPosition),
        onVerticalDragUpdate: (details) =>
            interactWithPixel(details.localPosition),
        onHorizontalDragUpdate: (details) =>
            interactWithPixel(details.localPosition),
        child: CustomPaint(
          willChange: true,
          isComplex: true,
          painter: _painter,
          size: size,
        ),
      ),
    );
  }
}

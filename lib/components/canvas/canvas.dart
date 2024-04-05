import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pixelart/components/canvas/canvas_painter.dart';
import 'package:pixelart/components/canvas/canvas_settings.dart';
import 'package:pixelart/components/canvas/image_change.dart';
import 'package:pixelart/components/canvas/random_access_image.dart';
import 'package:pixelart/components/canvas/tools/tool.dart';
import 'package:pixelart/components/canvas/tools/use_tool_arguments.dart';
import 'package:pixelart/components/unconstrained_interactive_viewer.dart';

class Canvas extends StatefulWidget {
  final RandomAccessImage initialImage;
  final CanvasSettings initialSettings;
  final void Function({required bool canUndo, required bool canRedo})
      onHistoryChanged;

  const Canvas({
    super.key,
    required this.initialImage,
    required this.initialSettings,
    required this.onHistoryChanged,
  });

  @override
  State<Canvas> createState() => CanvasState();
}

typedef ChangeHistoryItem = ({ImageChange change, ImageChange reverseChange});

class CanvasState extends State<Canvas> {
  final _unconstrainedInteractiveViewerKey =
      GlobalKey<UnconstrainedInteractiveViewerState>();
  late CanvasPainter _painter;

  Offset? _pointerOffset;
  ChangeHistoryItem? _incompleteHistoryItem;
  final List<ChangeHistoryItem> _history = [];
  final List<ChangeHistoryItem> _undoneHistory = [];

  bool get _showGridAfterInteraction {
    final scale = _unconstrainedInteractiveViewerKey.currentState?.scale;
    return _painter.settings.showGrid &&
        (scale == null || scale >= _painter.settings.minScaleToShowGrid);
  }

  @override
  void initState() {
    super.initState();

    _painter = CanvasPainter(
      image: widget.initialImage,
      settings: widget.initialSettings,
    );
  }

  bool get canUndo => _history.isNotEmpty;
  bool get canRedo => _undoneHistory.isNotEmpty;

  CanvasSettings get settings => _painter.settings;
  set settings(CanvasSettings value) =>
      setState(() => _painter = _painter.copyWith(settings: value));

  void undo() {
    if (!canUndo) return;

    final historyItem = _history.removeLast();
    _undoneHistory.add(historyItem);

    setState(() {
      _painter = _painter.copyWith(
        image: _painter.image.copyWithChange(historyItem.reverseChange),
      );
    });
    _historyChanged();
  }

  void redo() {
    if (!canRedo) return;

    final historyItem = _undoneHistory.removeLast();

    setState(() {
      _painter = _painter.copyWith(
        image: _painter.image.copyWithChange(historyItem.change),
      );

      _history.add(historyItem);
    });

    _historyChanged();
  }

  void clearIncompleteHistoryItem() {
    final incompleteHistoryItem = _incompleteHistoryItem;
    if (incompleteHistoryItem == null) return;

    setState(() {
      _painter = _painter.copyWith(
        image:
            _painter.image.copyWithChange(incompleteHistoryItem.reverseChange),
      );
      _incompleteHistoryItem = null;
    });
  }

  void _historyChanged() {
    widget.onHistoryChanged(
      canUndo: canUndo,
      canRedo: canRedo,
    );
  }

  ChangeHistoryItem _buildChangeHistoryItem(ImageChange change) => (
        change: change,
        reverseChange: ImageChange(
          pixelChanges: {
            for (var position in change.pixelChanges.keys)
              position: _painter.image.pixels[position.y][position.x],
          },
        ),
      );

  UseToolArguments _buildToolArguments(Offset pointerOffset) {
    final pointerPosition = Point(
      pointerOffset.dx.toInt(),
      pointerOffset.dy.toInt(),
    );

    return UseToolArguments(
      settings: _painter.settings,
      image: _painter.image,
      incompleteChange: _incompleteHistoryItem?.change,
      cursorPosition: pointerPosition,
    );
  }

  void _handleChange(CompletableImageChange? completableChange) {
    clearIncompleteHistoryItem();
    if (completableChange == null) return;
    final historyItem = _buildChangeHistoryItem(completableChange.change);

    setState(() {
      _undoneHistory.clear();
      _painter = _painter.copyWith(
        image: _painter.image.copyWithChange(historyItem.change),
      );

      if (completableChange.completed) {
        _history.add(historyItem);
      } else {
        _incompleteHistoryItem = historyItem;
      }
    });

    _historyChanged();
  }

  void _onPointerDown(Offset pointerOffset) {
    final toolArguments = _buildToolArguments(pointerOffset);
    final completableChange =
        _painter.settings.tool.onPointerDown(toolArguments);
    _handleChange(completableChange);
  }

  void _onPointerMove(Offset pointerOffset) {
    final toolArguments = _buildToolArguments(pointerOffset);
    final completableChange =
        _painter.settings.tool.onPointerMove(toolArguments);
    _handleChange(completableChange);
  }

  void _onPointerUp(Offset pointerOffset) {
    final toolArguments = _buildToolArguments(pointerOffset);
    final completableChange = _painter.settings.tool.onPointerUp(toolArguments);
    _handleChange(completableChange);
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = Size(
      _painter.image.width.toDouble(),
      _painter.image.height.toDouble(),
    );

    return UnconstrainedInteractiveViewer(
      key: _unconstrainedInteractiveViewerKey,
      contentSize: imageSize,
      minScale: 1,
      onInteractionEnd: (_) => setState(() {
        _painter = _painter.copyWith(
          settings: _painter.settings.copyWith(
            showGrid: _showGridAfterInteraction,
          ),
        );
      }),
      child: GestureDetector(
        onTapDown: (details) => _onPointerDown(details.localPosition),
        onPanDown: (details) => _onPointerDown(details.localPosition),
        onTapUp: (details) => _onPointerUp(details.localPosition),
        onVerticalDragUpdate: (details) {
          _onPointerMove(details.localPosition);
          setState(() => _pointerOffset = details.localPosition);
        },
        onHorizontalDragUpdate: (details) {
          _onPointerMove(details.localPosition);
          setState(() => _pointerOffset = details.localPosition);
        },
        onVerticalDragStart: (details) {
          _onPointerDown(details.localPosition);
          setState(() => _pointerOffset = details.localPosition);
        },
        onVerticalDragEnd: (details) => _onPointerUp(_pointerOffset!),
        onHorizontalDragEnd: (details) => _onPointerUp(_pointerOffset!),
        child: CustomPaint(
          willChange: true,
          isComplex: true,
          painter: _painter,
          size: imageSize,
        ),
      ),
    );
  }
}

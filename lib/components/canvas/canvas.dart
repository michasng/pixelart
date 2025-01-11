import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pixelart/components/canvas/canvas_painter.dart';
import 'package:pixelart/components/canvas/canvas_settings.dart';
import 'package:pixelart/components/canvas/image_change.dart';
import 'package:pixelart/components/canvas/random_access_image.dart';
import 'package:pixelart/components/canvas/tools/tool.dart';
import 'package:pixelart/components/canvas/tools/use_tool_arguments.dart';
import 'package:pixelart/components/interaction/interactive_container.dart';

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
  late CanvasPainter _painter;

  ChangeHistoryItem? _incompleteHistoryItem;
  final List<ChangeHistoryItem> _history = [];
  final List<ChangeHistoryItem> _undoneHistory = [];

  @override
  void initState() {
    super.initState();

    _painter = CanvasPainter(
      image: widget.initialImage,
      settings: widget.initialSettings,
    );
  }

  set image(RandomAccessImage value) {
    setState(() {
      _painter = CanvasPainter(
        image: value,
        settings: widget.initialSettings,
      );
    });
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

  @override
  Widget build(BuildContext context) {
    final imageSize = Size(
      _painter.image.width.toDouble(),
      _painter.image.height.toDouble(),
    );

    return InteractiveContainer(
      backgroundColor: Colors.grey,
      childSize: imageSize,
      onPointerDown: (event) {
        final toolArguments = _buildToolArguments(event.localPosition);
        final completableChange =
            _painter.settings.tool.onPointerDown(toolArguments);
        _handleChange(completableChange);
      },
      onPointerMove: (event) {
        final toolArguments = _buildToolArguments(event.localPosition);
        final completableChange =
            _painter.settings.tool.onPointerMove(toolArguments);
        _handleChange(completableChange);
      },
      onPointerUp: (event) {
        final toolArguments = _buildToolArguments(event.localPosition);
        final completableChange =
            _painter.settings.tool.onPointerUp(toolArguments);
        _handleChange(completableChange);
      },
      onScaleChanged: (scale) => setState(() {
        _painter = _painter.copyWith(
          settings: _painter.settings.copyWith(
            showGrid: _painter.settings.showGrid &&
                scale >= _painter.settings.minScaleToShowGrid,
          ),
        );
      }),
      child: CustomPaint(
        willChange: true,
        isComplex: true,
        painter: _painter,
        size: imageSize,
      ),
    );
  }
}

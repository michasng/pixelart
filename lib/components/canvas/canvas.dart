import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:pixelart/components/canvas/canvas_painter.dart';
import 'package:pixelart/components/canvas/canvas_settings.dart';
import 'package:pixelart/components/canvas/image_change.dart';
import 'package:pixelart/components/interaction/interactive_container.dart';
import 'package:pixelart/components/offset_extension.dart';

class Canvas extends StatefulWidget {
  final img.Image initialImage;
  final CanvasSettings settings;
  final ValueChanged<CanvasSettings> onChangeSettings;
  final void Function({required bool canUndo, required bool canRedo})
      onHistoryChanged;

  const Canvas({
    super.key,
    required this.initialImage,
    required this.settings,
    required this.onChangeSettings,
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
      getSettings: () => widget.settings,
    );
  }

  ImageChange? get incompleteChange => _incompleteHistoryItem?.change;

  img.Image get image => _painter.image;

  set image(img.Image value) {
    setState(() {
      _painter = _painter.copyWith(image: value);
    });
  }

  bool get canUndo => _history.isNotEmpty;
  bool get canRedo => _undoneHistory.isNotEmpty;

  CanvasSettings get settings => widget.settings;

  void undo() {
    if (!canUndo) return;

    final historyItem = _history.removeLast();
    _undoneHistory.add(historyItem);

    setState(() {
      _painter = _painter.copyWith(
        image: historyItem.reverseChange.apply(_painter.image),
      );
    });
    _historyChanged();
  }

  void redo() {
    if (!canRedo) return;

    final historyItem = _undoneHistory.removeLast();

    setState(() {
      _painter = _painter.copyWith(
        image: historyItem.change.apply(_painter.image),
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
        image: incompleteHistoryItem.reverseChange.apply(_painter.image),
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
              position: _painter.image.getPixel(position.x, position.y),
          },
        ),
      );

  void handleChange(ImageChange change, {required bool completed}) {
    clearIncompleteHistoryItem();
    final historyItem = _buildChangeHistoryItem(change);

    setState(() {
      _undoneHistory.clear();
      _painter = _painter.copyWith(
        image: historyItem.change.apply(_painter.image),
      );

      if (completed) {
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
        settings.tool.onPointerDown(
          event.localPosition.toPointInt(),
          this,
        );
      },
      onPointerMove: (event) {
        settings.tool.onPointerMove(
          event.localPosition.toPointInt(),
          this,
        );
      },
      onPointerUp: (event) {
        settings.tool.onPointerUp(
          event.localPosition.toPointInt(),
          this,
        );
      },
      onScaleChanged: (scale) => setState(() {
        _painter = _painter.copyWith(
          scale: scale,
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

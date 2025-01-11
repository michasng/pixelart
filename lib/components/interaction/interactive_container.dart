import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixelart/components/interaction/interaction_detector.dart';

class InteractiveContainer extends StatefulWidget {
  final Size childSize;
  final Widget child;
  final Color? backgroundColor;

  final Offset? initialOffset;
  final double? initialScale;

  final PointerHoverEventListener? onPointerHover;
  final PointerDownEventListener? onPointerDown;
  final PointerMoveEventListener? onPointerMove;
  final PointerUpEventListener? onPointerUp;

  final ValueChanged<Offset>? onOffsetChanged;
  final ValueChanged<double>? onScaleChanged;

  const InteractiveContainer({
    super.key,
    required this.childSize,
    required this.child,
    this.backgroundColor,
    this.initialOffset,
    this.initialScale,
    this.onPointerHover,
    this.onPointerDown,
    this.onPointerMove,
    this.onPointerUp,
    this.onOffsetChanged,
    this.onScaleChanged,
  });

  @override
  State<InteractiveContainer> createState() => _InteractiveContainerState();
}

class _InteractiveContainerState extends State<InteractiveContainer> {
  final double minScale = 1.0;
  late final double maxScale;

  late Offset _offset;
  Offset get offset => _offset;
  set offset(Offset value) {
    _offset = value;
    widget.onOffsetChanged?.call(_offset);
  }

  late double _scale;
  double get scale => _scale;
  set scale(double value) {
    _scale = value;
    widget.onScaleChanged?.call(_scale);
  }

  @override
  void initState() {
    super.initState();
    _offset = widget.initialOffset ?? Offset.zero;
    _scale = widget.initialScale ?? 1.0;

    // The RenderObject is only available after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = context.findRenderObject() as RenderBox;
      final parentRatio = box.size.aspectRatio;
      final childRatio = widget.childSize.aspectRatio;
      final tightFitScale = parentRatio < childRatio
          ? box.size.width / widget.childSize.width
          : box.size.height / widget.childSize.height;
      maxScale = tightFitScale;

      if (widget.initialScale == null) {
        setState(() {
          scale = tightFitScale;
        });
      }
    });
  }

  Matrix4 get transform => Matrix4.identity()
    ..translate(_offset.dx, _offset.dy)
    ..translate(widget.childSize.width / 2, widget.childSize.height / 2)
    ..scale(_scale)
    ..translate(-widget.childSize.width / 2, -widget.childSize.height / 2);

  Matrix4 get parentToChildTransform {
    final box = context.findRenderObject() as RenderBox;
    final centerOffset = (box.size / 2 - widget.childSize / 2) as Offset;

    final decenterTransform = Matrix4.identity()
      ..translate(-centerOffset.dx, -centerOffset.dy);

    final invertedTransform = Matrix4.inverted(transform);

    return invertedTransform * decenterTransform;
  }

  @override
  Widget build(BuildContext context) {
    return InteractionDetector(
      onPan: (delta) {
        setState(() {
          offset += delta;
        });
      },
      onZoom: (delta) {
        setState(() {
          scale = max(min(_scale + _scale * delta, maxScale), minScale);
        });
      },
      onPointerHover: (event) {
        widget.onPointerHover
            ?.call(event.transformed(parentToChildTransform * event.transform));
      },
      onPointerDown: (event) {
        if (event.buttons == kTertiaryButton) return;

        widget.onPointerDown
            ?.call(event.transformed(parentToChildTransform * event.transform));
      },
      onPointerMove: (event) {
        if (event.buttons == kTertiaryButton) {
          setState(() {
            offset += event.delta;
          });
          return;
        }

        widget.onPointerMove
            ?.call(event.transformed(parentToChildTransform * event.transform));
      },
      onPointerUp: (event) {
        if (event.buttons == kTertiaryButton) return;

        widget.onPointerUp
            ?.call(event.transformed(parentToChildTransform * event.transform));
      },
      child: Container(
        color: widget.backgroundColor,
        alignment: Alignment.center,
        child: Transform(
          transform: transform,
          child: SizedBox(
            width: widget.childSize.width,
            height: widget.childSize.height,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

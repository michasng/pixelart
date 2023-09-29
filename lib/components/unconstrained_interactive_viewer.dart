import 'package:flutter/material.dart';

class UnconstrainedInteractiveViewer extends StatefulWidget {
  final Size contentSize;
  final Widget child;
  final double minScale;
  final double maxScale;
  final void Function(ScaleEndDetails)? onInteractionEnd;

  const UnconstrainedInteractiveViewer({
    super.key,
    required this.contentSize,
    required this.child,
    this.minScale = 0.01,
    this.maxScale = 256,
    this.onInteractionEnd,
  });

  @override
  State<UnconstrainedInteractiveViewer> createState() =>
      UnconstrainedInteractiveViewerState();
}

class UnconstrainedInteractiveViewerState
    extends State<UnconstrainedInteractiveViewer> {
  final _innerKey = GlobalKey<_UnconstrainedInteractiveViewerState>();

  double? get scale => _innerKey.currentState?.scale;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => _UnconstrainedInteractiveViewer(
        key: _innerKey,
        constraints: constraints,
        contentSize: widget.contentSize,
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        onInteractionEnd: widget.onInteractionEnd,
        child: widget.child,
      ),
    );
  }
}

class _UnconstrainedInteractiveViewer extends StatefulWidget {
  final BoxConstraints constraints;
  final Size contentSize;
  final Widget child;
  final double minScale;
  final double maxScale;
  final void Function(ScaleEndDetails)? onInteractionEnd;

  const _UnconstrainedInteractiveViewer({
    super.key,
    required this.constraints,
    required this.contentSize,
    required this.child,
    required this.minScale,
    required this.maxScale,
    required this.onInteractionEnd,
  });

  @override
  State<_UnconstrainedInteractiveViewer> createState() =>
      _UnconstrainedInteractiveViewerState();
}

class _UnconstrainedInteractiveViewerState
    extends State<_UnconstrainedInteractiveViewer> {
  late final TransformationController _transformationController;

  double get scale => _transformationController.value.getMaxScaleOnAxis();

  @override
  void initState() {
    super.initState();

    final initialTransform = createCenterTransform();
    _transformationController = TransformationController(initialTransform);
  }

  Matrix4 createCenterTransform() {
    final constraints = widget.constraints;
    final contentSize = widget.contentSize;

    final constrainsRatio = constraints.maxWidth / constraints.maxHeight;
    final contentRatio = contentSize.width / contentSize.height;
    late final double initialScale;
    if (constrainsRatio < contentRatio) {
      initialScale = constraints.maxWidth / contentSize.width;
    } else {
      initialScale = constraints.maxHeight / contentSize.height;
    }
    final emptyWidth =
        constraints.maxWidth - (contentSize.width * initialScale);
    final emptyHeight =
        constraints.maxHeight - (contentSize.height * initialScale);

    return Matrix4.identity()
      ..translate(emptyWidth / 2, emptyHeight / 2)
      ..scale(initialScale);
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformationController,
      constrained: false,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      minScale: widget.minScale,
      maxScale: widget.maxScale,
      onInteractionEnd: widget.onInteractionEnd,
      child: widget.child,
    );
  }
}

import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:pixelart/components/canvas/tools/tool.dart';

@immutable
class CanvasSettings {
  final Tool tool;
  final Color primaryColor;
  final bool showGrid;
  final Color gridColor;
  final int minScaleToShowGrid;
  final double maxScale;

  const CanvasSettings({
    required this.tool,
    required this.primaryColor,
    required this.showGrid,
    this.gridColor = const Color.fromARGB(255, 0, 0, 0),
    this.minScaleToShowGrid = 5,
    this.maxScale = 100,
  });

  CanvasSettings copyWith({
    Tool? tool,
    Color? primaryColor,
    bool? showGrid,
    Color? gridColor,
    int? minScaleToShowGrid,
    double? maxScale,
  }) =>
      CanvasSettings(
        tool: tool ?? this.tool,
        primaryColor: primaryColor ?? this.primaryColor,
        showGrid: showGrid ?? this.showGrid,
        gridColor: gridColor ?? this.gridColor,
        minScaleToShowGrid: minScaleToShowGrid ?? this.minScaleToShowGrid,
        maxScale: maxScale ?? this.maxScale,
      );
}

import 'dart:math';
import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:pixelart/components/canvas/canvas_settings.dart';
import 'package:pixelart/components/canvas/image_change.dart';
import 'package:pixelart/components/canvas/random_access_image.dart';

@immutable
class UseToolArguments {
  final CanvasSettings settings;
  final RandomAccessImage image;
  final ImageChange? incompleteChange;
  final Point<int> cursorPosition;

  const UseToolArguments({
    required this.settings,
    required this.image,
    required this.incompleteChange,
    required this.cursorPosition,
  });

  Color? get effectiveColor => settings.primaryColor;
}

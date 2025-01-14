import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:meta/meta.dart';
import 'package:pixelart/components/canvas/canvas_settings.dart';
import 'package:pixelart/components/canvas/image_change.dart';

@immutable
class UseToolArguments {
  final CanvasSettings settings;
  final img.Image image;
  final ImageChange? incompleteChange;
  final Point<int> cursorPosition;

  const UseToolArguments({
    required this.settings,
    required this.image,
    required this.incompleteChange,
    required this.cursorPosition,
  });

  img.Color? get effectiveColor => settings.primaryColor;
}

import 'dart:math';

import 'package:pixelart/components/asset_icon_image.dart';
import 'package:pixelart/components/canvas/canvas.dart';
import 'package:pixelart/components/canvas/tools/tool.dart';
import 'package:pixelart/components/image_extension.dart';

class EyedropperTool implements Tool {
  const EyedropperTool();

  @override
  AssetIcon get assetIcon => AssetIcon.eyedropper;

  @override
  void onPointerDown(Point<int> pointerPosition, CanvasState canvas) {}

  @override
  void onPointerMove(Point<int> pointerPosition, CanvasState canvas) {}

  @override
  void onPointerUp(Point<int> pointerPosition, CanvasState canvas) {
    if (!canvas.image.containsPoint(pointerPosition)) return;

    final pixel = canvas.image.getPixel(pointerPosition.x, pointerPosition.y);
    canvas.widget.onChangeSettings(
      canvas.settings.copyWith(primaryColor: pixel),
    );
  }
}

import 'dart:math';

import 'package:pixelart/components/asset_icon_image.dart';
import 'package:pixelart/components/canvas/canvas.dart';
import 'package:pixelart/components/canvas/image_change.dart';
import 'package:pixelart/components/canvas/tools/tool.dart';
import 'package:pixelart/components/image_extension.dart';

class PencilTool implements Tool {
  const PencilTool();

  @override
  AssetIcon get assetIcon => AssetIcon.pencil;

  @override
  void onPointerDown(Point<int> pointerPosition, CanvasState canvas) {
    if (!canvas.image.containsPoint(pointerPosition)) return;

    final change = ImageChange(
      pixelChanges: {
        pointerPosition: canvas.settings.primaryColor,
      },
    );

    canvas.handleChange(
      change,
      completed: false,
    );
  }

  @override
  void onPointerMove(Point<int> pointerPosition, CanvasState canvas) {
    var change = canvas.incompleteChange;
    if (change == null) return;

    if (canvas.image.containsPoint(pointerPosition)) {
      change = change.copyWith(pixelChanges: {
        ...change.pixelChanges,
        pointerPosition: canvas.settings.primaryColor,
      });
    }

    canvas.handleChange(
      change,
      completed: false,
    );
  }

  @override
  void onPointerUp(Point<int> pointerPosition, CanvasState canvas) {
    var change = canvas.incompleteChange;
    if (change == null) return;

    if (canvas.image.containsPoint(pointerPosition)) {
      change = change.copyWith(pixelChanges: {
        ...change.pixelChanges,
        pointerPosition: canvas.settings.primaryColor,
      });
    }

    canvas.handleChange(
      change,
      completed: true,
    );
  }
}

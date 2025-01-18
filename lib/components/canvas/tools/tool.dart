import 'dart:math';

import 'package:pixelart/components/asset_icon_image.dart';
import 'package:pixelart/components/canvas/canvas.dart';

abstract interface class Tool {
  AssetIcon get assetIcon;

  void onPointerDown(Point<int> pointerPosition, CanvasState canvas);

  void onPointerMove(Point<int> pointerPosition, CanvasState canvas);

  void onPointerUp(Point<int> pointerPosition, CanvasState canvas);
}

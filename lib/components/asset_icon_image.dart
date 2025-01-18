import 'package:flutter/material.dart';

enum AssetIcon {
  eraser("eraser.png"),
  eyedropper("eyedropper.png"),
  gradient("gradient.png"),
  hand("hand.png"),
  line("line.png"),
  move("move.png"),
  ovalFilled("oval_filled.png"),
  oval("oval.png"),
  paintBucket("paint_bucket.png"),
  pencil("pencil.png"),
  rectangleFilled("rectangle_filled.png"),
  rectangle("rectangle.png"),
  redo("redo.png"),
  spray("spray.png"),
  undo("undo.png"),
  zoom("zoom.png");

  static const _physicalSize = 16;
  final String _fileName;

  const AssetIcon(this._fileName);
}

class AssetIconImage extends StatelessWidget {
  final AssetIcon assetIcon;
  final int scale;
  final Color? color;
  final BlendMode? colorBlendMode;

  const AssetIconImage({
    super.key,
    required this.assetIcon,
    this.scale = 2,
    this.color,
    this.colorBlendMode,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final logicalSize = AssetIcon._physicalSize / mediaQuery.devicePixelRatio;

    return Image.asset(
      "assets/icons/${assetIcon._fileName}",
      width: logicalSize * scale,
      height: logicalSize * scale,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.none,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }
}

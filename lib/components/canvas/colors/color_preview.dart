import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:pixelart/components/canvas/colors/colors.dart';

class ColorPreview extends StatelessWidget {
  final img.Color color;

  const ColorPreview({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      color: toUiColor(color),
    );
  }
}

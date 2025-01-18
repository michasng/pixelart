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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 4),
          color: toUiColor(color),
        ),
      ),
    );
  }
}

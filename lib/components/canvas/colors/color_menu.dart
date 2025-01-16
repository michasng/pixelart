import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:pixelart/components/canvas/colors.dart';

class ColorMenu extends StatelessWidget {
  final List<img.Color> colors;
  final ValueChanged<img.Color> onSelect;
  final double minItemSize;

  const ColorMenu({
    super.key,
    required this.colors,
    required this.onSelect,
    this.minItemSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GridView.count(
        crossAxisCount: (constraints.maxWidth / minItemSize).floor(),
        shrinkWrap: true,
        children: [
          for (var color in colors)
            Material(
              color: toUiColor(color),
              child: InkWell(
                onTap: () => onSelect(color),
              ),
            ),
        ],
      ),
    );
  }
}

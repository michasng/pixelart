import 'package:flutter/material.dart';
import 'package:pixelart/components/canvas/tools/draw_tool.dart';
import 'package:pixelart/components/canvas/tools/erase_tool.dart';
import 'package:pixelart/components/canvas/tools/tool.dart';

typedef ToolDefinition = ({Tool tool, String imagePath});

class ToolBar extends StatelessWidget {
  static const _imageSize = 16;
  static const _imageScale = 2;

  final Widget child;
  final ValueChanged<Tool> onToolSelected;
  final List<ToolDefinition> toolDefinitions;

  const ToolBar({
    super.key,
    required this.child,
    required this.onToolSelected,
  }) : toolDefinitions = const [
          (imagePath: "assets/icons/pencil.png", tool: DrawTool()),
          (imagePath: "assets/icons/eraser.png", tool: EraseTool()),
        ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final logicalImageSize =
        _imageSize / mediaQuery.devicePixelRatio * _imageScale;

    return Row(
      children: [
        Expanded(child: child),
        Padding(
          padding: EdgeInsets.all(2),
          child: Column(
            children: [
              for (final definition in toolDefinitions)
                IconButton(
                  onPressed: () => onToolSelected(definition.tool),
                  icon: Image.asset(
                    definition.imagePath,
                    width: logicalImageSize,
                    height: logicalImageSize,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.none,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pixelart/components/asset_icon_image.dart';
import 'package:pixelart/components/canvas/tools/draw_tool.dart';
import 'package:pixelart/components/canvas/tools/erase_tool.dart';
import 'package:pixelart/components/canvas/tools/tool.dart';

typedef ToolDefinition = ({Tool tool, AssetIcon assetIcon});

class ToolBar extends StatelessWidget {
  final Widget child;
  final ValueChanged<Tool> onToolSelected;
  final List<ToolDefinition> toolDefinitions;

  const ToolBar({
    super.key,
    required this.child,
    required this.onToolSelected,
  }) : toolDefinitions = const [
          (tool: DrawTool(), assetIcon: AssetIcon.pencil),
          (tool: EraseTool(), assetIcon: AssetIcon.eraser),
        ];

  @override
  Widget build(BuildContext context) {
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
                  icon: AssetIconImage(
                    assetIcon: definition.assetIcon,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

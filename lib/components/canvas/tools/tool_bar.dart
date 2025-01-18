import 'package:flutter/material.dart';
import 'package:pixelart/components/asset_icon_image.dart';
import 'package:pixelart/components/canvas/tools/draw_tool.dart';
import 'package:pixelart/components/canvas/tools/erase_tool.dart';
import 'package:pixelart/components/canvas/tools/tool.dart';

class ToolBar extends StatelessWidget {
  final Widget child;
  final ValueChanged<Tool> onToolSelected;
  final List<Tool> tools;

  const ToolBar({
    super.key,
    required this.child,
    required this.onToolSelected,
  }) : tools = const [DrawTool(), EraseTool()];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: child),
        Padding(
          padding: EdgeInsets.all(2),
          child: Column(
            children: [
              for (final tool in tools)
                IconButton(
                  onPressed: () => onToolSelected(tool),
                  icon: AssetIconImage(
                    assetIcon: tool.assetIcon,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

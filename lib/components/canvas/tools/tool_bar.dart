import 'package:flutter/material.dart';
import 'package:pixelart/components/asset_icon_image.dart';
import 'package:pixelart/components/canvas/tools/tool.dart';

class ToolBar extends StatelessWidget {
  final Widget child;
  final Tool? activeTool;
  final ValueChanged<Tool> onToolSelected;
  final List<Tool> tools;

  const ToolBar({
    super.key,
    required this.child,
    required this.activeTool,
    required this.onToolSelected,
    required this.tools,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(child: child),
        Container(
          color: theme.primaryColor,
          padding: EdgeInsets.all(2),
          child: Column(
            children: [
              for (final tool in tools)
                IconButton(
                  onPressed: () => onToolSelected(tool),
                  icon: AssetIconImage(
                    assetIcon: tool.assetIcon,
                  ),
                  style: tool == activeTool
                      ? IconButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                        )
                      : null,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

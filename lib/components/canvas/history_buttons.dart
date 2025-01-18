import 'package:flutter/material.dart';
import 'package:pixelart/components/asset_icon_image.dart';

class HistoryButtons extends StatelessWidget {
  final VoidCallback? onUndo, onRedo;

  const HistoryButtons({
    super.key,
    required this.onUndo,
    required this.onRedo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onUndo,
            icon: AssetIconImage(
              assetIcon: AssetIcon.undo,
              color: Colors.grey.withOpacity(0.5),
              colorBlendMode:
                  onUndo == null ? BlendMode.modulate : BlendMode.dst,
            ),
          ),
          IconButton(
            onPressed: onRedo,
            icon: AssetIconImage(
              assetIcon: AssetIcon.redo,
              color: Colors.grey.withOpacity(0.5),
              colorBlendMode:
                  onRedo == null ? BlendMode.modulate : BlendMode.dst,
            ),
          ),
        ],
      ),
    );
  }
}

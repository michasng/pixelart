import 'package:pixelart/components/canvas/canvas_change.dart';
import 'package:pixelart/components/canvas/tools/canvas_tool.dart';
import 'package:pixelart/components/canvas/tools/canvas_tool_context.dart';

class CanvasEraseTool implements CanvasTool {
  @override
  CanvasChange use(CanvasToolContext context) {
    return CanvasChange(
      pixelChanges: [
        (
          position: context.position,
          color: null,
        )
      ],
    );
  }
}

import 'package:pixelart/components/canvas/canvas_change.dart';
import 'package:pixelart/components/canvas/tools/canvas_tool_context.dart';

abstract interface class CanvasTool {
  CanvasChange use(CanvasToolContext context);
}

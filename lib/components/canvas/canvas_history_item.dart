import 'package:pixelart/components/canvas/canvas_change.dart';

class CanvasHistoryItem {
  final CanvasChange change;
  final CanvasChange reverseChange;

  CanvasHistoryItem({
    required this.change,
    required this.reverseChange,
  });
}

import 'package:flutter/material.dart';
import 'package:pixelart/components/canvas/canvas.dart';
import 'package:pixelart/components/canvas/canvas_page_menu.dart';
import 'package:pixelart/components/canvas/canvas_settings.dart';
import 'package:pixelart/components/canvas/random_access_image.dart';
import 'package:pixelart/components/canvas/tools/draw_tool.dart';
import 'package:pixelart/components/canvas/tools/erase_tool.dart';

class CanvasPage extends StatefulWidget {
  static const colors = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
  ];

  const CanvasPage({super.key});

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  final _canvasKey = GlobalKey<CanvasState>();
  bool _canUndo = false;
  bool _canRedo = false;

  void _undo() {
    _canvasKey.currentState?.undo();
  }

  void _redo() {
    _canvasKey.currentState?.redo();
  }

  void setColorDrawTool(Color? color) {
    final canvasState = _canvasKey.currentState;
    if (canvasState == null) return;
    canvasState.settings = canvasState.settings.copyWith(
      tool: DrawTool(),
      primaryColor: color,
    );
  }

  void setEraseTool() {
    final canvasState = _canvasKey.currentState;
    if (canvasState == null) return;
    canvasState.settings = canvasState.settings.copyWith(
      tool: EraseTool(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixel Art App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _canUndo ? _undo : null,
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            onPressed: _canRedo ? _redo : null,
            icon: const Icon(Icons.redo),
          ),
          const Spacer(),
          for (var color in CanvasPage.colors)
            IconButton(
              onPressed: () => setColorDrawTool(color),
              style: IconButton.styleFrom(foregroundColor: color),
              icon: const Icon(Icons.color_lens),
            ),
          IconButton(
            onPressed: setEraseTool,
            icon: const Icon(Icons.color_lens),
          ),
        ],
      ),
      body: CanvasPageMenu(
        onImageChanged: (image) => _canvasKey.currentState?.image = image,
        child: Canvas(
          key: _canvasKey,
          initialImage: RandomAccessImage.filled(
            width: 32,
            height: 16,
            color: Colors.grey,
          ),
          initialSettings: CanvasSettings(
            tool: DrawTool(),
            primaryColor: CanvasPage.colors.first,
            showGrid: true,
          ),
          onHistoryChanged: ({required canUndo, required canRedo}) {
            setState(() {
              _canUndo = canUndo;
              _canRedo = canRedo;
            });
          },
        ),
      ),
    );
  }
}

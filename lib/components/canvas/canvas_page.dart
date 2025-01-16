import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:pixelart/components/canvas/canvas.dart';
import 'package:pixelart/components/canvas/canvas_page_menu.dart';
import 'package:pixelart/components/canvas/canvas_settings.dart';
import 'package:pixelart/components/canvas/colors.dart';
import 'package:pixelart/components/canvas/tool_bar.dart';
import 'package:pixelart/components/canvas/tools/draw_tool.dart';
import 'package:pixelart/components/canvas/tools/tool.dart';

class CanvasPage extends StatefulWidget {
  static final colors = [
    PixelColors.black,
    PixelColors.white,
    PixelColors.red,
    PixelColors.green,
    PixelColors.blue,
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

  void setPrimaryColor(img.Color primaryColor) {
    final canvasState = _canvasKey.currentState;
    if (canvasState == null) return;
    canvasState.settings = canvasState.settings.copyWith(
      primaryColor: primaryColor,
    );
  }

  void setTool(Tool tool) {
    final canvasState = _canvasKey.currentState;
    if (canvasState == null) return;
    canvasState.settings = canvasState.settings.copyWith(
      tool: tool,
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
              onPressed: () => setPrimaryColor(color),
              style: IconButton.styleFrom(foregroundColor: toUiColor(color)),
              icon: const Icon(Icons.color_lens),
            ),
        ],
      ),
      body: CanvasPageMenu(
        onImageChanged: (image) => _canvasKey.currentState?.image = image,
        child: ToolBar(
          onToolSelected: setTool,
          child: ClipRect(
            child: Canvas(
              key: _canvasKey,
              initialImage: img.Image(
                width: 32,
                height: 16,
                numChannels: 4,
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
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:image/image.dart' as img;
import 'package:pixelart/components/canvas/canvas.dart';
import 'package:pixelart/components/canvas/canvas_page_menu_bar.dart';
import 'package:pixelart/components/canvas/canvas_settings.dart';
import 'package:pixelart/components/canvas/colors/color_menu.dart';
import 'package:pixelart/components/canvas/colors/colors.dart';
import 'package:pixelart/components/canvas/history_buttons.dart';
import 'package:pixelart/components/canvas/tools/draw_tool.dart';
import 'package:pixelart/components/canvas/tools/tool.dart';
import 'package:pixelart/components/canvas/tools/tool_bar.dart';

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
      body: CanvasPageMenuBar(
        onImageChanged: (image) => _canvasKey.currentState?.image = image,
        child: ResizableContainer(
          direction: Axis.horizontal,
          children: [
            ResizableChild(
              child: ColorMenu(
                colors: CanvasPage.colors,
                onSelect: setPrimaryColor,
              ),
              size: ResizableSize.pixels(160),
            ),
            ResizableChild(
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
          ],
        ),
      ),
      floatingActionButton: HistoryButtons(
        onUndo: _canUndo ? _undo : null,
        onRedo: _canRedo ? _redo : null,
      ),
    );
  }
}

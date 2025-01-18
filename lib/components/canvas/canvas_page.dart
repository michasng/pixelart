import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:image/image.dart' as img;
import 'package:pixelart/components/canvas/canvas.dart';
import 'package:pixelart/components/canvas/canvas_page_menu_bar.dart';
import 'package:pixelart/components/canvas/canvas_settings.dart';
import 'package:pixelart/components/canvas/colors/color_menu.dart';
import 'package:pixelart/components/canvas/colors/colors.dart';
import 'package:pixelart/components/canvas/history_buttons.dart';
import 'package:pixelart/components/canvas/tools/eraser_tool.dart';
import 'package:pixelart/components/canvas/tools/pencil_tool.dart';
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

  static final tools = [PencilTool(), EraserTool()];

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

  set primaryColor(img.Color value) {
    final canvasState = _canvasKey.currentState;
    if (canvasState == null) return;
    canvasState.settings = canvasState.settings.copyWith(
      primaryColor: value,
    );
  }

  Tool? get activeTool => _canvasKey.currentState?.settings.tool;

  set tool(Tool value) {
    final canvasState = _canvasKey.currentState;
    if (canvasState == null) return;

    setState(() {
      canvasState.settings = canvasState.settings.copyWith(
        tool: value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CanvasPageMenuBar(
        onImageChanged: (image) => _canvasKey.currentState?.image = image,
        getImage: () => _canvasKey.currentState?.image,
        child: ResizableContainer(
          direction: Axis.horizontal,
          children: [
            ResizableChild(
              child: ColorMenu(
                colors: CanvasPage.colors,
                onSelect: (color) => primaryColor = color,
              ),
              size: ResizableSize.pixels(160),
            ),
            ResizableChild(
              child: ToolBar(
                activeTool: activeTool,
                onToolSelected: (color) => tool = color,
                tools: CanvasPage.tools,
                child: ClipRect(
                  child: Canvas(
                    key: _canvasKey,
                    initialImage: img.Image(
                      width: 32,
                      height: 16,
                      numChannels: 4,
                    ),
                    initialSettings: CanvasSettings(
                      tool: CanvasPage.tools.first,
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

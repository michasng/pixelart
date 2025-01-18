import 'package:flutter/material.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:image/image.dart' as img;
import 'package:pixelart/components/canvas/canvas.dart';
import 'package:pixelart/components/canvas/canvas_page_menu_bar.dart';
import 'package:pixelart/components/canvas/canvas_settings.dart';
import 'package:pixelart/components/canvas/colors/color_menu.dart';
import 'package:pixelart/components/canvas/colors/color_preview.dart';
import 'package:pixelart/components/canvas/colors/colors.dart';
import 'package:pixelart/components/canvas/history_buttons.dart';
import 'package:pixelart/components/canvas/tools/eraser_tool.dart';
import 'package:pixelart/components/canvas/tools/eyedropper_tool.dart';
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

  static final tools = [PencilTool(), EraserTool(), EyedropperTool()];

  const CanvasPage({super.key});

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  final _canvasKey = GlobalKey<CanvasState>();
  bool _canUndo = false;
  bool _canRedo = false;
  CanvasSettings _settings = CanvasSettings(
    tool: CanvasPage.tools.first,
    primaryColor: CanvasPage.colors.first,
    showGrid: true,
  );

  CanvasSettings get settings => _settings;

  set settings(CanvasSettings value) => setState(() => _settings = value);

  set primaryColor(img.Color value) {
    settings = settings.copyWith(
      primaryColor: value,
    );
  }

  set tool(Tool value) {
    settings = settings.copyWith(
      tool: value,
    );
  }

  void _undo() {
    _canvasKey.currentState?.undo();
  }

  void _redo() {
    _canvasKey.currentState?.redo();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CanvasPageMenuBar(
        onImageChanged: (image) => _canvasKey.currentState?.image = image,
        getImage: () => _canvasKey.currentState?.image,
        child: ResizableContainer(
          direction: Axis.horizontal,
          children: [
            ResizableChild(
              child: Container(
                color: theme.primaryColor,
                padding: EdgeInsets.all(4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColorMenu(
                      colors: CanvasPage.colors,
                      onSelect: (color) => primaryColor = color,
                    ),
                    ColorPreview(color: settings.primaryColor),
                  ],
                ),
              ),
              size: ResizableSize.pixels(160),
            ),
            ResizableChild(
              child: ToolBar(
                activeTool: settings.tool,
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
                    settings: settings,
                    onChangeSettings: (value) => settings = value,
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

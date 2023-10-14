import 'package:flutter/material.dart';
import 'package:pixelart/components/canvas/canvas.dart';

class CanvasPage extends StatefulWidget {
  static const colors = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    null,
  ];

  const CanvasPage({super.key});

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  final _canvasKey = GlobalKey<CanvasState>();
  Color? _selectedColor = Colors.black;
  bool _canUndo = false;
  bool _canRedo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixel Art App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _canUndo
                ? () {
                    _canvasKey.currentState?.undo();
                  }
                : null,
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            onPressed: _canRedo
                ? () {
                    _canvasKey.currentState?.redo();
                  }
                : null,
            icon: const Icon(Icons.redo),
          ),
          const Spacer(),
          for (var color in CanvasPage.colors)
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              style: IconButton.styleFrom(foregroundColor: color),
              icon: const Icon(Icons.color_lens),
            ),
        ],
      ),
      body: Canvas(
        key: _canvasKey,
        width: 32,
        height: 16,
        selectedColor: _selectedColor,
        initialFillColor: Colors.grey,
        showGrid: true,
        onHistoryChanged: ({required canUndo, required canRedo}) {
          setState(() {
            _canUndo = canUndo;
            _canRedo = canRedo;
          });
        },
      ),
    );
  }
}

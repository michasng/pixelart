import 'package:flutter/material.dart';
import 'package:pixelart/components/pixel_art/pixel_art_canvas.dart';

class PixelArtPage extends StatefulWidget {
  static const colors = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    null,
  ];

  const PixelArtPage({super.key});

  @override
  State<PixelArtPage> createState() => _PixelArtPageState();
}

class _PixelArtPageState extends State<PixelArtPage> {
  final _pixelArtCanvasKey = GlobalKey<PixelArtCanvasState>();
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
                    _pixelArtCanvasKey.currentState?.undo();
                  }
                : null,
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            onPressed: _canRedo
                ? () {
                    _pixelArtCanvasKey.currentState?.redo();
                  }
                : null,
            icon: const Icon(Icons.redo),
          ),
          const Spacer(),
          for (var color in PixelArtPage.colors)
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
      body: PixelArtCanvas(
        key: _pixelArtCanvasKey,
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
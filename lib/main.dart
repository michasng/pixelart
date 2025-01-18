import 'package:flutter/material.dart';
import 'package:pixelart/components/canvas/canvas_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Art App',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xff7f929f),
          onPrimary: Color(0xffffffff),
          secondary: Color(0xff645561),
          onSecondary: Color(0xffd2cbbd),
          tertiary: Color(0xffc6c6c6),
          onTertiary: Color(0xff000000),
          error: Color(0xfff40000),
          onError: Color(0xffffffff),
          surface: Color(0xffd2cbbd),
          onSurface: Color(0xff000000),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const CanvasPage(),
    );
  }
}

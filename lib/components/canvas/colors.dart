import 'dart:ui';

import 'package:image/image.dart' as img;

class PixelColors {
  static final img.Color transparent = img.ColorRgba8(0, 0, 0, 0);
  static final img.Color black = img.ColorRgba8(0, 0, 0, 255);
  static final img.Color white = img.ColorRgba8(255, 255, 255, 255);
  static final img.Color red = img.ColorRgba8(200, 50, 50, 255);
  static final img.Color green = img.ColorRgba8(50, 200, 50, 255);
  static final img.Color blue = img.ColorRgba8(50, 50, 200, 255);
}

img.Color toPixelColor(Color source) {
  return img.ColorRgba8(
    source.alpha,
    source.red,
    source.green,
    source.blue,
  );
}

Color toUiColor(img.Color source) {
  return Color.fromARGB(
    source.a as int,
    source.r as int,
    source.g as int,
    source.b as int,
  );
}

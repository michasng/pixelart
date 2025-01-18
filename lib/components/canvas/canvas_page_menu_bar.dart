import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class CanvasPageMenuBar extends StatelessWidget {
  final Widget child;
  final ValueChanged<img.Image> onImageChanged;
  final img.Image? Function() getImage;

  const CanvasPageMenuBar({
    super.key,
    required this.child,
    required this.onImageChanged,
    required this.getImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MenuBar(
          children: [
            SubmenuButton(
              menuChildren: <Widget>[
                MenuItemButton(
                  onPressed: () {
                    // TODO: implement
                  },
                  child: const MenuAcceleratorLabel('&New'),
                ),
                MenuItemButton(
                  onPressed: () async {
                    final filePickerResult =
                        await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );
                    if (filePickerResult == null) return;
                    final file = filePickerResult.files.single;
                    final bytes =
                        file.bytes ?? await File(file.path!).readAsBytes();
                    final image = img.decodeImage(bytes);
                    if (image == null) return;
                    onImageChanged(image);
                  },
                  child: const MenuAcceleratorLabel('&Open'),
                ),
                Divider(),
                MenuItemButton(
                  onPressed: () async {
                    final image = getImage();
                    if (image == null) return;

                    // TODO: handle mobile and web
                    final filePath = await FilePicker.platform.saveFile(
                      type: FileType.image,
                    );
                    if (filePath == null) return;

                    final file = File(filePath);
                    final imageBytes = img.encodeNamedImage(filePath, image);
                    if (imageBytes == null) return;

                    await file.writeAsBytes(imageBytes);
                  },
                  child: const MenuAcceleratorLabel('&Save'),
                ),
                Divider(),
                MenuItemButton(
                  onPressed: () {
                    // TODO: implement
                  },
                  child: const MenuAcceleratorLabel('E&xit'),
                ),
              ],
              child: const MenuAcceleratorLabel('&File'),
            ),
            SubmenuButton(
              menuChildren: <Widget>[
                MenuItemButton(
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Pixelart',
                      applicationVersion: '1.0.0',
                    );
                  },
                  child: const MenuAcceleratorLabel('&About'),
                ),
              ],
              child: const MenuAcceleratorLabel('&Help'),
            ),
          ],
        ),
        Expanded(
          child: child,
        ),
      ],
    );
  }
}

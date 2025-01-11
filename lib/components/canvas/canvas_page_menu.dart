import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:pixelart/components/canvas/random_access_image.dart';

class CanvasPageMenu extends StatelessWidget {
  final Widget child;
  final ValueChanged<RandomAccessImage> onImageChanged;

  const CanvasPageMenu({
    super.key,
    required this.child,
    required this.onImageChanged,
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
                    onImageChanged(RandomAccessImage.fromImage(image));
                  },
                  child: const MenuAcceleratorLabel('&Open'),
                ),
                Divider(),
                MenuItemButton(
                  onPressed: () {
                    // TODO: implement
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

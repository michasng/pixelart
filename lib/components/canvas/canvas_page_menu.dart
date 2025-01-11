import 'package:flutter/material.dart';

class CanvasPageMenu extends StatelessWidget {
  final Widget child;

  const CanvasPageMenu({
    super.key,
    required this.child,
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
                  onPressed: () {
                    // TODO: implement
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

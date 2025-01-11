import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InteractionDetector extends StatefulWidget {
  final Widget child;

  final ValueChanged<Offset> onPan;
  final ValueChanged<double> onZoom;

  final PointerHoverEventListener? onPointerHover;
  final PointerDownEventListener? onPointerDown;
  final PointerMoveEventListener? onPointerMove;
  final PointerUpEventListener? onPointerUp;

  const InteractionDetector({
    super.key,
    required this.child,
    required this.onPan,
    required this.onZoom,
    this.onPointerHover,
    this.onPointerDown,
    this.onPointerMove,
    this.onPointerUp,
  });

  @override
  State<InteractionDetector> createState() => _InteractionDetectorState();
}

class _InteractionDetectorState extends State<InteractionDetector> {
  double interactiveScale = 1.0;
  int? currentButtonsDown;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          final scroll = event.scrollDelta.dy;
          final delta = -scroll / kDefaultMouseScrollToScaleFactor;
          widget.onZoom(delta);
        }
      },
      onPointerPanZoomStart: (event) {
        interactiveScale = 1.0;
      },
      onPointerPanZoomUpdate: (event) {
        // Only ever pan OR zoom, because panDelta behaves unexpectedly while zooming.
        if (event.scale == 1.0) {
          widget.onPan(event.panDelta);
        } else {
          final scaleDelta = event.scale - interactiveScale;
          widget.onZoom(scaleDelta);
          interactiveScale = event.scale;
        }
      },
      onPointerHover: widget.onPointerHover,
      onPointerDown: (event) {
        currentButtonsDown = event.buttons;

        widget.onPointerDown?.call(event);
      },
      onPointerMove: widget.onPointerMove,
      onPointerUp: (event) {
        /**
         * PointerUpEvent.buttons is always 0, because no button is pressed anymore.
         * https://github.com/flutter/flutter/issues/110448
         * I think that's stupid, so I'm fixing it by correlating down and up events & buttons.
         * 
         * There is an identifying event.pointer, but only one pointer is ever tracked, so I don't need to use it.
         * E.g. press one button, then another, then release the first, then the second.
         * You will get only one pointer down event and one pointer up event.
         */
        widget.onPointerUp?.call(event.copyWith(buttons: currentButtonsDown));
      },
      child: widget.child,
    );
  }
}

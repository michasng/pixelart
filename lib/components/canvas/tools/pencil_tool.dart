import 'package:pixelart/components/asset_icon_image.dart';
import 'package:pixelart/components/canvas/image_change.dart';
import 'package:pixelart/components/canvas/tools/tool.dart';
import 'package:pixelart/components/canvas/tools/use_tool_arguments.dart';
import 'package:pixelart/components/image_extension.dart';

class PencilTool implements Tool {
  const PencilTool();

  @override
  AssetIcon get assetIcon => AssetIcon.pencil;

  @override
  CompletableImageChange? onPointerDown(UseToolArguments args) {
    if (!args.image.containsPoint(args.cursorPosition)) return null;

    final change = ImageChange(
      pixelChanges: {
        args.cursorPosition: args.effectiveColor,
      },
    );

    return (
      change: change,
      completed: false,
    );
  }

  @override
  CompletableImageChange? onPointerMove(UseToolArguments args) {
    var change = args.incompleteChange;
    if (change == null) return null;

    if (args.image.containsPoint(args.cursorPosition)) {
      change = change.copyWith(pixelChanges: {
        ...change.pixelChanges,
        args.cursorPosition: args.effectiveColor,
      });
    }

    return (
      change: change,
      completed: false,
    );
  }

  @override
  CompletableImageChange? onPointerUp(UseToolArguments args) {
    var change = args.incompleteChange;
    if (change == null) return null;

    if (args.image.containsPoint(args.cursorPosition)) {
      change = change.copyWith(pixelChanges: {
        ...change.pixelChanges,
        args.cursorPosition: args.effectiveColor,
      });
    }

    return (
      change: change,
      completed: true,
    );
  }
}

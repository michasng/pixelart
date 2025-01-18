import 'package:pixelart/components/asset_icon_image.dart';
import 'package:pixelart/components/canvas/image_change.dart';
import 'package:pixelart/components/canvas/tools/use_tool_arguments.dart';

typedef CompletableImageChange = ({ImageChange change, bool completed});

abstract interface class Tool {
  AssetIcon get assetIcon;

  CompletableImageChange? onPointerDown(UseToolArguments args);

  CompletableImageChange? onPointerMove(UseToolArguments args);

  CompletableImageChange? onPointerUp(UseToolArguments args);
}

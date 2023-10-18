import 'package:code_builder/code_builder.dart' as cb;

import '../../symbols.dart';

/// Template for _supportedHandlers
cb.Field supportedHandlersTemplate() {
  return cb.Field((f) {
    f
      ..name = supportedHandlers$.symbol.toString()
      ..modifier = cb.FieldModifier.final$
      ..assignment = cb.literalMap({}, typeT, handlerDescriptorT).code;
  });
}

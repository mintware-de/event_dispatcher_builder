import 'package:code_builder/code_builder.dart' as cb;

import '../../../dto/dto.dart';
import '../../handler_descriptor/handler_descriptor.dart';
import '../../symbols.dart';

/// Template for addHandler()
cb.Constructor constructorTemplate(List<ExtractedHandler> handlers) {
  var supportedHandlers = <cb.Reference, cb.Expression>{};

  for (var handler in handlers) {
    var handler$ = cb.refer(
      handler.reference.symbolName,
      handler.reference.library,
    );

    supportedHandlers[handler$] = handlerDescriptorTemplate(handler$, handler);
  }

  return cb.Constructor((m) {
    m.body = cb.Block.of([
      supportedHandlers$.property('addAll').call([
        cb.literalMap(supportedHandlers, typeT, handlerDescriptorT),
      ]).statement,
    ]);
  });
}

import 'package:code_builder/code_builder.dart' as cb;

import '../../../dto/dto.dart';
import '../../handler_descriptor/handler_descriptor.dart';
import '../../symbols.dart';

/// Template for applyPlugin()
cb.Method provideSupportedHandlersTemplate(List<ExtractedHandler> handlers) {
  var supportedHandlers = <cb.Reference, cb.Expression>{};

  for (var handler in handlers) {
    var handler$ = cb.refer(
      handler.reference.symbolName,
      handler.reference.library,
    );

    supportedHandlers[handler$] = handlerDescriptorTemplate(handler$, handler);
  }

  return cb.Method((m) {
    m.returns = mapOfT(typeT, handlerDescriptorT);
    m.name = 'provideSupportedHandlers';
    m.annotations.add(cb.refer('override'));
    m.body = cb.Block.of([
      cb
          .literalMap(supportedHandlers, typeT, handlerDescriptorT)
          .returned
          .statement,
    ]);
  });
}

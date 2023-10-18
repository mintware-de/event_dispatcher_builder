import 'package:code_builder/code_builder.dart' as cb;

import '../../dto/dto.dart';
import '../symbols.dart';

/// Creates a handlerDescriptor
cb.Expression handlerDescriptorTemplate(
  cb.Reference handler$,
  ExtractedHandler handler,
) {
  return handlerDescriptorT.newInstance(
    [
      cb.literalList(handler.subscribers.map((e) {
        var event$ = cb.refer(
          e.event.symbolName,
          e.event.library,
        );
        var subscriber$ = cb.refer(
          e.subscriber.symbolName,
          e.subscriber.library,
        );
        var hT = cb.refer('h');
        return subscriptionFactoryT.newInstance([
          cb.Method(
            (m) => m
              ..lambda = true
              ..requiredParameters.add(cb.Parameter((p) => p.name = hT.symbol!))
              ..body = hT.property(subscriber$.symbol!).code,
          ).closure
        ], {}, [
          handler$,
          event$
        ]);
      }).toList())
    ],
    {},
    [handler$],
  );
}

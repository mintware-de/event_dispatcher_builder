import 'package:code_builder/code_builder.dart' as cb;

import '../../helper.dart';
import '../../symbols.dart';

/// Template for addHandler()
cb.Method addHandlerTemplate() {
  var tT = cb.refer('T');
  var typeP = cb.refer('t');
  var factory$ = cb.refer('factory');

  var subscription$ = cb.refer('subscription');
  var realTV$ = cb.refer('realT');
  return cb.Method((m) {
    m
      ..annotations.add(overrideA)
      ..name = addHandler$.symbol
      ..types.add(tT)
      ..returns = voidT
      ..requiredParameters.add(cb.Parameter(
        (p) => p
          ..type = tT
          ..name = handlerP.symbol.toString(),
      ))
      ..optionalParameters.add(cb.Parameter((p) => p
        ..type = nullableTypeT
        ..name = typeP.symbol!
        ..required = false))
      ..body = cb.Block.of([
        initVar(
            realTV$,
            cb.CodeExpression(cb.Block.of([
              cb.CodeExpression(supportedHandlers$
                      .property('containsKey')
                      .call([typeP]).code)
                  .code,
              cb.Code('?'),
              typeP.code,
              cb.Code(':'),
              tT.code
            ]))),
        IfBuilder(supportedHandlers$
                .property('containsKey')
                .call([realTV$]).negate())
            .then(handlerNotSupportedExceptionT.call([realTV$]).thrown)
            .code,
        cb.Code('for (var '),
        factory$.code,
        cb.Code(' in '),
        cb.CodeExpression(cb.Block.of([
          cb.Code('('),
          supportedHandlers$[realTV$]
              .asA(cb.CodeExpression(cb.Block.of([
                handlerDescriptorT.code,
                cb.Code('<'),
                tT.code,
                cb.Code('>)'),
              ])))
              .code,
        ])).property(factories$.symbol!).code,
        cb.Code(') {'),
        IfBuilder(
          subscriptions$
              .property('containsKey')
              .call([factory$.property(eventType$.symbol!)]).negate(),
        )
            .then(
              subscriptions$[factory$.property(eventType$.symbol!)]
                  .assign(cb.literalList([])),
            )
            .code,
        cb
            .declareVar(subscription$.symbol!)
            .assign(factory$
                .asA(dynamicT)
                .property(createSubscription$.symbol!)
                .call([handlerP]))
            .statement,
        subscriptions$[factory$.property(eventType$.symbol!)]
            .nullSafeProperty('add')
            .call([subscription$]).statement,
        cb.Code('}'),
      ]);
  });
}

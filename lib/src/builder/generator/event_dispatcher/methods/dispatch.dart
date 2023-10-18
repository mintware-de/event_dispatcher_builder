import 'package:code_builder/code_builder.dart' as cb;

import '../../helper.dart';
import '../../symbols.dart';

/// Template for dispatch()
cb.Method dispatchTemplate() {
  var subscription$ = cb.refer('subscription');
  var tT = cb.refer('T');
  var vResult = cb.refer('result');
  return cb.Method((m) {
    m
      ..annotations.add(overrideA)
      ..name = dispatch$.symbol
      ..types.add(tT)
      ..returns = futureOfVoidT
      ..modifier = cb.MethodModifier.async
      ..requiredParameters.add(cb.Parameter(
        (p) => p
          ..type = tT
          ..name = eventP.symbol.toString(),
      ))
      ..body = cb.Block.of([
        IfBuilder(subscriptions$.property('containsKey').call([tT]).negate())
            .thenReturn(cb.CodeExpression(cb.Code(''))),
        cb.Block.of([
          cb.Code('for (var '),
          subscription$.code,
          cb.Code(' in '),
          subscriptions$[tT].code,
          cb.Code('!) {'),
          initVar(vResult, subscription$.call([eventP])),
          IfBuilder(vResult.isA(futureT)).then(vResult.awaited).code,
          cb.Code('}'),
        ])
      ]);
  });
}

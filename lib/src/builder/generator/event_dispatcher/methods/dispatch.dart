import 'package:code_builder/code_builder.dart' as cb;

import '../../helper.dart';
import '../../symbols.dart';

/// Template for dispatch()
cb.Method dispatchTemplate() {
  var subscription$ = cb.refer('subscription');
  var tT = cb.refer('T');
  return cb.Method((m) {
    m
      ..annotations.add(overrideA)
      ..name = dispatch$.symbol
      ..types.add(tT)
      ..returns = voidT
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
          subscription$.call([eventP]).statement,
          cb.Code('}'),
        ])
      ]);
  });
}

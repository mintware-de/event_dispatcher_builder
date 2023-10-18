import 'package:code_builder/code_builder.dart' as cb;

import '../../symbols.dart';

/// Template for _subscriptions
cb.Field subscriptionsTemplate() {
  return cb.Field((f) {
    f
      ..name = subscriptions$.symbol.toString()
      ..modifier = cb.FieldModifier.final$
      ..assignment = cb.literalMap({}, typeT, listOfDynamicT).code;
  });
}

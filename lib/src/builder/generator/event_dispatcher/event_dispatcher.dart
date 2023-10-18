import 'package:code_builder/code_builder.dart' as cb;

import '../../dto/dto.dart';
import '../symbols.dart';
import 'fields/fields.dart';
import 'methods/methods.dart';

/// Generates the code for the event dispatcher.
cb.Class buildEventDispatcherClass(
  Map<String, dynamic> config,
  List<ExtractedHandler> subscribers,
) {
  return cb.Class(
    (b) => b
      ..name = config['eventDispatcherClassName'] as String
      ..extend = eventDispatcherT
      ..fields.addAll([
        supportedHandlersTemplate(),
        subscriptionsTemplate(),
      ])
      ..constructors.add(constructorTemplate(subscribers))
      ..methods.addAll([
        addHandlerTemplate(),
        dispatchTemplate(),
      ]),
  );
}

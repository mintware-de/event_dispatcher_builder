import 'package:code_builder/code_builder.dart' as cb;

import '../../dto/dto.dart';
import '../symbols.dart';
import 'fields/fields.dart';
import 'methods/methods.dart';

/// Generates the code for the event dispatcher.
cb.Class buildEventDispatcherClass(
  String className,
  List<ExtractedHandler> subscribers,
) {
  return cb.Class(
    (b) => b
      ..name = className
      ..implements.addAll([eventDispatcherPluginT])
      ..fields.addAll([
        supportedHandlersTemplate(),
        subscriptionsTemplate(),
      ])
      ..methods.addAll([provideSupportedHandlersTemplate(subscribers)]),
  );
}

cb.Extension buildExtension(String pluginClassName) {
  return cb.Extension((e) => e
    ..name = "${pluginClassName}Extension"
    ..on = eventDispatcherT
    ..methods.add(cb.Method((m) => m
      ..name = "use$pluginClassName"
      ..returns = voidT
      ..body = cb.Block.of([
        applyPlugin$.call([cb.refer(pluginClassName).call([])]).statement
      ]))));
}

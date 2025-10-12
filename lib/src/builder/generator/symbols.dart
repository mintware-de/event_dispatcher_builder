import 'package:code_builder/code_builder.dart' as cb;

/// The event_dispatcher_builder root package.
final rootPackage =
    'package:event_dispatcher_builder/event_dispatcher_builder.dart';

/// HandlerDescriptor type
final handlerDescriptorT = cb.refer('HandlerDescriptor', rootPackage);

/// EventDispatcher type
final eventDispatcherT = cb.refer('EventDispatcher', rootPackage);

/// subscriptionFactory type
final subscriptionFactoryT = cb.refer('SubscriptionFactory', rootPackage);

/// void type
final voidT = cb.refer('void');

/// Type type
final typeT = cb.refer('Type');

/// EventDispatcherPlugin type
final eventDispatcherPluginT = cb.refer('EventDispatcherPlugin', rootPackage);

cb.Reference mapOfT(cb.Reference tKey, cb.Reference tValue) =>
    (cb.TypeReferenceBuilder()
          ..symbol = 'Map'
          ..types.addAll([tKey, tValue]))
        .build();

/// EventDispatcher.applyPlugin()
final applyPlugin$ = cb.refer('applyPlugin');

import 'package:code_builder/code_builder.dart' as cb;

/// The event_dispatcher_builder root package.
final rootPackage =
    'package:event_dispatcher_builder/event_dispatcher_builder.dart';

/// HandlerDescriptor type
final handlerDescriptorT = cb.refer('HandlerDescriptor', rootPackage);

/// EventDispatcher type
final eventDispatcherT = cb.refer('EventDispatcher', rootPackage);

/// Subscription type
final subscriptionT = cb.refer('Subscription', rootPackage);

/// subscriptionFactory type
final subscriptionFactoryT = cb.refer('SubscriptionFactory', rootPackage);

/// HandlerNotSupportedException type
final handlerNotSupportedExceptionT =
    cb.refer('HandlerNotSupportedException', rootPackage);

/// EventDispatcher.addHandler()
final addHandler$ = cb.refer('addHandler');

/// HandlerDescriptor.factories
final factories$ = cb.refer('factories');

/// SubscriptionFactory.eventType
final eventType$ = cb.refer('eventType');

/// SubscriptionFactory.createSubscription()
final createSubscription$ = cb.refer('createSubscription');

/// EventDispatcher.addHandler(handlerP)
final handlerP = cb.refer('handler');

/// EventDispatcher.dispatch()
final dispatch$ = cb.refer('dispatch');

/// EventDispatcher.addHandler(eventP)
final eventP = cb.refer('event');

/// EventDispatcher._supportedHandlers
final supportedHandlers$ = cb.refer('_supportedHandlers');

/// EventDispatcher._subscriptions
final subscriptions$ = cb.refer('_subscriptions');

/// void type
final voidT = cb.refer('void');

/// Type type
final typeT = cb.refer('Type');

/// Nullable Type type
final nullableTypeT = cb.refer('Type?');

/// String type
final stringT = cb.refer('String');

/// dynamic type
final dynamicT = cb.refer('dynamic');

/// override annotation
final overrideA = cb.refer('override');

/// List of dynamic
final listOfDynamicT = cb.refer('List<dynamic>');

/// Future-void
final futureOfVoidT = cb.refer('Future<void>', 'dart:async');

/// Future-void
final futureT = cb.refer('Future', 'dart:async');

/// EventDispatcherPlugin type
final eventDispatcherPluginT = cb.refer('EventDispatcherPlugin', rootPackage);

cb.Reference mapOfT(cb.Reference tKey, cb.Reference tValue) =>
    (cb.TypeReferenceBuilder()
          ..symbol = 'Map'
          ..types.addAll([tKey, tValue]))
        .build();

/// EventDispatcher.applyPlugin()
final applyPlugin$ = cb.refer('applyPlugin');

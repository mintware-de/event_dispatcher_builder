import 'dart:async';

import 'package:event_dispatcher_builder/src/event_dispatcher_plugin.dart';

import '../event_dispatcher_builder.dart';

/// This class is the event dispatcher
class EventDispatcher {
  final _supportedHandlers = <Type, HandlerDescriptor>{};

  final _subscriptions = <Type, List<dynamic>>{};

  /// Add an event [handler] to the event dispatcher.
  void addHandler<T>(T handler, [Type? t]) {
    var realT = _supportedHandlers.containsKey(t) ? t : T;
    if (!_supportedHandlers.containsKey(realT)) {
      throw HandlerNotSupportedException(realT);
    }
    for (var factory
        in ((_supportedHandlers[realT] as HandlerDescriptor<T>)).factories) {
      if (!_subscriptions.containsKey(factory.eventType)) {
        _subscriptions[factory.eventType] = [];
      }
      var subscription = (factory as dynamic).createSubscription(handler);
      _subscriptions[factory.eventType]?.add(subscription);
    }
  }

  /// Dispatch a specific [event].
  Future<void> dispatch<T>(T event) async {
    if (!_subscriptions.containsKey(T)) {
      return;
    }
    for (var subscription in _subscriptions[T]!) {
      var result = subscription(event);
      if (result is Future) {
        await result;
      }
    }
  }

  /// Apply a event dispatcher plugin to add supported handlers.
  void applyPlugin(EventDispatcherPlugin plugin) {
    _supportedHandlers.addAll(plugin.provideSupportedHandlers());
  }
}

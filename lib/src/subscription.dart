import 'dart:async';

/// Represents a Subscription for a event
class Subscription<T> {
  final int priority;
  final FutureOr<void> Function(T eventType) notify;

  Subscription({
    required this.notify,
    this.priority = 10,
  });
}

/// The subscription factory is used for creating subscriptions for a specific
/// event at runtime.
class SubscriptionFactory<THandler, T> {
  /// Holds the type of the event
  Type get eventType => T;

  /// The factory function to produce a subscription on the handler.
  final Subscription<T> Function(THandler handler) createSubscription;

  /// Constructor for the Subscription factory
  const SubscriptionFactory(this.createSubscription);
}

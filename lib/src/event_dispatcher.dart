/// This class describes a event dispatcher
abstract class EventDispatcher {
  /// Add an event [handler] to the event dispatcher.
  void addHandler<T>(T handler, [Type? t]);

  /// Dispatch a specific [event].
  void dispatch<T>(T event);
}

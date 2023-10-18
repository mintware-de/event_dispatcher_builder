/// A base class for EventDispatcher specific exceptions
abstract class EventDispatcherException implements Exception {
  /// The exception [message]
  final String message;

  /// A inner exception
  final EventDispatcherException? inner;

  /// Creates a exception with the given [message]
  const EventDispatcherException(this.message, [this.inner]);

  @override
  String toString() {
    return "EventDispatcherException: $message";
  }
}

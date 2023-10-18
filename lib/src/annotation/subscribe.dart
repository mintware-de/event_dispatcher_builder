/// Annotation for marking a method as a event subscriber.
class Subscribe {
  /// The priority of the event subscriber (defaults to 10).
  /// Lower = earlier
  /// Higher = later
  final int priority;

  /// Marks the method as an event subscriber.
  /// The method must have exactly one argument with the type of the event.
  const Subscribe({this.priority = 10});
}

import 'dto.dart';

/// Represents a event subscriber that was extracted from the annotations.
class ExtractedSubscriber {
  /// The event type
  final SymbolReference event;

  /// The handler type
  final SymbolReference subscriber;

  /// The priority of this subscriber
  final int priority;

  /// ExtractedSubscriber constructor
  const ExtractedSubscriber({
    required this.event,
    required this.subscriber,
    required this.priority,
  });

  /// Creates a serializable representation of the subscriber.
  Map<String, dynamic> toJson() {
    return {
      'event': event.toJson(),
      'subscriber': subscriber.toJson(),
      'priority': priority,
    };
  }

  /// Creates a ExtractedSubscriber from the json representation.
  factory ExtractedSubscriber.fromJson(Map<String, dynamic> json) {
    return ExtractedSubscriber(
      event: SymbolReference.fromJson(json['event'] as Map<String, dynamic>),
      subscriber:
          SymbolReference.fromJson(json['subscriber'] as Map<String, dynamic>),
      priority: json['priority'] as int,
    );
  }
}

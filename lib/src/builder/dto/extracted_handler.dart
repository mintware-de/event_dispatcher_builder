import 'extracted_event.dart';
import 'symbol_reference.dart';

/// Represents a class that contains Subscribe annotations on methods
class ExtractedHandler {
  /// The handler type
  final SymbolReference reference;

  /// The extracted subscribers.
  final List<ExtractedSubscriber> subscribers;

  /// ExtractedHandler constructor.
  const ExtractedHandler({
    required this.reference,
    required this.subscribers,
  });

  /// Creates a serializable representation of the subscriber.
  Map<String, dynamic> toJson() {
    return {
      'reference': reference.toJson(),
      'subscribers': subscribers.map((e) => e.toJson()).toList(),
    };
  }

  /// Creates a ExtractedSubscriber from the json representation.
  factory ExtractedHandler.fromJson(Map<String, dynamic> json) {
    return ExtractedHandler(
      reference:
          SymbolReference.fromJson(json['reference'] as Map<String, dynamic>),
      subscribers: (json['subscribers'] as List)
          .map((e) => ExtractedSubscriber.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

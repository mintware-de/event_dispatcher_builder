import 'dto.dart';

/// Represents the result of a single file that was processed by the preflight
/// builder.
class PreflightPart {
  /// The extracted services in the file.
  final List<ExtractedHandler> handlers;

  /// Creates the preflight part.
  PreflightPart({
    required this.handlers,
  });

  /// Creates a new instance from the result of [toJson].
  factory PreflightPart.fromJson(Map<String, dynamic> json) {
    return PreflightPart(
      handlers: (json['handlers'] as List)
          .map((m) => ExtractedHandler.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Dumps the object in a map that can be used in [PreflightPart.fromJson].
  Map<String, dynamic> toJson() {
    return {
      'handlers': handlers.map((e) => e.toJson()).toList(),
    };
  }
}

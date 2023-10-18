/// Represents a simple symbol reference.
class SymbolReference {
  /// The name of the symbol.
  final String symbolName;

  /// The library where the symbol is located.
  final String? library;

  /// Instantiate a new symbol reference
  const SymbolReference({
    required this.symbolName,
    required this.library,
  });

  /// Creates a new instance from the result of [toJson].
  factory SymbolReference.fromJson(Map<String, dynamic> json) {
    return SymbolReference(
      symbolName: json['symbolName'] as String,
      library: json['library'] as String,
    );
  }

  /// Dumps the object in a map that can be used in [SymbolReference.fromJson].
  Map<String, dynamic> toJson() {
    return {
      'symbolName': symbolName,
      'library': library,
    };
  }
}

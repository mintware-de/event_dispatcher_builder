import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:event_dispatcher_builder/src/builder/generator/helpers.dart';

import 'dto/dto.dart';
import 'generator/constants.dart';

/// The PreflightBuilder scans the files for @Service annotations.
/// The result is stored in preflight.json files.
class PreflightBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': [],
        '.dart': [preflightExtension],
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    if (!await buildStep.resolver.isLibrary(buildStep.inputId)) {
      return;
    }

    final entryLib = await buildStep.inputLibrary;
    var extractedAnnotations = await _extractAnnotations(entryLib);
    if (extractedAnnotations.handlers.isEmpty) {
      return;
    }

    final preflightAsset =
        buildStep.inputId.changeExtension(preflightExtension);

    await buildStep.writeAsString(
      preflightAsset,
      jsonEncode(extractedAnnotations),
    );
  }

  Future<PreflightPart> _extractAnnotations(LibraryElement entryLib) async {
    var handlers = <ExtractedHandler>[];
    for (var el in entryLib.children.whereType<ClassElement>()) {
      var extractedSubscribers = _extractSubscribers(el);
      if (extractedSubscribers.isNotEmpty) {
        handlers.add(
          ExtractedHandler(
            reference: SymbolReference(
              symbolName: el.displayName,
              library: el.library.uri.toString(),
            ),
            subscribers: extractedSubscribers,
          ),
        );
      }
    }

    return PreflightPart(handlers: handlers);
  }

  List<ExtractedSubscriber> _extractSubscribers(ClassElement el) {
    return el.methods
        .where(_isSubscribingMethod)
        .map(_createExtractedSubscriber)
        .toList();
  }

  bool _isSubscribingMethod(MethodElement method) {
    var hasAnnotation = method.metadata.annotations
        .any((a) => a.isLibraryAnnotation('Subscribe'));

    if (hasAnnotation && method.formalParameters.length != 1) {
      throw Exception('A Subscriber must have exactly 1 parameter.');
    }

    return hasAnnotation;
  }

  ExtractedSubscriber _createExtractedSubscriber(MethodElement m) {
    var firstParameter = m.formalParameters.first;
    return ExtractedSubscriber(
      event: SymbolReference(
        symbolName: firstParameter.type.element!.name!,
        library: firstParameter.type.element!.library?.uri.toString(),
      ),
      subscriber: SymbolReference(
        symbolName: m.displayName,
        library: m.library.uri.toString(),
      ),
    );
  }
}

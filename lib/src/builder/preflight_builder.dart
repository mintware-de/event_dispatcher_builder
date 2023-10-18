import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

import 'dto/dto.dart';

/// The PreflightBuilder scans the files for @Service annotations.
/// The result is stored in preflight.json files.
class PreflightBuilder implements Builder {
  /// PreflightBuilder constructor
  PreflightBuilder();

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

    final preflightAsset = buildStep.inputId
        .changeExtension('.event_dispatcher_builder.preflight.json');

    await buildStep.writeAsString(
      preflightAsset,
      jsonEncode(extractedAnnotations),
    );
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': [],
        '.dart': ['.event_dispatcher_builder.preflight.json'],
      };

  Future<PreflightPart> _extractAnnotations(LibraryElement entryLib) async {
    var handlers = <ExtractedHandler>[];
    for (var el in entryLib.topLevelElements) {
      if (el is! ClassElement) {
        continue;
      }
      var extractedSubscribers = <ExtractedSubscriber>[];
      for (var m in el.methods) {
        for (var annotation in m.metadata) {
          if (!_isLibraryAnnotation(annotation, 'Subscribe')) {
            continue;
          }
          if (m.parameters.length != 1) {
            throw Exception('A Subscriber must have exactly 1 parameter.');
          }

          var firstParameter = m.parameters.first;
          extractedSubscribers.add(ExtractedSubscriber(
            event: SymbolReference(
              symbolName: firstParameter.type.element!.name!,
              library:
                  firstParameter.type.element!.librarySource?.uri.toString(),
            ),
            subscriber: SymbolReference(
              symbolName: m.name,
              library: m.librarySource.uri.toString(),
            ),
          ));
        }
      }
      if (extractedSubscribers.isNotEmpty) {
        handlers.add(
          ExtractedHandler(
            reference: SymbolReference(
              symbolName: el.name,
              library: el.librarySource.uri.toString(),
            ),
            subscribers: extractedSubscribers,
          ),
        );
      }
    }

    return PreflightPart(handlers: handlers);
  }

  bool _isLibraryAnnotation(ElementAnnotation annotation, String name) {
    return annotation.element != null &&
        (annotation.element!.library?.source.uri.toString().startsWith(
                'package:event_dispatcher_builder/src/annotation/') ??
            false) &&
        annotation.element?.enclosingElement?.name == name;
  }
}

/// Runs the preflight builder
Builder runPreflight(BuilderOptions options) => PreflightBuilder();

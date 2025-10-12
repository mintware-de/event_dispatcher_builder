import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:event_dispatcher_builder/src/builder/generator/helpers.dart';

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
    for (var el in entryLib.children) {
      if (el is! ClassElement) {
        continue;
      }
      var extractedSubscribers = <ExtractedSubscriber>[];
      for (var m in el.methods) {
        for (var annotation in m.metadata.annotations) {
          if (!annotation.isLibraryAnnotation('Subscribe')) {
            continue;
          }
          if (m.formalParameters.length != 1) {
            throw Exception('A Subscriber must have exactly 1 parameter.');
          }

          var firstParameter = m.formalParameters.first;
          extractedSubscribers.add(ExtractedSubscriber(
            event: SymbolReference(
              symbolName: firstParameter.type.element!.name!,
              library:
                  firstParameter.type.element!.library?.uri.toString(),
            ),
            subscriber: SymbolReference(
              symbolName: m.displayName,
              library: m.library.uri.toString(),
            ),
          ));
        }
      }
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
}

/// Runs the preflight builder
Builder runPreflight(BuilderOptions options) => PreflightBuilder();

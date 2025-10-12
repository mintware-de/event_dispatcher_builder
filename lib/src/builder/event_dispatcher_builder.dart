import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:event_dispatcher_builder/src/builder/generator/helpers.dart';
import 'package:glob/glob.dart';

import 'dto/dto.dart';
import 'generator/constants.dart';
import 'generator/event_dispatcher/event_dispatcher.dart';

/// The ServiceProviderBuilder creates a service provider from the resulting
/// preflight.json files.
class ServiceProviderBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': [],
        r'.dart': [eventDispatcherPluginExtension],
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    if (!await buildStep.resolver.isLibrary(buildStep.inputId)) {
      return;
    }
    var libraryElement = (await buildStep.inputLibrary);

    var annotation = libraryElement.children
        .whereType<Element>()
        .map((el) => el.metadata.annotations.where(
            (m) => m.isLibraryAnnotation('GenerateEventDispatcherPlugin')))
        .fold(<ElementAnnotation>[], (prev, e) => [...prev, ...e]).firstOrNull;

    var isEntryPoint = annotation != null;
    if (!isEntryPoint) {
      return;
    }

    var constantValue = annotation.computeConstantValue()!;
    var pluginClassName =
        constantValue.getField('pluginClassName')!.toStringValue()!;

    String content = await _generateCode(buildStep, pluginClassName);
    await buildStep.writeAsString(
      buildStep.inputId.changeExtension(eventDispatcherPluginExtension),
      content,
    );
  }

  Future<String> _generateCode(
      BuildStep buildStep, String pluginClassName) async {
    final parts = <PreflightPart>[];
    final handlers = <ExtractedHandler>[];

    var assetReader = buildStep;
    await for (final input
        in assetReader.findAssets(Glob('**/*$preflightExtension'))) {
      var jsonContent = await assetReader.readAsString(input);
      var part = PreflightPart.fromJson(
        jsonDecode(jsonContent) as Map<String, dynamic>,
      );
      parts.add(part);
      handlers.addAll(part.handlers);
    }

    final emitter = DartEmitter.scoped(
      orderDirectives: true,
      useNullSafetySyntax: true,
    );

    final rawOutput = Library((l) => l.body.addAll([
          buildEventDispatcherClass(pluginClassName, handlers),
          buildExtension(pluginClassName),
        ])).accept(emitter).toString();

    final content =
        DartFormatter(languageVersion: DartFormatter.latestLanguageVersion)
            .format('''
// ignore_for_file: prefer_relative_imports, public_member_api_docs, implementation_imports
    $rawOutput
''');
    return content;
  }
}

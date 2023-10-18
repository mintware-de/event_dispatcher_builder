import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:build_runner_core/build_runner_core.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';

import 'dto/dto.dart';
import 'generator/event_dispatcher/event_dispatcher.dart';

/// The ServiceProviderBuilder creates a service provider from the resulting
/// preflight.json files.
class ServiceProviderBuilder implements Builder {
  /// The builder configuration.
  final Map<String, dynamic> config;

  /// Creates a new ServiceProviderBuilder.
  ServiceProviderBuilder(this.config);

  AssetId _outputAsset(BuildStep buildStep) {
    return buildStep.inputId
        .changeExtension('.event_dispatcher_builder.g.dart');
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    if (!await buildStep.resolver.isLibrary(buildStep.inputId)) {
      return;
    }
    var libraryElement = (await buildStep.inputLibrary);
    var isEntrypoint = libraryElement.topLevelElements.any(
      (el) => el.metadata.any(
        (a) => _isLibraryAnnotation(a, 'GenerateEventDispatcher'),
      ),
    );

    if (!isEntrypoint) {
      return;
    }

    var preflightFiles =
        Glob('**/*.event_dispatcher_builder.preflight.json', recursive: true);
    final parts = <PreflightPart>[];
    final handlers = <ExtractedHandler>[];

    AssetReader assetReader = buildStep;
    if (config['includePackageDependencies'] == true) {
      assetReader = FileBasedAssetReader(await PackageGraph.forThisPackage());
    }

    await for (final input in assetReader.findAssets(preflightFiles)) {
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
          buildEventDispatcherClass(config, handlers),
        ])).accept(emitter).toString();
    final content = DartFormatter().format('''
// ignore_for_file: prefer_relative_imports, public_member_api_docs
$rawOutput
''');
    await buildStep.writeAsString(_outputAsset(buildStep), content);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': [],
        r'.dart': ['.event_dispatcher_builder.g.dart'],
      };

  bool _isLibraryAnnotation(ElementAnnotation annotation, String name) {
    return annotation.element != null &&
        (annotation.element!.library?.source.uri.toString().startsWith(
                'package:event_dispatcher_builder/src/annotation/') ??
            false) &&
        annotation.element?.enclosingElement?.name == name;
  }
}

/// Builds the service provider
Builder buildEventDispatcher(BuilderOptions options) {
  log.info(options.config);
  return ServiceProviderBuilder(options.config);
}

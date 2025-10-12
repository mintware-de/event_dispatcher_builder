import 'package:build/build.dart';

import 'event_dispatcher_builder.dart';
import 'preflight_builder.dart';

/// Runs the preflight builder
Builder runPreflight(BuilderOptions options) => PreflightBuilder();

/// Builds the service provider
Builder buildEventDispatcher(BuilderOptions options) =>
    ServiceProviderBuilder();

import '../event_dispatcher_builder.dart';

/// Defines a plugin for the [EventDispatcherPlugin]
abstract interface class EventDispatcherPlugin {
  /// Returns a map that describes what handlers are supported
  Map<Type, HandlerDescriptor> provideSupportedHandlers();
}

/// Mark the file which contains this annotation as the entry point.
class GenerateEventDispatcherPlugin {
  /// Set this property for setting the class name of the generated
  /// event dispatcher plugin.
  final String pluginClassName;

  /// Mark this file as the entry point for the plugin
  const GenerateEventDispatcherPlugin({
    required this.pluginClassName,
  });
}

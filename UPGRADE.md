# Upgrade from v1 to v2

In version 2 we moved to a plugin based approach that is more maintainable and faster at build time.

## Renamed `@GenerateEventDispatcher()`

We renamed `@GenerateEventDispatcher` to `@GenerateEventDispatcherPlugin` and added a required named-parameter.
In small projects it should be enough to replace the old annotation with
`@GenerateEventDispatcherPlugin(pluginClassName: 'AppPlugin')`

## build.yaml

The build.yaml is no more required. If there is no more configuration in this file you can delete it.

## Event Dispatcher class name

We made the `EventDispatcher` class concrete. You should replace the old generated `DefaultEventDispatcher` with the
`EventDispatcher` class from the package.

## Plugin registration

Since the `dart build` command don't generate an event dispatcher itself but a EventDispatcherPlugin, you need to load
the plugin by calling the `useAppPlugin()` (name depends on pluginClassName) extension method on an instance of
EventDispatcher.

# Upgrade from v1.x.0 to v1.2.0

## Asynchronous subscribers

`EventDispatcher.dispatch` returns a Future. If any subscriber is async and depend
on modification of the event itself you need to `await` the result of the call.  
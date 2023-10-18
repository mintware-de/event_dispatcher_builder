[![GitHub license](https://img.shields.io/github/license/mintware-de/event_dispatcher_builder.svg)](https://github.com/mintware-de/event_dispatcher_builder/blob/main/LICENSE)
![GitHub issues](https://img.shields.io/github/issues/mintware-de/event_dispatcher_builder)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/mintware-de/event_dispatcher_builder/dart.yml?branch=main)
[![Pub](https://img.shields.io/pub/v/event_dispatcher_builder.svg)](https://pub.dartlang.org/packages/event_dispatcher_builder)
![Pub Points](https://img.shields.io/pub/points/event_dispatcher_builder)
![Pub Publisher](https://img.shields.io/pub/publisher/event_dispatcher_builder)
![Pub Popularity](https://img.shields.io/pub/popularity/event_dispatcher_builder)
![Pub Likes](https://img.shields.io/pub/likes/event_dispatcher_builder)

# Event Dispatcher

A event dispatcher for dart.

## Installation

Follow the steps described on this page:
https://pub.dev/packages/event_dispatcher_builder/install

You also need to install the [build_runner](https://pub.dev/packages/build_runner/install) package.

## Configuration

To customize the builder, create a `build.yaml` beside your `pubsepc.yaml` with this content:

```yaml
targets:
  $default:
    auto_apply_builders: true
    builders:
      event_dispatcher_builder|buildEventDispatcher:
        options:
          eventDispatcherClassName: 'DefaultEventDispatcher' # class name of the event dispatcher
          includePackageDependencies: false # True if subscribers from dependencies should be included.
```

## Annotations

### `@Subscribe()`

This annotation applies on methods. It is used to tell the generator that this method handles specific events.
The method MUST HAVE one parameter with the type of the event. What type this is, is up to you.

Example:

```dart
// The event
class TestEvent {
  final String name;

  TestEvent({
    required this.name,
  });
}

class FakeHandler {
  List<String> eventTexts = [];

  // The method that listens to the event
  @Subscribe()
  void onTestEvent(TestEvent event) {
    eventTexts.add(event.name);
  }
}
```

### `@GenerateEventDispatcher()`

This annotation SHOULD only occur once at the entry point of your application. It is used for generating
the output file that contains your event dispatcher.

## Usage

After annotating your event subscriber methods with `@Subscribe` and adding the `@GenerateEventDispatcher()`
to the `main` function, you need to run `dart run build_runner build` or ` flutter pub run build_runner build`.

You should find a new file named `*.event_dispatcher_builder.g.dart` next to the file you added the annotation.
> This generated file should not be version controlled.

Import this file and create/set up a new instance of your event dispatcher.

```dart
void main() {
  // The class name depends on your configuration
  var eventDispatcher = DefaultEventDispatcher();

  eventDispatcher.addHandler(FakeHandler());
}

```

To dispatch events you can use the `EventDispatcher.dispatch(event)` method.

```dart
void main() {
  var eventDispatcher = DefaultEventDispatcher();

  eventDispatcher.addHandler(FakeHandler());

  // Dispatch a new event
  var event = TestEvent(name: 'Foo Bar');
  dispatcher.dispatch(event);
}

```

That's it 🙌

## Automating the addHandler stuff
In large projects it can be tedious to manage all the addHandler stuff. Especially if the event handlers require
additional services.

To optimize this, you can install the [catalyst_builder](https://pub.dev/packages/catalyst_builder) package which
 generates a dependency injection container.

After installing and configuring it, you can create a `HandlerRegistry` class which is preloaded and add all this kind of code from above:

```dart
@Service()
@Preload()
class HandlerRegistry {

  HandlerRegistry(
    EventDispatcher dispatcher,
    @Inject(tag: #eventListener) List<Object> listeners,
  ) {

    for (var listener in listeners) {
      dispatcher.addHandler(listener, listener.runtimeType);
    }

  }
}
```

Your event subscriber classes need an additional annotation:
```dart
@Service(tags: [#eventListener]) // new
class FakeHandler {
  List<String> eventTexts = [];

  @Subscribe()
  void onTestEvent(TestEvent event) {
    eventTexts.add(event.name);
  }
}
```

Finally, you need to update the `main` annotations:
```dart
@GenerateEventDispatcher()
// New
@GenerateServiceProvider()
@ServiceMap(services: {
  // Register your event dispatcher inside the service container as a EventDispatcher 
  MyEventDispatcher: Service(
    lifetime: ServiceLifetime.singleton,
    exposeAs: EventDispatcher,
  )
})
void main(List<String> arguments) {
  // Load the provider 
  var provider = DefaultServiceProvider();
  // boot it
  provider.boot();

  // get the event dispatcher
  var dispatcher = provider.resolve<EventDispatcher>();

  // dispatch a event
  var event = TestEvent(name: 'Foo Bar');
  dispatcher.dispatch(event);
}
```


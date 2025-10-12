import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:event_dispatcher_builder_example/example.catalyst_builder.plugin.g.dart';
import 'package:event_dispatcher_builder_example/example.dart';
import 'package:event_dispatcher_builder_example/example.event_dispatcher_builder.plugin.g.dart';

void main(List<String> arguments) {
  var provider = ServiceContainer();
  provider.register((_) => EventDispatcher()..useAppEventPlugin());
  provider.useAppPlugin();
  provider.boot();

  var dispatcher = provider.resolve<EventDispatcher>();
  dispatcher.useAppEventPlugin();

  var event = TestEvent(name: 'Foo Bar');
  dispatcher.dispatch(event);

  var handler = provider.resolve<FakeHandler>();
  print(handler.eventTexts);

  print(event.name);
}

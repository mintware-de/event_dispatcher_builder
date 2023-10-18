import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:event_dispatcher_builder_example/example.dart';

import 'package:event_dispatcher_builder_example/example.catalyst_builder.g.dart';

void main(List<String> arguments) {
  var provider = DefaultServiceProvider();
  provider.boot();

  var dispatcher = provider.resolve<EventDispatcher>();

  var event = TestEvent(name: 'Foo Bar');
  dispatcher.dispatch(event);

  var handler = provider.resolve<FakeHandler>();
  print(handler.eventTexts);

  print(event.name);
}

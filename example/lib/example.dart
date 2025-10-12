library event_dispatcher_builder_example;

import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:catalyst_builder_contracts/catalyst_builder_contracts.dart';
import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';

import 'example.event_dispatcher_builder.g.dart';

export 'example.event_dispatcher_builder.g.dart';
export 'src/fake_handler.dart';
export 'src/async_fake_handler.dart';
export 'src/test_event.dart';

@GenerateEventDispatcher()
@GenerateServiceContainerPlugin(pluginClassName: 'App')
@ServiceMap(services: {
  MyEventDispatcher: Service(
    lifetime: ServiceLifetime.singleton,
    exposeAs: EventDispatcher,
  )
})
void main() {}

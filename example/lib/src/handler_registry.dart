import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:event_dispatcher_builder_example/example.dart';

@Service()
@Preload()
class HandlerRegistry {
  HandlerRegistry(
    EventDispatcher dispatcher,
    @Inject(tag: #eventListener) List<Object> listeners,
  ) {
    for (var listener in listeners) {
      (dispatcher as MyEventDispatcher)
          .addHandler(listener, listener.runtimeType);
    }
  }
}

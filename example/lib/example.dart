import 'package:catalyst_builder_contracts/catalyst_builder_contracts.dart';
import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';

export 'src/async_fake_handler.dart';
export 'src/fake_handler.dart';
export 'src/test_event.dart';

@GenerateEventDispatcherPlugin(pluginClassName: 'AppEventPlugin')
@GenerateServiceContainerPlugin(pluginClassName: 'AppPlugin')
void main() {}

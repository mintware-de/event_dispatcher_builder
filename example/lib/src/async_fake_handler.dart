import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';

import 'test_event.dart';

@Service(tags: [#eventListener])
class AsyncFakeHandler {
  List<String> eventTexts = [];

  @Subscribe()
  Future<void> onTestEvent(TestEvent event) async {
    await Future.delayed(Duration(seconds: 2), () {});
    eventTexts.add(event.name);
  }
}

import 'package:catalyst_builder/catalyst_builder.dart';
import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';

import 'priorized_event.dart';
import 'test_event.dart';

@Service(tags: [#eventListener])
class FakeHandler {
  List<String> eventTexts = [];

  @Subscribe()
  void onTestEvent(TestEvent event) {
    eventTexts.add(event.name);
  }

  @Subscribe(priority: 10)
  Future<void> onPriorityEvent(PriorityEvent event) async {
    if (event.data.isEmpty) {
      event.data = 'fake handler';
    }
  }
}

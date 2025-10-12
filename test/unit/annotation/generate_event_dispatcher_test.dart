import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:test/test.dart';

void main() {
  test('exists', () {
    const annotation = GenerateEventDispatcherPlugin(pluginClassName: 'A');
    expect(annotation, TypeMatcher<GenerateEventDispatcherPlugin>());
  });
}

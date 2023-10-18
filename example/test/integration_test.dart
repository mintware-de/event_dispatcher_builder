import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:test/test.dart';
import 'package:event_dispatcher_builder_example/example.dart';

class InvalidHandler {}

void main() {
  late EventDispatcher eventDispatcher;
  setUp(() {
    eventDispatcher = MyEventDispatcher();
  });

  test('inheritance', () {
    expect(eventDispatcher, TypeMatcher<EventDispatcher>());
  });

  test('Event dispatching', () {
    var handler = FakeHandler();
    expect(handler.eventTexts, isEmpty);
    eventDispatcher.dispatch(TestEvent(name: 'foo'));
    expect(handler.eventTexts, isEmpty);
    eventDispatcher.addHandler<FakeHandler>(handler);
    eventDispatcher.dispatch(TestEvent(name: 'foo'));
    expect(handler.eventTexts, equals(['foo']));
    eventDispatcher.dispatch(TestEvent(name: 'bar'));
    expect(handler.eventTexts, equals(['foo', 'bar']));
  });

  test('Throws a HandlerNotSupportException', () {
    expect(
      () => eventDispatcher.addHandler(InvalidHandler()),
      throwsA(TypeMatcher<HandlerNotSupportedException>()),
    );
  });
}

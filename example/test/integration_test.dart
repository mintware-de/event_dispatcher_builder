import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:event_dispatcher_builder_example/example.event_dispatcher_builder.plugin.g.dart';
import 'package:test/test.dart';
import 'package:event_dispatcher_builder_example/example.dart';

class InvalidHandler {}

void main() {
  late EventDispatcher eventDispatcher;
  setUp(() {
    eventDispatcher = EventDispatcher();
    eventDispatcher.useAppEventPlugin();
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

  test('Async event dispatching', () async {
    var handler = AsyncFakeHandler();
    expect(handler.eventTexts, isEmpty);
    eventDispatcher.addHandler(handler);
    eventDispatcher.addHandler(FakeHandler());
    var future = eventDispatcher.dispatch(TestEvent(name: '1'));
    expect(handler.eventTexts, isEmpty);
    await future;
    expect(handler.eventTexts, equals(['1']));
  });

  test('Throws a HandlerNotSupportException', () {
    expect(
      () => eventDispatcher.addHandler(InvalidHandler()),
      throwsA(TypeMatcher<HandlerNotSupportedException>()),
    );
  });
}

import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class FooException extends EventDispatcherException {
  FooException(String message) : super(message);
}

void main() {
  test('ToString', () {
    expect(FooException('test').message, equals('test'));
    expect(
      FooException('test').toString(),
      equals('EventDispatcherException: test'),
    );
  });
}

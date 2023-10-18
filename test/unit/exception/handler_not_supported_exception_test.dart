import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:test/test.dart';

void main() {
  test('inheritance', () {
    expect(
      HandlerNotSupportedException(String),
      TypeMatcher<EventDispatcherException>(),
    );
  });

  test('message', () {
    var msg = '''
The handler "String" is not supported.
Ensure that you've decorated at least one method with @Subscribe()'''
        .trim(); // ignore: lines_longer_than_80_chars

    expect(HandlerNotSupportedException(String).message, equals(msg));
    expect(HandlerNotSupportedException(String).toString(), contains(msg));
  });
}

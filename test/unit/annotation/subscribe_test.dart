import 'package:event_dispatcher_builder/event_dispatcher_builder.dart';
import 'package:test/test.dart';

void main() {
  test('exists', () {
    const annotation = Subscribe();
    expect(annotation, TypeMatcher<Subscribe>());
  });
}

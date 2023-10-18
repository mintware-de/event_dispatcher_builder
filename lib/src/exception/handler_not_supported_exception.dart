import '../../event_dispatcher_builder.dart';

/// This exception is thrown if you try to register a handler that does not have
/// any methods decorated with @[Subscribe].
class HandlerNotSupportedException extends EventDispatcherException {
  /// The type of the handler
  final Type? type;

  /// HandlerNotSupportedException constructor.
  HandlerNotSupportedException(this.type)
      : super(
          '''
The handler "$type" is not supported.
Ensure that you've decorated at least one method with @Subscribe()
'''
              .trim(),
        );
}

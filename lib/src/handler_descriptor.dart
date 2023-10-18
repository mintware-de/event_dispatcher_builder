import 'subscription.dart';

/// This is class describes a event handler.
/// At build time, the build_runner will extract the Subscribe
class HandlerDescriptor<THandler> {
  /// This list contains the extracted subscription factories of the [THandler].
  final List<SubscriptionFactory<THandler, dynamic>> factories;

  /// HandlerDescriptor constructor.
  const HandlerDescriptor([this.factories = const []]);
}

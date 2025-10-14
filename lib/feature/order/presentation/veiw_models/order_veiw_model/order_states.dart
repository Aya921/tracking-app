import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/feature/order/domain/entity/order_driver_entity.dart';

class OrderStates extends Equatable {
  final RequestState requestState;
  final OrderDriverEntity? orders;
  final String? errorMessage;

  const OrderStates({
    this.requestState = RequestState.initial,
    this.orders,
    this.errorMessage,
  });

  OrderStates copyWith({
    RequestState? requestState,
    OrderDriverEntity? orders,
    String? errorMessage,
  }) {
    return OrderStates(
      requestState: requestState ?? this.requestState,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [requestState, orders, errorMessage];
}

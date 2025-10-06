import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/feature/order/domain/entity/order_driver_entity.dart';
import 'package:tracking_app/feature/order/domain/repository/order_repository.dart';
import '../../../domain/usecase/get_all_driver_orders.dart';
import 'order_events.dart';
import 'order_states.dart';

@singleton
class OrderBloc extends Bloc<OrderEvent, OrderStates> {
  final GetAllDriverOrdersUseCase _getDriverOrdersUseCase;


  OrderBloc(this._getDriverOrdersUseCase, OrderRepository orderRepository) : super(const OrderStates()) {
    on<GetDriverOrdersEvent>(_getDriverOrders);
    on<RefreshDriverOrdersEvent>(_refreshOrders);
  }

  Future<void> _getDriverOrders(
      GetDriverOrdersEvent event,
      Emitter<OrderStates> emit,
      ) async {
    emit(state.copyWith(requestState: RequestState.loading));

    final result = await _getDriverOrdersUseCase.call(
      page: 1,
      limit: 10,
    );

    switch (result) {
      case SucessResult<OrderDriverEntity>():
        if (kDebugMode) {
          print('Parsed Orders: ${result.sucessResult.orders.length}');
        }
        for (final order in result.sucessResult.orders) {
          if (kDebugMode) {
            print('Order: ${order.user.firstName}, Store: ${order.store.name}, Price: ${order.orderInfoEntity.totalPrice}');
          }
        }
        emit(
          state.copyWith(
            requestState: RequestState.success,
            orders: result.sucessResult,
          ),
        );
      case FailedResult<OrderDriverEntity>():
        emit(
          state.copyWith(
            requestState: RequestState.error,
            errorMessage: result.errorMessage,
          ),
        );
    }
  }

  Future<void> _refreshOrders(
      RefreshDriverOrdersEvent event,
      Emitter<OrderStates> emit,
      ) async {
    await _getDriverOrders(const GetDriverOrdersEvent(page: 1, limit: 10), emit);
  }
}
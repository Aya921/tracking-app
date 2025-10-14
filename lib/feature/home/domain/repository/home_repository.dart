import 'package:tracking_app/core/api_result/result.dart';

import 'package:tracking_app/feature/home/domain/entity/start_order_request_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/update_order_response_entity.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/order/domain/entity/remote_data_entity.dart';

abstract interface class HomeRepository {
  Future<Result<List<OrderEntity>?>> getAllPendingOrders();
  Future<Result<void>> saveDataToLocalStorage(List<OrderEntity>? orders);
  Future<Result<List<OrderEntity>?>> getAllSavedOrders();
  Future<Result<void>> deleteOrder(String orderId);
  Future<Result<OrderResponseEntity>> startOrder(String orderId);
  Future<Result<OrderResponseEntity>> updateOrderState(UpdateOrderRequestEntity req , String orderId);
  Future<Result<void>> addDateToRemote(RemoteDataEntity remoteData);
  Stream<Result<RemoteDataEntity>> getOrderFromRemote(String orderId);
}

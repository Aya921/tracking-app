import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';

abstract interface class HomeLocalDataSource {
 
  Future<Result<void>> saveDataToLocalStorage(List<OrderEntity>? orders);
  Future<Result<List<OrderEntity>?>> getAllSavedOrders();
  Future<Result<void>> deleteOrder(String orderId);
  
}

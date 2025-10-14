
import '../../../../core/api_result/result.dart';
import '../entity/order_driver_entity.dart';

abstract interface class OrderRepository {
  Future<Result<OrderDriverEntity>> getDriverOrders({
    required int page,
    required int limit,
  });
}

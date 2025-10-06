import '../../../../core/api_result/result.dart';
import '../../domain/entity/order_driver_entity.dart';

abstract interface class OrderRemoteDataSource {
  Future<Result<OrderDriverEntity>> getDriverOrders({
    required int page,
    required int limit,
  });
}

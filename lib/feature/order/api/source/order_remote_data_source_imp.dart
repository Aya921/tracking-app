import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/safe_api_call/safe_api_call.dart';
import 'package:tracking_app/feature/order/domain/entity/order_driver_entity.dart';
import '../../data/source/order_remote_data_source.dart';
import '../client/api _service/order_api_service.dart';

@Injectable(as: OrderRemoteDataSource)
class OrderRemoteDataSourceImp implements OrderRemoteDataSource {
  final OrderApiService _orderApiService;

  OrderRemoteDataSourceImp(this._orderApiService);

  @override
  Future<Result<OrderDriverEntity>> getDriverOrders({
    required int page,
    required int limit,
  }) {
    return safeCall(() async {
      final driverOrdersResponse = await _orderApiService.getAllDriverOrders(page, limit);
      return driverOrdersResponse.toEntity();
    });
  }


}

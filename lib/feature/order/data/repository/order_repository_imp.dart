import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';

import 'package:tracking_app/feature/order/domain/entity/order_driver_entity.dart';

import '../../domain/repository/order_repository.dart';
import '../source/order_remote_data_source.dart';

@Injectable(as: OrderRepository)
class OrderRepositoryImp implements OrderRepository {
  final OrderRemoteDataSource _orderRemoteDataSource;

  OrderRepositoryImp(this._orderRemoteDataSource);

  @override
  Future<Result<OrderDriverEntity>> getDriverOrders({
    required int page,
    required int limit,
  }) {
    return _orderRemoteDataSource.getDriverOrders(page: page, limit: limit);
  }
}
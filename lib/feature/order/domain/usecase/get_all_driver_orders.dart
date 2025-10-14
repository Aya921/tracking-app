import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/order/domain/entity/order_driver_entity.dart';
import 'package:tracking_app/feature/order/domain/repository/order_repository.dart';

@injectable
class GetAllDriverOrdersUseCase {
  final OrderRepository _orderRepository;

  GetAllDriverOrdersUseCase(this._orderRepository);

  Future<Result<OrderDriverEntity>> call({
    required int page,
    required int limit,
  }) async {
    return await _orderRepository.getDriverOrders(
      page: page,
      limit: limit,
    );
  }
}

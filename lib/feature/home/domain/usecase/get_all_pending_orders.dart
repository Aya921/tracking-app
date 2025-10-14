import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';

@injectable
class GetAllPendingOrdersUseCase {
  final HomeRepository _homeRepository;

  GetAllPendingOrdersUseCase(this._homeRepository);

  Future<Result<List<OrderEntity>?>> getAllPendingOrders() async {
    return await _homeRepository.getAllPendingOrders();
  }
}

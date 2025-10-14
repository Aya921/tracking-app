import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';

@injectable
class GetAllSavedOrdersUseCase {
  final HomeRepository _homeRepository;

  GetAllSavedOrdersUseCase(this._homeRepository);

    Future<Result<List<OrderEntity>?>> getAllSavedOrders() async {
    return await _homeRepository.getAllSavedOrders();
  }
}

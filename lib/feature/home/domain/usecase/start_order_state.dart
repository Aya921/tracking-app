import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/home/domain/entity/update_order_response_entity.dart';
import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';

@injectable
class StartOrderStateUseCase {
  final HomeRepository _homeRepository;

  StartOrderStateUseCase(this._homeRepository);
  Future<Result<OrderResponseEntity>> startOrder(String orderId) async {
    return await _homeRepository.startOrder(orderId);
  }
}

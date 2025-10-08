import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/home/domain/entity/start_order_response_entity.dart';
import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';

@injectable
class StartOrderUseCase {
  final HomeRepository _homeRepository;

  StartOrderUseCase(this._homeRepository);
  Future<Result<StartOrderResponseEntity>> startOrder(String orderId) async {
    return await _homeRepository.startOrder(orderId);
  }
}

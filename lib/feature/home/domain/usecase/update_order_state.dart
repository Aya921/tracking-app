import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';

@injectable
class UpdateOrderStateUseCase {
  final HomeRepository _homeRepository;

  UpdateOrderStateUseCase(this._homeRepository);

  Future<Result<void>> updateOrderState(String orderId, String newState) async {
    return await _homeRepository.updateOrderState(orderId, newState);
  }
}

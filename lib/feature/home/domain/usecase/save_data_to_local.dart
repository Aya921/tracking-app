import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';

@injectable
class SaveDataToLocalUseCase {
  final HomeRepository _homeRepository;

  SaveDataToLocalUseCase(this._homeRepository);

  Future<Result<void>> saveDataToLocalStorage(List<OrderEntity>? orders) async {
    return await _homeRepository.saveDataToLocalStorage(orders);
  }
}

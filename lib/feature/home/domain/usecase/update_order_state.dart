import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/home/domain/entity/start_order_request_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/update_order_response_entity.dart';
import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';

@injectable
class UpdateOrderStateUseCase {
  final HomeRepository _homeRepository;

  UpdateOrderStateUseCase(this._homeRepository);
  Future<Result<OrderResponseEntity>> updateOrderState(UpdateOrderRequestEntity req , String orderId) async {
    return await _homeRepository.updateOrderState( req,orderId);
  }
}

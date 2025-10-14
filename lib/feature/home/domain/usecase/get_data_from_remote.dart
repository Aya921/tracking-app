import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';

@injectable
class GetDataFromRemoteUseCase {
  final HomeRepository _homeRepository;

  GetDataFromRemoteUseCase(this._homeRepository);

   Stream<Result<RemoteDataEntity>> getOrderFromRemote(String orderId){
    return _homeRepository.getOrderFromRemote(orderId);
  }
}

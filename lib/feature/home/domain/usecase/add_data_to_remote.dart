import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/home/domain/repository/home_repository.dart';

@injectable
class AddDataToRemoteUseCase {
  final HomeRepository _homeRepository;

  AddDataToRemoteUseCase(this._homeRepository);

   Future<Result<void>> addDateToRemote(RemoteDataEntity remoteData) async {
    return await _homeRepository.addDateToRemote(remoteData);
  }
}

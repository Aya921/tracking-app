import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/common/entity/driver_entity.dart';
import 'package:tracking_app/feature/profile/domain/repository/profile_repository.dart';

@injectable
class GetLoggedDriverUseCase {
  final ProfileRepository _profileRepository;
  GetLoggedDriverUseCase(this._profileRepository);

  Future<Result<DriverEntity>> getLoggedDriver() async {
    return await _profileRepository.getLoggedDriver();
  }


}

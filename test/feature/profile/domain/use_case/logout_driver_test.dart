import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/profile/domain/repository/profile_repository.dart';
import 'package:tracking_app/feature/profile/domain/use_case/logout_driver.dart';

import 'change_profile_use_case_test.mocks.dart';
@GenerateMocks([ProfileRepository])
void main() {
  late MockProfileRepository mockProfileRepository;
  late LogoutDriverUseCase logoutDriverUseCase;
  setUp((){
    mockProfileRepository=MockProfileRepository();
    logoutDriverUseCase=LogoutDriverUseCase(mockProfileRepository);
    provideDummy<Result<void>>(
        FailedResult<void>("DriverEntity Error")
    );
  });
  test('should return SuccessResult when repo success', ()async{
    when(mockProfileRepository.logoutDriver()).thenAnswer((_)async=>
        SucessResult(null));
    final result=await logoutDriverUseCase.logoutDriver();
    expect(result, isA<SucessResult>());
    expect((result as SucessResult).sucessResult, null);
    verify(mockProfileRepository.logoutDriver()).called(1);
  });
  test("should  return Failed Result when repo  failed", ()async{
    const error="some thing went Wrong";
    when(mockProfileRepository.logoutDriver()).thenAnswer((_)async=>
        FailedResult(error));
    final result=await logoutDriverUseCase.logoutDriver();
    expect(result, isA<FailedResult>());
    expect((result as FailedResult).errorMessage, error);
    verify(mockProfileRepository.logoutDriver()).called(1);
  });


}
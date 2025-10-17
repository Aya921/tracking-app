import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/profile/data/repository/profile_repository_impl.dart';
import 'package:tracking_app/feature/profile/domain/entity/edit_profile_entity.dart';
import 'package:tracking_app/feature/profile/domain/use_case/upload_driver_photo_use_case.dart';

import 'upload_driver_photo_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepositoryImpl])
void main() {
  late UploadDriverPhotoUseCase uploadDriverPhotoUseCase;
  late MockProfileRepositoryImpl mockProfileRepositoryImpl;

  setUpAll(() {
    provideDummy<Result<EditProfileEntity>>(FailedResult("Dummy Error"));
    provideDummy<Result<String>>(SucessResult<String>("success"));
    mockProfileRepositoryImpl = MockProfileRepositoryImpl();
    uploadDriverPhotoUseCase = UploadDriverPhotoUseCase(
      mockProfileRepositoryImpl,
    );
  });

  group("upload photo usecase test", () {
    final fakeFile = File('path/to/photo.jpg');

    test("should return SuccessResult when AuthRepositry returns success", ()async {
      //Arrange
      when(mockProfileRepositoryImpl.uploadDriverPhoto(fakeFile)).thenAnswer(
        (_) async => SucessResult<String>("https://fakeurl.com/photo.jpg"),
      );

      //Act
      final result =await uploadDriverPhotoUseCase.call(fakeFile);

      //Assert
      expect(result, isA<SucessResult<String>>());
      final success = result as SucessResult<String>;
      expect(success.sucessResult, "https://fakeurl.com/photo.jpg");
      verify(mockProfileRepositoryImpl.uploadDriverPhoto(any)).called(1);
    });

    test("should return FailedResult when AuthRepositry returns failure", () async{
       //Arrange
      when(mockProfileRepositoryImpl.uploadDriverPhoto(fakeFile)).thenAnswer(
        (_) async =>  FailedResult<String>("Upload failed"),
      );
      
       //Act
      final result =await uploadDriverPhotoUseCase.call(fakeFile);

     //Assert
      expect(result, isA<FailedResult<String>>());
      final failure = result as FailedResult<String>;
      expect(failure.errorMessage, "Upload failed");
      verify(mockProfileRepositoryImpl.uploadDriverPhoto(any)).called(1);
    },);
  });
}

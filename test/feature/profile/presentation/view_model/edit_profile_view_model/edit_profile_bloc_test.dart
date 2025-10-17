import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/feature/profile/api/models/edit_profile/request/edit_profile_request.dart';
import 'package:tracking_app/feature/profile/domain/entity/driver_info_entity.dart';
import 'package:tracking_app/feature/profile/domain/entity/edit_profile_entity.dart';
import 'package:tracking_app/feature/profile/domain/use_case/edit_profile_use_case.dart';
import 'package:tracking_app/feature/profile/domain/use_case/edit_vehicle_use_case.dart';
import 'package:tracking_app/feature/profile/domain/use_case/upload_driver_photo_use_case.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/edit_profile_view_model/edit_profile_bloc.dart';

import 'edit_profile_bloc_test.mocks.dart';

@GenerateMocks([UploadDriverPhotoUseCase,EditProfileUseCase,EditVehicleUseCase])
void main() {
  provideDummy<Result<EditProfileEntity>>(FailedResult("Dummy Error"));
  provideDummy<Result<String>>(SucessResult<String>("success"));
  late MockUploadDriverPhotoUseCase mockUploadDriverPhotoUseCase;
  late MockEditProfileUseCase mockEditProfileUseCase;
  late MockEditVehicleUseCase mockEditVehicleUseCase;
  late EditProfileBloc bloc;

  setUp(() {
    mockUploadDriverPhotoUseCase = MockUploadDriverPhotoUseCase();
    mockEditProfileUseCase = MockEditProfileUseCase();
    mockEditVehicleUseCase = MockEditVehicleUseCase();

    bloc = EditProfileBloc(
      mockUploadDriverPhotoUseCase,
      mockEditProfileUseCase,
      mockEditVehicleUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('UploadDriverPhotoEvent', () {
    final photo = File('path/to/photo.jpg');

    blocTest<EditProfileBloc, EditProfileState>(
      'emits [loading, success] when upload succeeds',
      build: () {
        when(mockUploadDriverPhotoUseCase.call(photo))
            .thenAnswer((_) async => SucessResult<String>('uploaded_url'));
        return bloc;
      },
      act: (bloc) => bloc.add(UploadDriverPhotoEvent(photo)),
      expect: () => [
        const EditProfileState(uploadPhotoRequestState: RequestState.loading),
        EditProfileState(
          uploadPhotoRequestState: RequestState.success,
          uploadPhotoResponse: 'uploaded_url',
          selectedPhoto: photo,
        ),
      ],
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'emits [loading, error] when upload fails',
      build: () {
        when(mockUploadDriverPhotoUseCase.call(photo))
            .thenAnswer((_) async => FailedResult<String>('upload failed'));
        return bloc;
      },
      act: (bloc) => bloc.add(UploadDriverPhotoEvent(photo)),
      expect: () => [
        const EditProfileState(uploadPhotoRequestState: RequestState.loading),
        const EditProfileState(
          uploadPhotoRequestState: RequestState.error,
          uploadPhotoErrorMessage: 'upload failed',
        ),
      ],
    );
  });

  group('EditBtnSubmitEvent', () {
    final request = EditProfileRequest(firstName: 'Ali');
    const entity = EditProfileEntity(info: DriverInfoEntity(
      firstName: "Ali"
    ));

    blocTest<EditProfileBloc, EditProfileState>(
      'emits [loading, success] when edit profile succeeds',
      build: () {
        when(mockEditProfileUseCase.call(request))
            .thenAnswer((_) async => SucessResult<EditProfileEntity>(entity));
        return bloc;
      },
      act: (bloc) => bloc.add(EditBtnSubmitEvent(request)),
      expect: () => [
        const EditProfileState(editProfileRequestState: RequestState.loading),
        const EditProfileState(
          editProfileRequestState: RequestState.success,
          editedProfileInfo: entity,
        ),
      ],
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'emits [loading, error] when edit profile fails',
      build: () {
        when(mockEditProfileUseCase.call(request))
            .thenAnswer((_) async => FailedResult<EditProfileEntity>('error'));
        return bloc;
      },
      act: (bloc) => bloc.add(EditBtnSubmitEvent(request)),
      expect: () => [
        const EditProfileState(editProfileRequestState: RequestState.loading),
        const EditProfileState(
          editProfileRequestState: RequestState.error,
          editProfileErrorMessage: 'error',
        ),
      ],
    );
  });

}

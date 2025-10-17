import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/constants/app_widgets_keys.dart';
import 'package:tracking_app/core/l10n/translations/app_localizations.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/feature/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/feature/profile/presentation/view_model/edit_profile_view_model/edit_profile_bloc.dart';
import 'package:tracking_app/feature/profile/presentation/views/screens/edit_profile_screen.dart';

import 'edit_profile_screen_test.mocks.dart';

@GenerateMocks([EditProfileBloc])
void main() {
  late MockEditProfileBloc mockEditProfileBloc;

  const fakeUser = DriverEntity(
    id: '111',
    country: 'Egypt',
    firstName: 'Rana',
    lastName: 'Gebril',
    vehicleType: 'car',
    vehicleNumber: '1234',
    vehicleLicense: '',
    nid: '7894561231234',
    nidImg: '',
    email: 'rana@gmail.com',
    gender: 'female',
    phone: '01234567891',
    photo: '',
    role: '',
    createdAt: '',
  );

  setUp(() {
    mockEditProfileBloc = MockEditProfileBloc();
    when(mockEditProfileBloc.state).thenReturn(const EditProfileState());
    when(
      mockEditProfileBloc.stream,
    ).thenAnswer((_) => Stream.fromIterable([const EditProfileState()]));

    getIt.registerFactory<EditProfileBloc>(() => mockEditProfileBloc);
  });

  tearDown(getIt.reset);

  Widget prepareWidget() {
    return SizeProvider(
      baseSize: const Size(375, 812),
      height: 812,
      width: 375,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<EditProfileBloc>.value(
          value: mockEditProfileBloc,
          child: const EditProfileScreen(user: fakeUser),
        ),
      ),
    );
  }

  group("EditProfileScreen Widget Tests", () {
    // --- STRUCTURE TESTS ---
    testWidgets("renders all main fields", (tester) async {
      await tester.pumpWidget(prepareWidget());
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key(AppWidgetsKeys.profilePhoto)),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(AppWidgetsKeys.firstNameField)),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(AppWidgetsKeys.lastNameField)),
        findsOneWidget,
      );
      expect(find.byKey(const Key(AppWidgetsKeys.emailField)), findsOneWidget);
      expect(find.byKey(const Key(AppWidgetsKeys.phoneField)), findsOneWidget);
      expect(
        find.byKey(const Key(AppWidgetsKeys.genderSection)),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key(AppWidgetsKeys.passwordField)),
        findsOneWidget,
      );
      expect(find.byKey(const Key(AppWidgetsKeys.editButton)), findsOneWidget);
    });

    // --- BEHAVIOUR TESTS ---

    testWidgets(
      "shows success SnackBar when editProfileRequestState == success",
      (tester) async {
        when(mockEditProfileBloc.state).thenReturn(
          const EditProfileState(
            editProfileRequestState: RequestState.success,
            editProfileErrorMessage: "",
          ),
        );
        when(mockEditProfileBloc.stream).thenAnswer(
          (_) => Stream.fromIterable([
            const EditProfileState(
              editProfileRequestState: RequestState.success,
            ),
          ]),
        );

        await tester.pumpWidget(prepareWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets("shows error SnackBar when editProfileRequestState == error", (
      tester,
    ) async {
      when(mockEditProfileBloc.state).thenReturn(
        const EditProfileState(
          editProfileRequestState: RequestState.error,
          editProfileErrorMessage: "Update failed",
        ),
      );
      when(mockEditProfileBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          const EditProfileState(
            editProfileRequestState: RequestState.error,
            editProfileErrorMessage: "Update failed",
          ),
        ]),
      );

      await tester.pumpWidget(prepareWidget());
      await tester.pumpAndSettle();

      expect(find.text("Update failed"), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets("does not trigger event if no changes made", (tester) async {
      when(mockEditProfileBloc.state).thenReturn(const EditProfileState());
      when(
        mockEditProfileBloc.stream,
      ).thenAnswer((_) => Stream.fromIterable([const EditProfileState()]));

      await tester.pumpWidget(prepareWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key(AppWidgetsKeys.editButton)));
      await tester.pump();

      verifyNever(mockEditProfileBloc.add(any));
    });
  });
}

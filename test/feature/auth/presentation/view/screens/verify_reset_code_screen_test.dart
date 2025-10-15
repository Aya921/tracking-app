import 'dart:async';

import 'package:fake_async/fake_async.dart';
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
import 'package:tracking_app/core/routes/app_route.dart';
import 'package:tracking_app/feature/auth/presentation/view/screens/verify_reset_code_screen.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/forget_password_view_model/forget_password_bloc.dart';
import 'package:tracking_app/feature/auth/presentation/view_model/forget_password_view_model/forget_password_state.dart';

import 'verify_reset_code_screen_test.mocks.dart';

@GenerateMocks([ForgetPasswordBloc])
void main() {
  late MockForgetPasswordBloc mockForgetPasswordBloc;
  late StreamController<ForgetPasswordState> blocController;

  setUp(() {
    blocController = StreamController<ForgetPasswordState>.broadcast();
    mockForgetPasswordBloc = MockForgetPasswordBloc();

    when(mockForgetPasswordBloc.state).thenReturn(const ForgetPasswordState());
    when(
      mockForgetPasswordBloc.stream,
    ).thenAnswer((_) => blocController.stream);

    getIt.registerFactory<ForgetPasswordBloc>(() => mockForgetPasswordBloc);
  });

  tearDown(() {
    blocController.close();
    getIt.reset();
  });

  Widget prepareWidget() {
    return SizeProvider(
      baseSize: const Size(375, 812),
      height: 812,
      width: 375,
      child:
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: (settings) {
          if (settings.name == AppRoute.resetPasswordScreen) {
            return MaterialPageRoute(builder: (_) => const Scaffold());
          }
          return null;
        },
        home: BlocProvider<ForgetPasswordBloc>.value(
          value: mockForgetPasswordBloc,
          child: const VerifyResetCodeScreen(email: "test@gmail.com"),
        ),
      ),
    );
  }

  group("VerifyResetCodeScreen Tests", () {
    testWidgets("Verify AppBar exists", (WidgetTester tester) async {
      await tester.pumpWidget(prepareWidget());
      await tester.pump();

      expect(
        find.byKey(const Key(AppWidgetsKeys.verifyCodeAppBar)),
        findsOneWidget,
      );
    });

    testWidgets("Verify PinCodeTextField exists", (WidgetTester tester) async {
      await tester.pumpWidget(prepareWidget());
      await tester.pump();

      expect(
        find.byKey(const Key(AppWidgetsKeys.pinCodeField)),
        findsOneWidget,
      );
    });

    testWidgets("Verify Verify Button exists", (WidgetTester tester) async {
      await tester.pumpWidget(prepareWidget());
      await tester.pump();

      expect(
        find.byKey(const Key(AppWidgetsKeys.verifyButton)),
        findsOneWidget,
      );
    });

    testWidgets("Verify Resend Button exists", (WidgetTester tester) async {
      await tester.pumpWidget(prepareWidget());
      await tester.pump();

      expect(
        find.byKey(const Key(AppWidgetsKeys.resendButton)),
        findsOneWidget,
      );
    });

    testWidgets("Trigger SubmitCodeEvent on Verify Button press", (
      tester,
    ) async {
      await tester.pumpWidget(prepareWidget());

      FakeAsync().run((async) {
        tester.enterText(
          find.byKey(const Key(AppWidgetsKeys.pinCodeField)),
          "123456",
        );
        async.elapse(const Duration(milliseconds: 300));
      });

      await tester.tap(find.byKey(const Key(AppWidgetsKeys.verifyButton)));
      await tester.pump();
      verify(mockForgetPasswordBloc.add(any)).called(2);
    });

    testWidgets("Trigger ResendCodeEvent when Resend Button enabled", (
      WidgetTester tester,
    ) async {
      blocController.add(const ForgetPasswordState(isResendEnabled: true));
      await tester.pumpWidget(prepareWidget());
      await tester.pump();

      await tester.tap(find.byKey(const Key(AppWidgetsKeys.resendButton)));
      await tester.pump(); // avoid pumpAndSettle timeout

      verify(mockForgetPasswordBloc.add(any)).called(1);
    });

    testWidgets("Show SnackBar on success", (WidgetTester tester) async {
      await tester.pumpWidget(prepareWidget());
      await tester.pump();

      // emit success state
      blocController.add(
        const ForgetPasswordState(
          requestState: RequestState.success,
          isVerifySuccess: true,
          info: "Code verified",
        ),
      );
      await tester.pump(); // show SnackBar

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets("Show SnackBar on error", (WidgetTester tester) async {
      await tester.pumpWidget(prepareWidget());
      await tester.pump();

      // emit error state
      blocController.add(
        const ForgetPasswordState(
          requestState: RequestState.error,
          isVerifySuccess: true,
          error: "Invalid code",
        ),
      );
      await tester.pump(); // show SnackBar

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}

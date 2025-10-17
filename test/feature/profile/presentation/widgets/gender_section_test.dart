import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/constants/constants.dart';
import 'package:tracking_app/core/l10n/translations/app_localizations.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/feature/profile/presentation/views/widgets/gender_section.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return SizeProvider(
      baseSize: const Size(375, 812),
      height: 812,
      width: 375,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('renders gender label and both male/female options', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(const GenderSection(selectedGender: null)),
    );

    final radioButtons = find.byType(RadioMenuButton<String>);
    expect(radioButtons, findsNWidgets(2));
  });

  testWidgets('selects female when selectedGender is Constants.female', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(const GenderSection(selectedGender: Constants.female)),
    );

    final radios = tester.widgetList<RadioMenuButton<String>>(
      find.byType(RadioMenuButton<String>),
    ).toList();

    final femaleRadio = radios.firstWhere((r) => r.value == Constants.female);
    expect(femaleRadio.groupValue, equals(Constants.female));
  });

  testWidgets('selects male when selectedGender is Constants.male', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(const GenderSection(selectedGender: Constants.male)),
    );

    final radios = tester.widgetList<RadioMenuButton<String>>(
      find.byType(RadioMenuButton<String>),
    ).toList();

    final maleRadio = radios.firstWhere((r) => r.value == Constants.male);
    expect(maleRadio.groupValue, equals(Constants.male));
  });
}

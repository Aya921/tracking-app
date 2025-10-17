import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/l10n/translations/app_localizations.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/feature/home/presentaion/view/widgets/total_and_payment_container.dart';
import 'package:tracking_app/core/theme/app_colors.dart';

Widget makeTestableWidget(Widget child) {
  return SizeProvider(
    baseSize: const Size(375, 812),
    width: 375,
    height: 812,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('TotalAndPaymentContainer Widget Tests', () {
    const containerName = 'Total';
    const containerValue = 'EGP 150';

    testWidgets('renders containerName and containerValue', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          const TotalAndPaymentContainer(
            containerName: containerName,
            containerValue: containerValue,
          ),
        ),
      );

      expect(find.text(containerName), findsOneWidget);

      expect(find.text(containerValue), findsOneWidget);
    });

    testWidgets('texts have correct colors and font sizes', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          const TotalAndPaymentContainer(
            containerName: containerName,
            containerValue: containerValue,
          ),
        ),
      );

      final nameText = tester.widget<Text>(find.text(containerName));
      expect(nameText.style!.color, equals(AppColors.black));
      expect(nameText.style!.fontSize, isNotNull);

      final valueText = tester.widget<Text>(find.text(containerValue));
      expect(valueText.style!.color, equals(AppColors.gray));
      expect(valueText.style!.fontSize, isNotNull);
    });
  });
}

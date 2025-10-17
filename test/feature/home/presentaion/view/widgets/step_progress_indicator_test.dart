import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/home/presentaion/view/widgets/step_progress_indicator.dart';
import 'package:tracking_app/core/theme/app_colors.dart';

void main() {
  group('StepIndicator Widget Tests', () {
    testWidgets('renders correct number of steps', (tester) async {
      const stepsLength = 4;
      const currentStep = 1;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StepIndicator(
              currentStep: currentStep,
              stepsLength: stepsLength,
            ),
          ),
        ),
      );

      // Find all Containers that have a BoxDecoration (these are the step bars)
      final stepBars = tester.widgetList<Container>(
        find.byWidgetPredicate(
              (widget) => widget is Container && widget.decoration is BoxDecoration,
        ),
      );

      expect(stepBars.length, stepsLength);
    });

    testWidgets('sets correct colors based on currentStep', (tester) async {
      const stepsLength = 4;
      const currentStep = 2;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StepIndicator(
              currentStep: currentStep,
              stepsLength: stepsLength,
            ),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(
        find.byWidgetPredicate(
              (widget) => widget is Container && widget.decoration is BoxDecoration,
        ),
      ).toList();

      for (int i = 0; i < stepsLength; i++) {
        final decoration = containers[i].decoration as BoxDecoration;
        if (i <= currentStep) {
          expect(decoration.color, equals(AppColors.green));
        } else {
          expect(decoration.color, equals(AppColors.white[60]));
        }
      }
    });
  });
}

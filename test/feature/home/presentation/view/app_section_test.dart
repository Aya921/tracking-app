import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/home/presentaion/view/page/app_section.dart';


class MockAppLocalizations {
  final String home = 'Home';
  final String orders = 'Orders';
  final String profile = 'Profile';
}

extension MockLocalization on BuildContext {
  MockAppLocalizations get loc => MockAppLocalizations();
}

class FakeHomePage extends StatelessWidget {
  const FakeHomePage({super.key});
  @override
  Widget build(BuildContext context) => const Text('Home Content');
}

class FakeOrderPage extends StatelessWidget {
  const FakeOrderPage({super.key});
  @override
  Widget build(BuildContext context) => const Text('Orders Content');
}

class FakeProfileScreen extends StatelessWidget {
  const FakeProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const Text('Profile Content');
}


void main() {
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: AppSection(
        key: UniqueKey(),
      ),
    );
  }

  group('AppSection Widget Test', () {
    testWidgets('Renders BottomNavigationBar with 3 items', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(BottomNavigationBar), findsOneWidget);

      expect(find.byType(BottomNavigationBarItem), findsNWidgets(3));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Starts on the Home page (index 0)', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final navBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(navBar.currentIndex, 0);
      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.controller?.initialPage, 0);
    });


  });
}



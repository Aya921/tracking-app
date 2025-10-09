import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tracking_app/core/widgets/common_loading.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_events.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_states.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_view_model.dart';
import 'package:tracking_app/feature/home/presentaion/view/page/home_page.dart';
import 'package:tracking_app/core/widgets/common_error.dart';
import 'package:tracking_app/feature/home/presentaion/view/widgets/order_cards.dart';

class MockHomeViewModel extends MockBloc<HomeEvents, HomeStates> implements HomeViewModel {}

class MockAppLocalizations {
  final String floweryRider = 'Flowery Rider App';
  final String noOrdersFound = 'No Orders Found';
  final String unExpectedErrorfound = 'Unexpected Error Found';
}
extension MockLocalization on BuildContext {
  MockAppLocalizations get loc => MockAppLocalizations();
}
extension MockSizing on BuildContext {
  double setWidth(double size) => size;
  double setHight(double size) => size;
  double setSp(double size) => size;
}


class FakeOrderCards extends StatelessWidget {
  const FakeOrderCards({super.key});
  @override
  Widget build(BuildContext context) {
    return const Text('Order Cards Content');
  }
}
@GenerateMocks([HomeViewModel])
void main() {
  late MockHomeViewModel mockHomeViewModel;

  setUp(() {
    mockHomeViewModel = MockHomeViewModel();
  });

  Widget createWidgetUnderTest(Widget child) {
    return MaterialApp(
      home: BlocProvider<HomeViewModel>(
        create: (context) => mockHomeViewModel,
        child: child,
      ),
    );
  }


  testWidgets('Renders AppBar with correct title', (tester) async {
    when(mockHomeViewModel.state).thenReturn( HomeStates());

    await tester.pumpWidget(createWidgetUnderTest(const HomePage()));

    expect(find.text('Flowery Rider App'), findsOneWidget);
  });

  testWidgets('Shows CommonLoading when state is isLoading=true', (tester) async {
    when(mockHomeViewModel.state).thenReturn(HomeStates(isLoading: true));

    await tester.pumpWidget(createWidgetUnderTest(const HomePage()));

    expect(find.byType(CommonLoading), findsOneWidget);
    expect(find.byType(OrderCards), findsNothing);
  });

  testWidgets('Shows "No Orders Found" error when orders list is empty', (tester) async {
    when(mockHomeViewModel.state).thenReturn(HomeStates(isLoading: false, orders: const []));

    await tester.pumpWidget(createWidgetUnderTest(const HomePage()));

    expect(find.byType(CustumError), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is CustumError && widget.errorMessage == 'No Orders Found'), findsOneWidget);
  });

  testWidgets('Shows "Unexpected Error" when orders is null and not loading', (tester) async {
    when(mockHomeViewModel.state).thenReturn(HomeStates(isLoading: false, orders: null));

    await tester.pumpWidget(createWidgetUnderTest(const HomePage()));

    expect(find.byType(CustumError), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is CustumError && widget.errorMessage == 'Unexpected Error Found'), findsOneWidget);
  });
}
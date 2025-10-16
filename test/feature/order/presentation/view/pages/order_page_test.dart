import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/l10n/translations/app_localizations.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/core/routes/app_route.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/feature/order/domain/entity/order_driver_entity.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/order/domain/entity/order_info_entity.dart';

import 'package:tracking_app/feature/order/presentation/veiw_models/order_veiw_model/order_bloc.dart';
import 'package:tracking_app/feature/order/presentation/veiw_models/order_veiw_model/order_events.dart';
import 'package:tracking_app/feature/order/presentation/veiw_models/order_veiw_model/order_states.dart';
import 'package:tracking_app/feature/order/presentation/view/page/order_page.dart';

import 'order_page_test.mocks.dart';

class MockOrderInfoEntity extends Fake implements OrderInfoEntity {
  @override
  final String state;
  MockOrderInfoEntity({required this.state});
}

class MockOrderEntity extends Fake implements OrderEntity {
  @override
  final OrderInfoEntity orderInfoEntity;
  MockOrderEntity({required this.orderInfoEntity});
}

class MockOrderDriverEntity extends Fake implements OrderDriverEntity {
  @override
  final List<OrderEntity> orders;
  MockOrderDriverEntity({required this.orders});
}

@GenerateMocks([OrderBloc])
void main() {
  late MockOrderBloc mockOrderBloc;

  const String myOrderText = 'My Orders Title';
  const String noOrdersFoundText = 'No Orders Found Message';
  const String cancelledText = 'Cancelled';
  const String completedText = 'Completed';
  const String recentOrdersText = 'Recent Orders';

  setUp(() {
    mockOrderBloc = MockOrderBloc();

    when(mockOrderBloc.state).thenReturn(const OrderStates());
    when(mockOrderBloc.stream)
        .thenAnswer((_) => Stream.fromIterable([const OrderStates()]));

    try {
      getIt.registerFactory<OrderBloc>(() => mockOrderBloc);
    } catch (_) {
    }
  });

  tearDown(getIt.reset);

  Widget prepareWidget({String initialRoute = '/'}) {
    return SizeProvider(
      baseSize: const Size(375, 812),
      height: 812,
      width: 375,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        initialRoute: initialRoute,
        routes: {
          AppRoute.orderDriverDetails: (context) => const Scaffold(body: Text('Details Page')),
          '/': (context) => BlocProvider<OrderBloc>.value(
            value: mockOrderBloc,
            child: const OrderPage(),
          ),
        },
        builder: (context, child) {
          if (Localizations.of<AppLocalizations>(context, AppLocalizations) != null) {
            when(Localizations.of<AppLocalizations>(context, AppLocalizations)!.myOrder).thenReturn(myOrderText);
            when(Localizations.of<AppLocalizations>(context, AppLocalizations)!.noOrdersFound).thenReturn(noOrdersFoundText);
            when(Localizations.of<AppLocalizations>(context, AppLocalizations)!.cancelled).thenReturn(cancelledText);
            when(Localizations.of<AppLocalizations>(context, AppLocalizations)!.completed).thenReturn(completedText);
            when(Localizations.of<AppLocalizations>(context, AppLocalizations)!.recentOrders).thenReturn(recentOrdersText);
          }
          return child!;
        },
      ),
    );
  }

  group('OrderPage Widget Test', () {

    testWidgets('Verify GetDriverOrdersEvent is fired on initialization', (tester) async {
      await tester.pumpWidget(prepareWidget());

      verify(mockOrderBloc.add(const GetDriverOrdersEvent())).called(1);
    });

    testWidgets('shows loading state when RequestState is loading', (tester) async {
      when(mockOrderBloc.stream).thenAnswer(
            (_) => Stream.fromIterable([
          const OrderStates(requestState: RequestState.loading),
        ]),
      );

      await tester.pumpWidget(prepareWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when RequestState is error', (tester) async {
      const errorMessage = 'Failed to load orders.';

      when(mockOrderBloc.stream).thenAnswer(
            (_) => Stream.fromIterable([
          const OrderStates(
            requestState: RequestState.error,
            errorMessage: errorMessage,
          ),
        ]),
      );

      await tester.pumpWidget(prepareWidget());
      await tester.pump();

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('shows "No Orders Found" message when orders list is empty on success', (tester) async {
      when(mockOrderBloc.stream).thenAnswer(
            (_) => Stream.fromIterable([
          OrderStates(
            requestState: RequestState.success,
            orders: MockOrderDriverEntity(orders: []),
          ),
        ]),
      );

      await tester.pumpWidget(prepareWidget());
      await tester.pump();

      expect(find.text(noOrdersFoundText), findsOneWidget);
    });

    testWidgets('renders orders, status chips and navigates on tap', (tester) async {
      final ordersList = [
        MockOrderEntity(orderInfoEntity: MockOrderInfoEntity(state: completedText)),
        MockOrderEntity(orderInfoEntity: MockOrderInfoEntity(state: cancelledText)),
        MockOrderEntity(orderInfoEntity: MockOrderInfoEntity(state: completedText)),
      ];
      final successState = OrderStates(
        requestState: RequestState.success,
        orders: MockOrderDriverEntity(orders: ordersList),
      );

      when(mockOrderBloc.stream).thenAnswer(
            (_) => Stream.fromIterable([successState]),
      );

      await tester.pumpWidget(prepareWidget());
      await tester.pump();

      expect(find.text(myOrderText), findsOneWidget);
      expect(find.text(recentOrdersText), findsOneWidget);

      expect(find.text('2'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text(completedText), findsOneWidget);
      expect(find.text(cancelledText), findsOneWidget);

      expect(find.byType(InkWell), findsNWidgets(ordersList.length));

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(find.text('Details Page'), findsOneWidget);
    });
  });
}
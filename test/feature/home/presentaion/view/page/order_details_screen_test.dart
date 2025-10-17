import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/common/driver_entity/identity_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/meta_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/vechical_info_entity.dart';
import 'package:tracking_app/core/constants/app_widgets_keys.dart';
import 'package:tracking_app/core/l10n/translations/app_localizations.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_item_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/payment_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/product_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/shipping_address_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/store_entity.dart';
import 'package:tracking_app/core/common/entity/user_entity.dart';
import 'package:tracking_app/core/widgets/common_loading.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/home/presentaion/view/page/order_details_screen.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_states.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_view_model.dart';

import 'order_details_screen_test.mocks.dart';

@GenerateMocks([HomeViewModel])
void main() {
  late MockHomeViewModel mockHomeViewModel;

  // === Fake Entities ===
  final fakeUser = UserEntity(
    id: '1',
    firstName: 'Rana',
    lastName: 'Gebril',
    email: 'rana@gmail.com',
    gender: 'female',
    phone: '0123456789',
    photo: '',
  );

  final fakeProduct = ProductEntity(
    id: 'p1',
    title: 'Flower',
    slug: 'flower-slug',
    description: 'Nice red flower',
    imgCover: 'flower.jpg',
    images: ['flower.jpg'],
    price: 100,
    priceAfterDiscount: 80,
    quantity: 2,
    category: 'Roses',
    occasion: 'Birthday',
  );

  final fakeOrderItem = OrderItemEntity(
    product: fakeProduct,
    price: 100,
    quantity: 2,
    id: 'item1',
  );

  final fakeShipping = ShippingAddressEntity(
    street: 'Tahrir St',
    city: 'Cairo',
    phone: '0123456789',
    lat: '30.0',
    long: '31.0',
  );

  final fakeStore = StoreEntity(
    name: 'Flower Store',
    image: 'store.jpg',
    address: 'Nasr City',
    phoneNumber: '0111111111',
    latLong: '30,31',
  );

  final fakePayment = PaymentInfoEntity('Cash', '2025-01-01', true);

  final fakeOrderInfo = OrderInfoEntity(
    false,
    'received',
    'ORD-001',
    '2025-01-01',
    '2025-01-02',
    1,
    150,
  );

  final fakeOrder = OrderEntity(
    id: '123',
    user: fakeUser,
    orderItems: [fakeOrderItem],
    shippingAddress: fakeShipping,
    store: fakeStore,
    paymentInfoEntity: fakePayment,
    orderInfoEntity: fakeOrderInfo,
  );

  const fakeDriver = DriverEntity(
    id: '1',
    firstName: 'Rana',
    lastName: 'Gebril',
    contactInfo: ContactInfo(
      country: 'Egypt',
      gender: 'female',
      email: 'rana@gmail.com',
      phone: '0123456789',
      photo: '',
    ),
    vehicle: VehicleInfo(type: 'car', number: '123', license: 'A1'),
    identity: IdentityInfo(nid: '9999', nidImg: ''),
    meta: MetaInfo(role: 'driver', createdAt: '2025-01-01'),
  );

  final fakeRemoteData = RemoteDataEntity(
    fakeDriver,
    fakeOrder,
    'received',
  );

  setUp(() {
    mockHomeViewModel = MockHomeViewModel();

    when(mockHomeViewModel.state)
        .thenReturn(const HomeStates(isLoading: true));

    when(mockHomeViewModel.stream)
        .thenAnswer((_) => Stream.fromIterable([const HomeStates(isLoading: true)]));

    getIt.registerFactory<HomeViewModel>(() => mockHomeViewModel);
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
        home: BlocProvider<HomeViewModel>.value(
          value: mockHomeViewModel,
          child: const OrderDetailsScreen(orderId: '123'),
        ),
      ),
    );
  }

  group("OrderDetailsScreen Widget Tests", () {
    testWidgets("shows loading indicator when state is loading", (tester) async {
      when(mockHomeViewModel.state).thenReturn(const HomeStates(isLoading: true));

      await tester.pumpWidget(prepareWidget());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CommonLoading), findsOneWidget);
    });


    testWidgets("renders main UI elements when data is loaded", (tester) async {
      when(mockHomeViewModel.state).thenReturn(
        HomeStates(isLoading: false, remoteData: fakeRemoteData),
      );

      when(mockHomeViewModel.stream).thenAnswer(
            (_) => Stream.value(
          HomeStates(isLoading: false, remoteData: fakeRemoteData),
        ),
      );

      await tester.pumpWidget(prepareWidget());
      await tester.pump(const Duration(seconds: 1));

      expect(find.byKey(const Key(AppWidgetsKeys.orderDetailsAppBar)), findsOneWidget);
      expect(find.byKey(const Key(AppWidgetsKeys.orderDetailsStepIndicator)), findsOneWidget);
      expect(find.byKey(const Key(AppWidgetsKeys.orderDetailsStatusContainer)), findsOneWidget);
      expect(find.byKey(const Key(AppWidgetsKeys.orderDetailsOrderItemsList)), findsOneWidget);
      expect(find.byKey(const Key(AppWidgetsKeys.orderDetailsCard)), findsOneWidget);
      expect(find.byKey(const Key(AppWidgetsKeys.orderDetailsTotalContainer)), findsOneWidget);
      expect(find.byKey(const Key(AppWidgetsKeys.orderDetailsPaymentContainer)), findsOneWidget);
      expect(find.byKey(const Key(AppWidgetsKeys.orderDetailsNextButton)), findsOneWidget);
    });


  });
}

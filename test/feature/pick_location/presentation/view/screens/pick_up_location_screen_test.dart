import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/core/common/driver_entity/identity_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/meta_info_entity.dart';
import 'package:tracking_app/core/common/driver_entity/vechical_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/payment_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/shipping_address_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/store_entity.dart';
import 'package:tracking_app/core/common/entity/user_entity.dart';
import 'package:tracking_app/core/constants/app_widgets_keys.dart';
import 'package:tracking_app/core/enums/address_type.dart';
import 'package:tracking_app/core/l10n/translations/app_localizations.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/core/routes/app_route.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_events.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_view_model.dart';
import 'package:tracking_app/feature/pick_location/presentation/view/screens/pick_up_location_screen.dart';
import 'package:tracking_app/feature/pick_location/presentation/view/widget/address_detials_widget.dart';
import 'package:tracking_app/feature/pick_location/presentation/view/widget/custom_map.dart';
import 'package:tracking_app/feature/pick_location/presentation/view/widget/custom_pop_icon.dart';
import 'package:tracking_app/feature/pick_location/presentation/view_model/pick_up_location_view_model.dart';

import 'pick_up_location_screen_test.mocks.dart';

@GenerateMocks([MapViewModel, HomeViewModel])
void main() {
  final getIt = GetIt.instance;
  late MockMapViewModel mockMapViewModel;
  late MockHomeViewModel mockHomeViewModel;

  final remoteDataEntity = RemoteDataEntity(

 const
 DriverEntity(
      id: '1',
      firstName: 'Aya',
      lastName: 'Saber',
      contactInfo: ContactInfo(
        country: 'Egypt',
        gender: 'female',
        email: 'aya.saber@example.com',
        phone: '+201012345678',
        photo: 'default-profile.png',
      ),
      vehicle: VehicleInfo(
        type: 'Car',
        number: 'ABC-1234',
        license: 'license-image.png',
      ),
      identity: IdentityInfo(nid: '29812345678901', nidImg: 'nid-photo.png'),
      meta: MetaInfo(role: 'driver', createdAt: '2025-01-01T10:00:00.000Z'),
    ),
   OrderEntity(
      id: "",
      user: UserEntity(
        id: "68e91e017fee68a4c2eaa20e",
        firstName: "mariam",
        lastName: "mohmed",
        email: "mariammohme.250@gmail.com",
        gender: "female",
        phone: "+20101070082",
        photo: "default-profile.png",
      ),
      orderItems: [],
      shippingAddress: ShippingAddressEntity(
        street: "benha",
        city: "qaliubia",
        phone: "01061728082",
        lat: "37.7749",
        long: "-122.4194",
      ),
      store: StoreEntity(
        name: "Elevate FlowerApp Store",
        image: "https://www.elevateegy.com/elevate.png",
        address: "123 Fixed Address, City, Country",
        phoneNumber: "1234567890",
        latLong: "37.7749,-122.4194",
      ),
      paymentInfoEntity: PaymentInfoEntity(
        "cash",
        "2025-10-13T10:22:15.841Z",
        true,
      ),
      orderInfoEntity: OrderInfoEntity(
        true,
        "Accepted",
        "1234",
        "2025-10-13T10:47:38.239Z",
        "2025-10-13T10:47:38.239Z",
        12345,
        234567,
      ),
    ),
    "Accepted"
  );

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    mockMapViewModel = MockMapViewModel();
    mockHomeViewModel = MockHomeViewModel();
    if (getIt.isRegistered<MapViewModel>()) {
      getIt.unregister<MapViewModel>();
    }
    getIt.registerSingleton<MapViewModel>(mockMapViewModel);
  });

  Widget prepareWidget({bool isStore = true}) {
    return MaterialApp(
      home: SizeProvider(
        baseSize: const Size(375, 812),
        height: 812,
        width: 375,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateRoute: (settings) {
            if (settings.name == AppRoute.pickUpScreen) {
              return MaterialPageRoute(builder: (_) => const Scaffold());
            }
            return null;
          },
          home: ChangeNotifierProvider<MapViewModel>.value(
            value: mockMapViewModel,
            child: PickUpLocationScreen(
              remoteDataEntity: remoteDataEntity,
              isStore: isStore,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('shows loading animation when provider is loading', (
    tester,
  ) async {
    when(mockMapViewModel.isLoading).thenReturn(true);

    await tester.pumpWidget(prepareWidget());
    await tester.pump();
    expect(find.byType(Lottie), findsOneWidget);
    expect(find.byType(CustomMap), findsNothing);
  });
  testWidgets("displays error state when driverLocation is null", (
    tester,
  ) async {
    when(mockMapViewModel.isLoading).thenReturn(false);
    when(mockMapViewModel.driverLocation).thenReturn(null);
    await tester.pumpWidget(prepareWidget());
    await tester.pump();
    expect(find.byIcon(Icons.location_off), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text("Error ❌"), findsOneWidget);
  });
  final mockController = Completer<GoogleMapController>();

  testWidgets("displays map and address details when isStore is true", (
    tester,
  ) async {
    when(mockMapViewModel.isLoading).thenReturn(false);
    when(
      mockMapViewModel.driverLocation,
    ).thenReturn(const LatLng(37.7749, -122.4194));

    when(mockMapViewModel.controller).thenReturn(mockController);
    when(mockMapViewModel.homeViewModel).thenReturn(mockHomeViewModel);

    await tester.pumpWidget(prepareWidget(isStore: true));
    await tester.pump();
    expect(find.byType(CustomMap), findsOneWidget);
    expect(find.byType(CustomPopIcon), findsOneWidget);
    expect(find.byType(AddressDetialsWidget), findsNWidgets(2));
    final storeFinder = find.byWidgetPredicate(
      (widget) =>
          widget is AddressDetialsWidget &&
          widget.addressType == AddressType.store &&
          widget.isPickedAddress == true,
    );
    expect(storeFinder, findsOneWidget);
    final userFinder = find.byWidgetPredicate(
      (widget) =>
          widget is AddressDetialsWidget &&
          widget.addressType == AddressType.user &&
          widget.isPickedAddress == false,
    );
    expect(userFinder, findsOneWidget);
    await tester.tap(find.byKey(const Key(AppWidgetsKeys.phoneKey)).first);
    await tester.pumpAndSettle();
    verify(mockHomeViewModel.add(argThat(isA<CallUserEvent>()))).called(1);
    await tester.tap(find.byKey(const Key(AppWidgetsKeys.whatsAppKey)).first);
    await tester.pump();
    verify(mockHomeViewModel..add(argThat(isA<WhatsAppUserEvent>()))).called(1);
  });
  testWidgets("displays map and address details when isStore is false", (
    tester,
  ) async {
    when(mockMapViewModel.isLoading).thenReturn(false);
    when(
      mockMapViewModel.driverLocation,
    ).thenReturn(const LatLng(37.7749, -122.4194));
    when(mockMapViewModel.controller).thenReturn(mockController);
    when(mockMapViewModel.homeViewModel).thenReturn(mockHomeViewModel);

    await tester.pumpWidget(prepareWidget(isStore: false));
    await tester.pump();
    expect(find.byType(CustomMap), findsOneWidget);
    expect(find.byType(CustomPopIcon), findsOneWidget);
    expect(find.byType(AddressDetialsWidget), findsNWidgets(2));
    final userFinder = find.byWidgetPredicate(
      (widget) =>
          widget is AddressDetialsWidget &&
          widget.addressType == AddressType.user &&
          widget.isPickedAddress == false,
    );
    expect(userFinder, findsOneWidget);
    final storeFinder = find.byWidgetPredicate(
      (widget) =>
          widget is AddressDetialsWidget &&
          widget.addressType == AddressType.store &&
          widget.isPickedAddress == true,
    );
    expect(storeFinder, findsOneWidget);
    await tester.tap(find.byKey(const Key(AppWidgetsKeys.phoneKey)).last);
    await tester.pumpAndSettle();
    verify(mockHomeViewModel..add(argThat(isA<CallUserEvent>()))).called(1);
    await tester.tap(find.byKey(const Key(AppWidgetsKeys.whatsAppKey)).last);
    await tester.pumpAndSettle();
    verify(mockHomeViewModel..add(argThat(isA<WhatsAppUserEvent>()))).called(1);
  });
  testWidgets("navigates back when CustomPopIcon is pressed", (
    WidgetTester tester,
  ) async {
    when(mockMapViewModel.isLoading).thenReturn(false);
    when(
      mockMapViewModel.driverLocation,
    ).thenReturn(const LatLng(37.7749, -122.4194));
    when(mockMapViewModel.controller).thenReturn(mockController);
    when(mockMapViewModel.homeViewModel).thenReturn(mockHomeViewModel);
    await tester.pumpWidget(prepareWidget(isStore: true));
    await tester.tap(find.byType(CustomPopIcon));
    await tester.pumpAndSettle();
    expect(find.byType(PickUpLocationScreen), findsNothing);
  });
}

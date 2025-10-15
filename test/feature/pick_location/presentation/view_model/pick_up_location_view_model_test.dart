import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/feature/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/order_info_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/payment_info_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/shipping_address_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/store_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/user_entity.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_view_model.dart';
import 'package:tracking_app/feature/pick_location/presentation/view_model/pick_up_location_view_model.dart';
import 'pick_up_location_view_model_test.mocks.dart';

// Generate mocks
@GenerateMocks([
  Location,
  HomeViewModel,
  GoogleMapController,
  LocationData,
  StreamSubscription,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockHomeViewModel mockHomeViewModel;
  late MockLocationData mockLocationData;
  late MockLocation mockLocation;
  late MapViewModel mapViewModel;

  setUpAll(() {
    mockLocation = MockLocation();
    mockLocationData = MockLocationData();
    mockHomeViewModel = MockHomeViewModel();

    mapViewModel = MapViewModel(mockHomeViewModel);
  });

  final RemoteDataEntity remoteDataEntity = RemoteDataEntity(
    driverEntity: const DriverEntity(
      country: "Egypt",
      firstName: "mariam1",
      lastName: "mohmed2",
      vehicleType: "676b31a45d05310ca82657ac",
      vehicleNumber: "12221",
      vehicleLicense:
          "17145723-dce1-4b92-b9dd-f07fde1d2a0c-WhatsApp Image 2025-10-12 at 22.27.44.jpeg",
      nid: "12345678912345",
      nidImg:
          "d423a44e-a08e-4884-bd04-eddcacde34db-WhatsApp Image 2025-10-08 at 15.08.18.jpeg",
      email: "mariammohmed78@gmail.com",
      gender: "female",
      phone: "+20101070082",
      photo: "default-profile.png",
      role: "driver",
      id: "68ecd8ca7fee68a4c2eb7248",
      createdAt: "2025-10-13T10:47:38.239Z",
    ),
    orderEntity: OrderEntity(
      id: "",
      user: UserEntity(
        id: "68e91e017fee68a4c2eaa20e",
        firstName: "mariam",
        lastName: "mohmed",
        email: "mariammohme.250@gmail.com",
        gender: "female",
        phone: "+201061728082",
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
    orderDeliveryStatus: "Accepted",
  );
  test("initMap sets isLoading correctly and notifies listeners", () async {
    when(mockLocation.serviceEnabled()).thenAnswer((_) async => true);
    when(
      mockLocation.hasPermission(),
    ).thenAnswer((_) async => PermissionStatus.granted);
    when(mockLocation.getLocation()).thenAnswer((_) async => mockLocationData);
    when(
      mockLocation.onLocationChanged,
    ).thenAnswer((_) => Stream.fromIterable([mockLocationData]));
    when(mockLocation.enableBackgroundMode()).thenAnswer((_) async => true);
    //  bool isLoading = false;
    // mapViewModel.addListener(() => isLoading = true);
    await mapViewModel.initMap(remoteDataEntity, true);
    expect(mapViewModel.isLoading, false);
    expect(mapViewModel.driverLocation, const LatLng(37.7749, -122.4194));
  });
  test("init map and set error", () async {
    when(mockLocation.serviceEnabled()).thenAnswer((_) async
    => true);
    when(
      mockLocation.hasPermission(),
    ).thenAnswer((_) async => PermissionStatus.granted);
    when(mockLocation.getLocation()).thenAnswer((_) async => mockLocationData);
    when(
      mockLocation.onLocationChanged,
    ).thenAnswer((_) => Stream.fromIterable([mockLocationData]));
    when(mockLocation.enableBackgroundMode()).thenAnswer((_) async => true);
    bool loading = false;
    mapViewModel.addListener(() => loading = true);

    expect(loading, false);
    expect(mapViewModel.driverLocation, const LatLng(37.7749, -122.4194));
  });

  test(
    '_setDriverLocation sets driver location from current location',
    () async {
      // Arrange
      when(mockLocation.serviceEnabled()).thenAnswer((_) async => true);
      when(
        mockLocation.hasPermission(),
      ).thenAnswer((_) async => PermissionStatus.granted);
      when(
        mockLocation.getLocation(),
      ).thenAnswer((_) async => mockLocationData);
      when(
        mockLocation.onLocationChanged,
      ).thenAnswer((_) => Stream.fromIterable([mockLocationData]));
      when(
        mockLocation.enableBackgroundMode(enable: true),
      ).thenAnswer((_) async => true);
    },
  );
  test(" setDriverLocation fallback when service disabled", () async {
    when(mockLocation.serviceEnabled()).thenAnswer((_) async => false);
    when(
      mockLocation.hasPermission(),
    ).thenAnswer((_) async => PermissionStatus.denied);
    when(mockLocation.requestService()).thenAnswer((_) async => false);

    expectLater(
      () async => await mapViewModel.setDriverLocation(remoteDataEntity, true),
      throwsException,
    );
  });
  group('parseLatLng', () {
    test('returns correct LatLng when input is valid', () {
      final result = mapViewModel.parseLatLng('30.123, 31.456');

      expect(result.latitude, equals(30.123));
      expect(result.longitude, equals(31.456));
    });

    test('throws FormatException when input has missing comma', () {
      // expect(() => mapViewModel.parseLatLng('30.123 31.456'),
      //     throwsA(isA<FormatException>()));
      expect(
        () => mapViewModel.parseLatLng("30.123 31.456"),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when input is empty', () {
      expect(
        () => mapViewModel.parseLatLng(''),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when input contains non-numeric values', () {
      expect(
        () => mapViewModel.parseLatLng('abc, def'),
        throwsA(isA<FormatException>()),
      );
    });

    test('trims spaces around numbers correctly', () {
      final result = mapViewModel.parseLatLng('  29.5 ,  30.8  ');
      expect(result.latitude, equals(29.5));
      expect(result.longitude, equals(30.8));
    });
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/api_result/result.dart';
import 'package:tracking_app/feature/home/domain/entity/update_order_response_entity.dart';

import 'package:tracking_app/feature/home/domain/usecase/add_data_to_remote.dart';
import 'package:tracking_app/feature/home/domain/usecase/delete_local_order.dart';
import 'package:tracking_app/feature/home/domain/usecase/get_all_pending_orders.dart';
import 'package:tracking_app/feature/home/domain/usecase/get_all_saved_orders.dart';
import 'package:tracking_app/feature/home/domain/usecase/get_data_from_remote.dart';
import 'package:tracking_app/feature/home/domain/usecase/save_data_to_local.dart';
import 'package:tracking_app/feature/home/domain/usecase/start_order_state.dart';
import 'package:tracking_app/feature/home/domain/usecase/update_order_state.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_events.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_states.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_view_model.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/core/common/entity/driver_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_item_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/payment_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/product_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/shipping_address_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/store_entity.dart';
import 'package:tracking_app/core/common/entity/user_entity.dart';
import 'home_view_model_test.mocks.dart';

@GenerateMocks([
  GetAllPendingOrdersUseCase,
  SaveDataToLocalUseCase,
  GetAllSavedOrdersUseCase,
  DeleteLocalOrderUseCase,
  UpdateOrderStateUseCase,
  AddDataToRemoteUseCase,
  GetDataFromRemoteUseCase,
  StartOrderStateUseCase,
])
void main() {
  late MockGetAllPendingOrdersUseCase mockGetAllPendingOrdersUseCase;
  late MockSaveDataToLocalUseCase mockSaveDataToLocalUseCase;
  late MockGetAllSavedOrdersUseCase mockGetAllSavedOrdersUseCase;
  late MockDeleteLocalOrderUseCase mockDeleteLocalOrderUseCase;
  late MockUpdateOrderStateUseCase mockUpdateOrderStateUseCase;
  late MockAddDataToRemoteUseCase mockAddDataToRemoteUseCase;
  late MockGetDataFromRemoteUseCase mockGetDataFromRemoteUseCase;
  late MockStartOrderStateUseCase mockStartOrderStateUseCase;
  late String orderId;

  late UserEntity user;
  late ProductEntity product;
  late StoreEntity store;
  late List<OrderItemEntity> orderItems;
  late ShippingAddressEntity shippingAddress;
  late PaymentInfoEntity paymentInfo;
  late OrderInfoEntity orderInfo;
  late OrderEntity order;
  late RemoteDataEntity remoteDataEntity;
  late HomeViewModel homeViewModel;
  late OrderResponseEntity responseEntity;
  late DriverEntity driverEntity;

  setUpAll(() {
    mockGetAllPendingOrdersUseCase = MockGetAllPendingOrdersUseCase();
    mockAddDataToRemoteUseCase = MockAddDataToRemoteUseCase();
    mockSaveDataToLocalUseCase = MockSaveDataToLocalUseCase();
    mockGetDataFromRemoteUseCase = MockGetDataFromRemoteUseCase();
    mockUpdateOrderStateUseCase = MockUpdateOrderStateUseCase();
    mockDeleteLocalOrderUseCase = MockDeleteLocalOrderUseCase();
    mockGetAllSavedOrdersUseCase = MockGetAllSavedOrdersUseCase();
    mockStartOrderStateUseCase=MockStartOrderStateUseCase();
    orderId = "order123";

    driverEntity =  const DriverEntity(
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
    );

    user = UserEntity(
      id: "user_1",
      firstName: "jana",
      lastName: "Tarek",
      email: "jana@example.com",
      gender: '',
      phone: '01111111111',
      photo: 'mmm.png',
    );
    product = ProductEntity(
      id: "prod_1",
      title: "Red Rose Bouquet",
      slug: "red-rose-bouquet",
      description:
          "A beautiful bouquet of fresh red roses, perfect for any occasion.",
      imgCover: "https://example.com/images/red_rose_cover.jpg",
      images: [
        "https://example.com/images/red_rose_1.jpg",
        "https://example.com/images/red_rose_2.jpg",
      ],
      price: 150,
      priceAfterDiscount: 120,
      quantity: 20,
      category: "Flowers",
      occasion: "Valentine's Day",
    );

    store = StoreEntity(
      name: "Flower Shop",
      image: "store_image_url",
      phoneNumber: "0222222222",
      address: 'giza',
      latLong: '1235',
    );

    orderItems = [
      OrderItemEntity(
        price: 50,
        quantity: 2,
        product: product,
        id: 'orderitem1',
      ),
    ];

    shippingAddress = ShippingAddressEntity(
      city: "Cairo",

      street: 'bb',
      phone: '011111',
      lat: '1234',
      long: '-1234',
    );

    paymentInfo = PaymentInfoEntity("Cash", "2025-10-10T12:00:00Z", true);

    orderInfo = OrderInfoEntity(
      true,
      "Delivered",
      "ORD-123456",
      "2025-10-09T09:00:00Z",
      "2025-10-11T10:00:00Z",
      1,
      170,
    );

    order = OrderEntity(
      id: "order_1",
      user: user,
      orderItems: orderItems,
      shippingAddress: shippingAddress,
      store: store,
      paymentInfoEntity: paymentInfo,
      orderInfoEntity: orderInfo,
    );

    remoteDataEntity = RemoteDataEntity(driverEntity, order, "Pending");

    responseEntity = OrderResponseEntity(
      id: '',
      user: '',
      orderItems: [],
      totalPrice: 12,
      paymentType: '',
      isPaid: true,
      isDelivered: true,
      state: '',
      orderNumber: '',
    );
  });
  group("test home viewModel ", () {
    group("test _getDataFromRemote function", () {
      blocTest<HomeViewModel, HomeStates>(
        "should emite state=true and isLoading = false when result is succes",
        build: () {
          homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );
          final mockStream = Stream.value(
            SucessResult<RemoteDataEntity>(remoteDataEntity),
          );

          when(
            mockGetDataFromRemoteUseCase.getOrderFromRemote(orderId),
          ).thenAnswer((_) => mockStream);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(GetDataFromRemoteEvent(orderId)),
        expect: () {
          return [HomeStates(isLoading: false, remoteData: remoteDataEntity)];
        },
      );

      blocTest<HomeViewModel, HomeStates>(
        "should emite getdatafromremote errorMessage=errorMessage and isLoading = false when result is falid",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );
          
          final mockStream = Stream.value(
            FailedResult<RemoteDataEntity>("errorMessage"),
          );

          when(
            mockGetDataFromRemoteUseCase.getOrderFromRemote(orderId),
          ).thenAnswer((_) => mockStream);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(GetDataFromRemoteEvent(orderId)),
        expect: () {
          return [
             const HomeStates(isLoading: false, errorMessage: "errorMessage"),
          ];
        },
      );
    });
    group("test _addDataToRemote function", () {
      blocTest<HomeViewModel, HomeStates>(
        "should emite addedToRemote: true when result is succes",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );
          final mockResult = SucessResult<void>(null);
          provideDummy<Result<void>>(mockResult);

          when(
            mockAddDataToRemoteUseCase.addDateToRemote(remoteDataEntity),
          ).thenAnswer((_) async => mockResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(AddDataToRemoteEvent(remoteDataEntity)),
        expect: () {
          return  [const HomeStates(addedToRemote: true)];
        },
      );

      blocTest<HomeViewModel, HomeStates>(
        "should emite errorMessage: errorMessage when result is falied",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );
          final mockResult = FailedResult<void>('errorMessage');
          provideDummy<Result<void>>(mockResult);

          when(
            mockAddDataToRemoteUseCase.addDateToRemote(remoteDataEntity),
          ).thenAnswer((_) async => mockResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(AddDataToRemoteEvent(remoteDataEntity)),
        expect: () {
          return  [const HomeStates(errorMessage: "errorMessage")];
        },
      );
    });

    group("test _startOrder function", () {
      blocTest<HomeViewModel, HomeStates>(
        "should emite addedToRemote: true when result is succes",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );
          final mockResult = SucessResult<OrderResponseEntity>(responseEntity);
          provideDummy<Result<OrderResponseEntity>>(mockResult);

          when(
            mockStartOrderStateUseCase.startOrder(orderId),
          ).thenAnswer((_) async => mockResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(StartOrderEvent(orderId)),
        expect: () {
          return  [const HomeStates(orderStarted: true)];
        },
      );

      blocTest<HomeViewModel, HomeStates>(
        "should emite addedToRemote: true when result is succes",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );
          final mockResult = FailedResult<OrderResponseEntity>("errorMessage");
          provideDummy<Result<OrderResponseEntity>>(mockResult);

          when(
            mockStartOrderStateUseCase.startOrder(orderId),
          ).thenAnswer((_) async => mockResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(StartOrderEvent(orderId)),
        expect: () {
          return  [const HomeStates(errorMessage: "errorMessage")];
        },
      );
    });

    group("test _refreshOrders function", () {
      blocTest<HomeViewModel, HomeStates>(
        "should call _getAllPendingOrders and emit orders successfully",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );

          // arrange
          final mockResult = SucessResult<List<OrderEntity>?>([order]);
          final mockSaveDataResult = SucessResult<void>(null);
          provideDummy<Result<List<OrderEntity>?>>(mockResult);
          provideDummy<Result<void>>(SucessResult<void>(null));

          when(
            mockGetAllPendingOrdersUseCase.getAllPendingOrders(),
          ).thenAnswer((_) async => mockResult);
          when(
            mockSaveDataToLocalUseCase.saveDataToLocalStorage([order]),
          ).thenAnswer((_) async => mockSaveDataResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(RefreshOrdersEvent()),
        expect: () => [
           const HomeStates(isLoading: true),

          HomeStates(isLoading: false, orders: [order], errorMessage: null),
        ],
        verify: (_) {
          verify(
            mockGetAllPendingOrdersUseCase.getAllPendingOrders(),
          ).called(1);
        },
      );

      blocTest<HomeViewModel, HomeStates>(
        "should call _getAllPendingOrders and emit errorMessage",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );

          // arrange
          final mockResult = FailedResult<List<OrderEntity>?>("errorMessage");

          provideDummy<Result<List<OrderEntity>?>>(mockResult);

          when(
            mockGetAllPendingOrdersUseCase.getAllPendingOrders(),
          ).thenAnswer((_) async => mockResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(RefreshOrdersEvent()),
        expect: () =>  [
          const HomeStates(isLoading: true),

          const HomeStates(
            isLoading: false,
            orders: null,
            errorMessage: "errorMessage",
          ),
        ],
        verify: (_) {
          verify(
            mockGetAllPendingOrdersUseCase.getAllPendingOrders(),
          ).called(1);
        },
      );
    });

    group("test _getAllPendingOrders function", () {
      blocTest<HomeViewModel, HomeStates>(
        "should call _getAllPendingOrders and emit orders successfully",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );

          // arrange
          final mockResult = SucessResult<List<OrderEntity>?>([order]);
          final mockSaveDataResult = SucessResult<void>(null);
          provideDummy<Result<List<OrderEntity>?>>(mockResult);
          provideDummy<Result<void>>(SucessResult<void>(null));

          when(
            mockGetAllPendingOrdersUseCase.getAllPendingOrders(),
          ).thenAnswer((_) async => mockResult);
          when(
            mockSaveDataToLocalUseCase.saveDataToLocalStorage([order]),
          ).thenAnswer((_) async => mockSaveDataResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(GetAllPaindingOrdersEvent()),
        expect: () => [
           const HomeStates(isLoading: true),

          HomeStates(isLoading: false, orders: [order], errorMessage: null),
        ],
        verify: (_) {
          verify(
            mockGetAllPendingOrdersUseCase.getAllPendingOrders(),
          ).called(1);
        },
      );

      blocTest<HomeViewModel, HomeStates>(
        "should call _getAllPendingOrders and emit errorMessage",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );

          // arrange
          final mockResult = FailedResult<List<OrderEntity>?>("errorMessage");

          provideDummy<Result<List<OrderEntity>?>>(mockResult);

          when(
            mockGetAllPendingOrdersUseCase.getAllPendingOrders(),
          ).thenAnswer((_) async => mockResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(GetAllPaindingOrdersEvent()),
        expect: () =>  [
          const HomeStates(isLoading: true),

          const HomeStates(
            isLoading: false,
            orders: null,
            errorMessage: "errorMessage",
          ),
        ],
        verify: (_) {
          verify(
            mockGetAllPendingOrdersUseCase.getAllPendingOrders(),
          ).called(1);
        },
      );
    });

    group("test _getLocalOrders function", () {
      blocTest<HomeViewModel, HomeStates>(
        "should call  emit orders successfully when result is sucess",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );

          // arrange
          final mockResult = SucessResult<List<OrderEntity>?>([order]);

          provideDummy<Result<List<OrderEntity>?>>(mockResult);

          when(
            mockGetAllSavedOrdersUseCase.getAllSavedOrders(),
          ).thenAnswer((_) async => mockResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(GetAllLocalOrdersEvent()),
        expect: () => [
          HomeStates(isLoading: false, orders: [order], errorMessage: null),
        ],
        verify: (_) {
          verify(mockGetAllSavedOrdersUseCase.getAllSavedOrders()).called(1);
        },
      );

      blocTest<HomeViewModel, HomeStates>(
        "should  emit errorMessage when result is failed",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );

          // arrange
          final mockResult = FailedResult<List<OrderEntity>?>("errorMessage");

          provideDummy<Result<List<OrderEntity>?>>(mockResult);

          when(
            mockGetAllSavedOrdersUseCase.getAllSavedOrders(),
          ).thenAnswer((_) async => mockResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(GetAllLocalOrdersEvent()),
        expect: () =>  [
          const HomeStates(
            isLoading: false,
            orders: null,
            errorMessage: "errorMessage",
          ),
        ],
        verify: (_) {
          verify(mockGetAllSavedOrdersUseCase.getAllSavedOrders()).called(1);
        },
      );
    });

    group("test _deleteOrderLocaly function", () {
      setUp(() => reset(mockDeleteLocalOrderUseCase));
      blocTest<HomeViewModel, HomeStates>(
        "should call  emit orders successfully when result is sucess",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );

          // arrange
          final mockResult = SucessResult<void>(null);
          provideDummy<Result<void>>(mockResult);
          final mockGetLocalDataResult = SucessResult<List<OrderEntity>?>([
            order,
          ]);

          provideDummy<Result<List<OrderEntity>?>>(mockGetLocalDataResult);

          when(
            mockDeleteLocalOrderUseCase.deleteOrder(orderId),
          ).thenAnswer((_) async => mockResult);
          when(
            mockGetAllSavedOrdersUseCase.getAllSavedOrders(),
          ).thenAnswer((_) async => mockGetLocalDataResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(DeleteOrderLocalyEvent(orderId)),

        verify: (_) {
          verify(mockGetAllSavedOrdersUseCase.getAllSavedOrders()).called(1);
        },
      );

      blocTest<HomeViewModel, HomeStates>(
        "should call  emit errorMessage when result is failed",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );

          // arrange
          final mockResult = FailedResult<void>("error");
          provideDummy<Result<void>>(mockResult);

          when(
            mockDeleteLocalOrderUseCase.deleteOrder(orderId),
          ).thenAnswer((_) async => mockResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(DeleteOrderLocalyEvent(orderId)),
        expect: () =>  [
          const HomeStates(isLoading: false, errorMessage: "error", orders: null),
        ],

        verify: (_) {
          verify(mockDeleteLocalOrderUseCase.deleteOrder(orderId)).called(1);
        },
      );
    });

    group("test _getOrders function", () {
      blocTest<HomeViewModel, HomeStates>(
        "when is first == true then it should called getAllPendingOrder function",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );

          // arrange
          final mockResult = SucessResult<List<OrderEntity>?>([order]);
          final mockSaveDataResult = SucessResult<void>(null);
          provideDummy<Result<List<OrderEntity>?>>(mockResult);
          provideDummy<Result<void>>(SucessResult<void>(null));

          when(
            mockGetAllPendingOrdersUseCase.getAllPendingOrders(),
          ).thenAnswer((_) async => mockResult);
          when(
            mockSaveDataToLocalUseCase.saveDataToLocalStorage([order]),
          ).thenAnswer((_) async => mockSaveDataResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(GetOrdersEvent()),

        verify: (_) {
          verify(
            mockGetAllPendingOrdersUseCase.getAllPendingOrders(),
          ).called(1);
        },
      );

      blocTest<HomeViewModel, HomeStates>(
        "when is first == false then it should called getLocalOrders function",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );

          // arrange
          homeViewModel.firtTime = false;
          final mockResult = SucessResult<List<OrderEntity>?>([order]);

          provideDummy<Result<List<OrderEntity>?>>(mockResult);

          when(
            mockGetAllSavedOrdersUseCase.getAllSavedOrders(),
          ).thenAnswer((_) async => mockResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(GetOrdersEvent()),

        verify: (_) {
          verify(mockGetAllSavedOrdersUseCase.getAllSavedOrders()).called(1);
        },
      );
    });

    group("test _startOrderProcess", () {
      blocTest<HomeViewModel, HomeStates>(
        "emits correct states when all succeed",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );
          final mockResult = SucessResult<void>(null);
          provideDummy<Result<void>>(mockResult);
          when(
            mockAddDataToRemoteUseCase.addDateToRemote(remoteDataEntity),
          ).thenAnswer((_) async => mockResult);

          final startOrderMockResult = SucessResult<OrderResponseEntity>(
            responseEntity,
          );
          provideDummy<Result<OrderResponseEntity>>(startOrderMockResult);
          when(
            mockStartOrderStateUseCase.startOrder(any),
          ).thenAnswer((_) async => startOrderMockResult);

          final getAllPendingMockResult = SucessResult<List<OrderEntity>?>([
            order,
          ]);
          final mockSaveDataResult = SucessResult<void>(null);
          provideDummy<Result<List<OrderEntity>?>>(getAllPendingMockResult);
          provideDummy<Result<void>>(SucessResult<void>(null));

          when(
            mockGetAllPendingOrdersUseCase.getAllPendingOrders(),
          ).thenAnswer((_) async => getAllPendingMockResult);
          when(
            mockSaveDataToLocalUseCase.saveDataToLocalStorage([order]),
          ).thenAnswer((_) async => mockSaveDataResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(StartProgressEvnet(remoteDataEntity)),
        expect: () => [
           const HomeStates(isLoading: true),
           const HomeStates(addedToRemote: true),
           const HomeStates(orderStarted: true, addedToRemote: true),
          HomeStates(
            isLoading: true,
            processCompleted: true,
            orderStarted: true,
            addedToRemote: true,
            orders: [order],
            remoteData: remoteDataEntity,
          ),
        ],
      );

      blocTest<HomeViewModel, HomeStates>(
        "emits add to remote true(first level) then failed when updare order state then should emit add order to remote =true and start order =false with error message ",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );
          final mockResult = SucessResult<void>(null);
          provideDummy<Result<void>>(mockResult);
          when(
            mockAddDataToRemoteUseCase.addDateToRemote(remoteDataEntity),
          ).thenAnswer((_) async => mockResult);

          final startOrderMockResult = FailedResult<OrderResponseEntity>(
            "error",
          );
          provideDummy<Result<OrderResponseEntity>>(startOrderMockResult);
          when(
            mockStartOrderStateUseCase.startOrder(any),
          ).thenAnswer((_) async => startOrderMockResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(StartProgressEvnet(remoteDataEntity)),
        expect: () =>  [
          const HomeStates(isLoading: true),
          const HomeStates(addedToRemote: true),
          const HomeStates(
            isLoading: false,
            errorMessage: "error",
            orderStarted: false,
            addedToRemote: true,
          ),
        ],
      );

      blocTest<HomeViewModel, HomeStates>(
        "emits add to remote true(first level) and startOrder in api end point=true (secondLevel) then failed when get pending order from api order state then should emit proccessComplete=false with error message",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );
          final mockResult = SucessResult<void>(null);
          provideDummy<Result<void>>(mockResult);
          when(
            mockAddDataToRemoteUseCase.addDateToRemote(remoteDataEntity),
          ).thenAnswer((_) async => mockResult);

          final startOrderMockResult = SucessResult<OrderResponseEntity>(
            responseEntity,
          );
          provideDummy<Result<OrderResponseEntity>>(startOrderMockResult);
          when(
            mockStartOrderStateUseCase.startOrder(any),
          ).thenAnswer((_) async => startOrderMockResult);

          final getAllPendingMockResult = FailedResult<List<OrderEntity>?>(
            "error",
          );

          provideDummy<Result<List<OrderEntity>?>>(getAllPendingMockResult);

          when(
            mockGetAllPendingOrdersUseCase.getAllPendingOrders(),
          ).thenAnswer((_) async => getAllPendingMockResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(StartProgressEvnet(remoteDataEntity)),
        expect: () =>  [
          const HomeStates(isLoading: true),
          const HomeStates(addedToRemote: true),
          const HomeStates(orderStarted: true, addedToRemote: true),
          const HomeStates(
            isLoading: false,
            processCompleted: false,
            errorMessage:
                "Order started but refreshing orders failed. Please reload.",
            orderStarted: true,
            addedToRemote: true,
          ),
        ],
      );

      blocTest<HomeViewModel, HomeStates>(
        "emits add to remote = false then it should emite add to remote=false only",
        build: () {
        homeViewModel = HomeViewModel(
            mockGetAllPendingOrdersUseCase,
            mockSaveDataToLocalUseCase,
            mockGetAllSavedOrdersUseCase,
            mockDeleteLocalOrderUseCase,
            mockStartOrderStateUseCase,
            mockAddDataToRemoteUseCase,
            mockGetDataFromRemoteUseCase,
            mockUpdateOrderStateUseCase
      
          );
          final mockResult = FailedResult<void>("error");
          provideDummy<Result<void>>(mockResult);
          when(
            mockAddDataToRemoteUseCase.addDateToRemote(remoteDataEntity),
          ).thenAnswer((_) async => mockResult);

          return homeViewModel;
        },
        act: (bloc) => bloc.add(StartProgressEvnet(remoteDataEntity)),
        expect: () =>  [
          const HomeStates(isLoading: true),

          const HomeStates(
            isLoading: false,
            errorMessage: "error",
            addedToRemote: false,
          ),
        ],
      );
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/l10n/translations/app_localizations.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/core/widgets/cache_image.dart';
import 'package:tracking_app/feature/home/domain/entity/payment_info_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/shipping_address_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/store_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/user_entity.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/order/domain/entity/order_info_entity.dart';
import 'package:tracking_app/feature/order/domain/entity/order_item_entity.dart';
import 'package:tracking_app/feature/order/presentation/view/page/order_driver_details.dart';

class MockOrderInfoEntity extends Fake implements OrderInfoEntity {
  @override
  final String state;
  @override
  final String orderNumber;
  MockOrderInfoEntity({required this.state, required this.orderNumber});
}

class MockPaymentInfoEntity extends Fake implements PaymentInfoEntity {
  @override
  final String paymentType;
  MockPaymentInfoEntity({required this.paymentType});
}

class MockUserEntity extends Fake implements UserEntity {
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String fullPhotoUrl;
  MockUserEntity({required this.firstName, required this.lastName, required this.fullPhotoUrl});
}

class MockAddressEntity extends Fake implements ShippingAddressEntity {
  @override
  final String city;
  MockAddressEntity({required this.city});
}

class MockStoreEntity extends Fake implements StoreEntity {
  @override
  final String name;
  @override
  final String address;
  MockStoreEntity({required this.name, required this.address});
}

class MockOrderItemEntity extends Fake implements OrderItemEntity {
}

class MockOrderEntity extends Fake implements OrderEntity {
  @override
  final OrderInfoEntity orderInfoEntity;
  @override
  final PaymentInfoEntity paymentInfoEntity;
  @override
  final UserEntity user;
  @override
  final ShippingAddressEntity shippingAddress;
  @override
  final StoreEntity store;
  @override
  final List<OrderItemEntity> orderItems;

  MockOrderEntity({
    required this.orderInfoEntity,
    required this.paymentInfoEntity,
    required this.user,
    required this.shippingAddress,
    required this.store,
    required this.orderItems,
  });
}

void main() {
  const String orderDetailsTitle = 'Order Details';
  const String completedText = 'Completed';
  const String inProgressText = 'In Progress';
  const String pickupAddressText = 'Pickup Address';
  const String userAddressText = 'User Address';
  const String acceptText = 'Accept';
  const String totalText = 'Total';
  const String egpText = 'EGP';
  const String paymentMethodText = 'Payment Method';

  Widget prepareWidget(OrderEntity order) {
    return SizeProvider(
      baseSize: const Size(375, 812),
      height: 812,
      width: 375,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: OrderDriverDetails(order: order),
        builder: (context, child) {
          if (Localizations.of<AppLocalizations>(context, AppLocalizations) != null) {
            final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
            when(loc.orderDetailsTitle).thenReturn(orderDetailsTitle);
            when(loc.completed).thenReturn(completedText);
            when(loc.inProgress).thenReturn(inProgressText);
            when(loc.pickupAddress).thenReturn(pickupAddressText);
            when(loc.userAddress).thenReturn(userAddressText);
            when(loc.accept).thenReturn(acceptText);
            when(loc.total).thenReturn(totalText);
            when(loc.egp).thenReturn(egpText);
            when(loc.paymentMethod).thenReturn(paymentMethodText);
          }
          return child!;
        },
      ),
    );
  }

  group('OrderDriverDetails Widget Test', () {

    final mockOrder = MockOrderEntity(
      orderInfoEntity: MockOrderInfoEntity(state: completedText, orderNumber: 'ORD-12345'),
      paymentInfoEntity: MockPaymentInfoEntity(paymentType: 'Cash'),
      user: MockUserEntity(firstName: 'Ahmed', lastName: 'Ali', fullPhotoUrl: 'http://example.com/photo.jpg'),
      shippingAddress: MockAddressEntity(city: 'Cairo'),
      store: MockStoreEntity(name: 'Store X', address: '123 Main St'),
      orderItems: [
        MockOrderItemEntity(),
        MockOrderItemEntity(),
      ],
    );

    testWidgets('Renders essential order details correctly', (tester) async {
      await tester.pumpWidget(prepareWidget(mockOrder));

      expect(find.text(orderDetailsTitle), findsNWidgets(2));

      expect(find.text(mockOrder.orderInfoEntity.orderNumber), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      expect(find.text(pickupAddressText), findsOneWidget);
      expect(find.text(userAddressText), findsOneWidget);

      expect(find.text(mockOrder.store.name), findsOneWidget);
      expect(find.text(mockOrder.store.address), findsOneWidget);

      expect(find.text('Ahmed Ali'), findsOneWidget);
      expect(find.text(mockOrder.shippingAddress.city), findsOneWidget);
      expect(find.byType(CacheImage), findsOneWidget);

    });

    testWidgets('Renders total price and payment method correctly', (tester) async {
      await tester.pumpWidget(prepareWidget(mockOrder));

      expect(find.text('$egpText 150.5'), findsOneWidget);

      expect(find.text(paymentMethodText), findsOneWidget);
      expect(find.text('Cash'), findsOneWidget);
    });

    testWidgets('Handles missing user name and address correctly', (tester) async {
      final orderWithMissingData = MockOrderEntity(
        orderInfoEntity: MockOrderInfoEntity(state: completedText, orderNumber: 'ORD-123'),
        paymentInfoEntity: MockPaymentInfoEntity(paymentType: 'Card'),
        user: MockUserEntity(firstName: '', lastName: '', fullPhotoUrl: ''),
        shippingAddress: MockAddressEntity(city: ''),
        store: MockStoreEntity(name: 'Store Y', address: '456 Side Rd'),
        orderItems: [],
      );

      await tester.pumpWidget(prepareWidget(orderWithMissingData));

      expect(find.text(userAddressText), findsNWidgets(2));

      expect(find.text(acceptText), findsOneWidget);
    });

    testWidgets('Renders status header for In Progress order', (tester) async {
      final inProgressOrder = MockOrderEntity(
        orderInfoEntity: MockOrderInfoEntity(state: inProgressText, orderNumber: 'ORD-500'),
        paymentInfoEntity: MockPaymentInfoEntity(paymentType: 'Card'),
        user: MockUserEntity(firstName: 'Test', lastName: 'User', fullPhotoUrl: ''),
        shippingAddress: MockAddressEntity(city: 'City'),
        store: MockStoreEntity(name: 'Store Z', address: 'Address'),
        orderItems: [],
      );

      await tester.pumpWidget(prepareWidget(inProgressOrder));

      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.text(inProgressText), findsOneWidget);
    });
  });
}
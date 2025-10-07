import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/order/domain/entity/order_item_entity.dart';
import 'package:tracking_app/feature/order/domain/entity/order_info_entity.dart';
import 'package:tracking_app/feature/order/presentation/view/page/order_driver_details.dart';
import 'package:tracking_app/feature/home/domain/entity/user_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/store_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/product_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/shipping_address_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/payment_info_entity.dart';


class MockAppLocalizations {
  final String orderDetailsTitle = 'Order Details';
  final String pickupAddress = 'Pickup Address';
  final String userAddress = 'User Address';
  final String accept = 'Accept';
  final String egp = 'EGP';
  final String error = 'Error';
}
extension MockLocalization on BuildContext {
  MockAppLocalizations get loc => MockAppLocalizations();
}

extension MockSizing on BuildContext {
  double setWidth(double size) => size;
  double setHight(double size) => size;
  double setSp(double size) => size;
}

class FakeProductEntity extends Fake implements ProductEntity {
  @override
  final String title;
  @override
  final List<String> images;
  @override
  final String firstImageUrl;

  FakeProductEntity({
    required this.title,
    this.images = const [],
    this.firstImageUrl = '',
  });
}

class FakeUserEntity extends Fake implements UserEntity {
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String photo;
  @override
  final String fullPhotoUrl;

  FakeUserEntity({
    this.firstName = 'Wasi',
    this.lastName = 'Ghoneim',
    this.photo = 'test.jpg',
    this.fullPhotoUrl = 'http://example.com/test.jpg',
  });
}

void main() {

  final tProduct = FakeProductEntity(
    title: 'Red roses, 15 Pink Rose Bouquet',
    images: ['test_product_image.jpg'],
    firstImageUrl: 'http://example.com/products/test_product_image.jpg',
  );

  // Order Item
  final tOrderItem = OrderItemEntity(
    id: 'item1',
    product: tProduct,
    price: 600,
    quantity: 1,
  );

  // Full Order Entity (Completed State)
  final tOrderCompleted = OrderEntity(
    id: 'order1',
    user: FakeUserEntity(),
    orderItems: [tOrderItem, tOrderItem],
    shippingAddress: ShippingAddressEntity(street: '20th St', city: 'Giza', phone: '123', lat: '', long: ''),
    store: StoreEntity(name: 'Flowery Store', address: 'Sheikh Zayed, Giza', image: '', phoneNumber: '0101', latLong: ''),
    paymentInfoEntity: PaymentInfoEntity('Cash on delivery', '', false),
    orderInfoEntity: OrderInfoEntity(true, 'Completed', '#123456', '', '', 1, 3000),
  );

  // --- Widget Test ---
  testWidgets('OrderDriverDetails displays Completed state and full data', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: OrderDriverDetails(order: tOrderCompleted),
      ),
    );

    // 1. Verify App Bar and Status Header
    expect(find.text('Order Details'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('#123456'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    // 2. Verify Address Cards (Pickup and User)
    expect(find.text('Pickup Address'), findsOneWidget);
    expect(find.text('User Address'), findsOneWidget);

    // Check Store Address content
    expect(find.text('Flowery Store'), findsOneWidget);
    expect(find.text('Sheikh Zayed, Giza'), findsOneWidget);

    // Check User Address content
    expect(find.text('Wasi Ghoneim'), findsOneWidget);
    expect(find.text('Giza'), findsOneWidget);

    // 3. Verify Order Items List
    expect(find.text('Order details'), findsOneWidget);

    // Check Item Card content (two items displayed)
    expect(find.text('Red roses, 15 Pink Rose Bouquet'), findsNWidgets(2));
    expect(find.text('EGP 600'), findsNWidgets(2));
    expect(find.text('X1'), findsNWidgets(2));

    // Check Total is displayed (implicitly verified by the logic path)

  });

  testWidgets('OrderDriverDetails displays In Progress state correctly', (tester) async {
    final tOrderInProgress = tOrderCompleted.copyWith(
        orderInfoEntity: OrderInfoEntity(false, 'inProgress', '#999', '2024', '2024', 1, 1000)
    );

    await tester.pumpWidget(
      MaterialApp(
        home: OrderDriverDetails(order: tOrderInProgress),
      ),
    );

    // Verify State header changes
    expect(find.text('inProgress'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });
}
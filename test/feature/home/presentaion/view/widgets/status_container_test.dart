import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:tracking_app/core/l10n/translations/app_localizations.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/payment_info_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/shipping_address_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/store_entity.dart';
import 'package:tracking_app/core/common/entity/user_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_item_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/product_entity.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/feature/home/presentaion/view/widgets/status_container.dart';

Widget makeTestableWidget(Widget child) {
  return SizeProvider(
    baseSize: const Size(375, 812),
    height: 812,
    width: 375,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  late OrderEntity fakeOrder;

  setUp(() {
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

    fakeOrder = OrderEntity(
      id: '123',
      user: fakeUser,
      orderItems: [fakeOrderItem],
      shippingAddress: fakeShipping,
      store: fakeStore,
      paymentInfoEntity: fakePayment,
      orderInfoEntity: fakeOrderInfo,
    );
  });

  group('StatusContainer Widget Tests', () {
    testWidgets('renders status, order ID, and date', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(StatusContainer(order: fakeOrder)),
      );

      expect(find.textContaining('Status'), findsOneWidget);

      expect(
        find.textContaining(fakeOrder.orderInfoEntity.state),
        findsOneWidget,
      );

      expect(find.textContaining(fakeOrder.id), findsOneWidget);

      final formattedDate = DateFormat(
        'EEE, dd MMM yyyy',
      ).format(DateTime.now());
      expect(
        find.textContaining(formattedDate.split(',')[1].trim().substring(0, 2)),
        findsOneWidget,
      );
    });

    testWidgets('applies correct background color and rounded border', (
      tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(StatusContainer(order: fakeOrder)),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, equals(AppColors.lightPink));

      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('shows all 3 Text widgets', (tester) async {
      await tester.pumpWidget(
        makeTestableWidget(StatusContainer(order: fakeOrder)),
      );

      final textWidgets = find.byType(Text);
      expect(textWidgets, findsNWidgets(3)); // Status, Order ID, Date
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/l10n/translations/app_localizations.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_item_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/product_entity.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/feature/home/presentaion/view/widgets/order_details_card.dart';
import 'package:tracking_app/core/widgets/cache_image.dart';

Widget makeTestableWidget(Widget child) {
  return SizeProvider(
    baseSize: const Size(375, 812),
    width: 375,
    height: 812,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  late OrderItemEntity fakeOrderItem;

  setUp(() {
    final fakeProduct = ProductEntity(
      id: 'p1',
      title: 'Red Flower',
      slug: 'red-flower',
      description: 'Beautiful red flower',
      imgCover: 'flower.jpg',
      images: ['flower.jpg'],
      price: 100,
      priceAfterDiscount: 80,
      quantity: 2,
      category: 'Roses',
      occasion: 'Birthday',
    );

    fakeOrderItem = OrderItemEntity(
      product: fakeProduct,
      price: 100,
      quantity: 2,
      id: 'item1',
    );
  });

  group('OrderDetailsCard Widget Tests', () {
    testWidgets('renders product image, title, quantity and price', (
      tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(OrderDetailsCard(orderItemEntity: fakeOrderItem)),
      );

      expect(find.byType(CacheImage), findsOneWidget);

      expect(find.text(fakeOrderItem.product.title), findsOneWidget);

      expect(find.text('X${fakeOrderItem.quantity}'), findsOneWidget);

      expect(
        find.textContaining(fakeOrderItem.price.toString()),
        findsOneWidget,
      );
    });

    testWidgets('has correct text styles for title and quantity', (
      tester,
    ) async {
      await tester.pumpWidget(
        makeTestableWidget(OrderDetailsCard(orderItemEntity: fakeOrderItem)),
      );

      final titleText = tester.widget<Text>(
        find.text(fakeOrderItem.product.title),
      );
      expect(titleText.style!.color, equals(AppColors.black));

      final quantityText = tester.widget<Text>(
        find.text('X${fakeOrderItem.quantity}'),
      );
      expect(quantityText.style!.color, equals(AppColors.pink));
    });
  });
}

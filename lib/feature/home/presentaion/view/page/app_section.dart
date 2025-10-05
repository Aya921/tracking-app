import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/constants/app_widgets_keys.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/feature/home/presentaion/view/page/home_page.dart';
import 'package:tracking_app/feature/profile/presentation/views/screens/profile_screen.dart';
import 'package:tracking_app/feature/order/presentation/view/page/order_page.dart';
import 'package:tracking_app/feature/order/presentation/veiw_models/order_veiw_model/order_bloc.dart';
import 'package:tracking_app/feature/order/domain/usecase/get_all_driver_orders.dart';
import 'package:tracking_app/feature/order/domain/repository/order_repository.dart';

import '../../../../../config/di/di.dart';
import '../../../../order/domain/entity/order_driver_entity.dart';
import '../../../../order/domain/entity/order_entity.dart';
import '../../../../order/domain/entity/order_info_entity.dart';
import '../../../../order/domain/entity/order_item_entity.dart';
import '../../../domain/entity/payment_info_entity.dart';
import '../../../domain/entity/product_entity.dart';
import '../../../domain/entity/shipping_address_entity.dart';
import '../../../domain/entity/store_entity.dart';
import '../../../domain/entity/user_entity.dart';

class AppSection extends StatefulWidget {
  final OrderDriverEntity? orderDriverEntity;

  const AppSection({super.key, this.orderDriverEntity});

  @override
  State<AppSection> createState() => _AppSectionState();
}

class _AppSectionState extends State<AppSection> {
  int _page = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: _page);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fakeOrderDriverEntity = OrderDriverEntity(
      orders: [
        OrderEntity(
          id: "1",
          user: UserEntity(
            id: "u1",
            firstName: "Mahmoud",
            lastName: "Ibrahim",
            email: "mahmoud@test.com",
            gender: "male",
            phone: "0100000000",
            photo: "https://picsum.photos/200",
          ),
          orderItems: [
            OrderItemEntity(
              id: "oi1",
              price: 100,
              quantity: 2,
              product: ProductEntity(
                id: "p1",
                title: "Flowers",
                slug: "flowers",
                description: "Nice flowers",
                imgCover: "https://picsum.photos/200",
                images: ["https://picsum.photos/200"],
                price: 100,
                priceAfterDiscount: 80,
                quantity: 10,
                category: "Gift",
                occasion: "Birthday",
              ),
            ),
          ],
          shippingAddress: ShippingAddressEntity(
            street: "123 Street",
            city: "Cairo",
            phone: "0100000000",
            lat: "30.0444",
            long: "31.2357",
          ),
          store: StoreEntity(
            name: "Gift Store",
            image: "https://picsum.photos/200",
            address: "Cairo",
            phoneNumber: "0100000000",
            latLong: "30.0444,31.2357",
          ),
          paymentInfoEntity: PaymentInfoEntity("card", "2025-01-01", true),
          orderInfoEntity: OrderInfoEntity(
            false,
            "Pending",
            "ORD123",
            "2025-01-01",
            "2025-01-02",
            1,
            200,
          ),
        ),
      ],
    );

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (newPage) {
          setState(() {
            _page = newPage;
          });
        },
        children: [
          const HomePage(),
          BlocProvider(
            create: (_) => OrderBloc(
              getIt<GetAllDriverOrdersUseCase>(),
              getIt<OrderRepository>(),
            ),
            child: OrderPage(orderDriverEntity: fakeOrderDriverEntity),
          ),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        onTap: (value) {
          setState(() {
            _pageController.animateToPage(
              value,
              duration: const Duration(milliseconds: 200),
              curve: Curves.decelerate,
            );
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home, key: Key(AppWidgetsKeys.homeKey)),
            label: context.loc.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu, key: Key(AppWidgetsKeys.orderkey)),
            label: context.loc.orders,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person, key: Key(AppWidgetsKeys.profileKey)),
            label: context.loc.profile,
          ),
        ],
      ),
    );
  }
}
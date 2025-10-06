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
import '../../../../order/presentation/veiw_models/order_veiw_model/order_events.dart';

class AppSection extends StatefulWidget {
  const AppSection({super.key});

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
            )..add(const GetDriverOrdersEvent()),
            child: const OrderPage(),
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
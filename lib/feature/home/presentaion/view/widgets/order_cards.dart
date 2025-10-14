import 'package:flutter/material.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_entity.dart';
import 'package:tracking_app/feature/home/presentaion/view/widgets/my_order_card.dart';

class OrderCards extends StatelessWidget {
  final List<OrderEntity> orders;
  final DriverEntity? driver;
  const OrderCards({super.key, required this.orders,required this.driver});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return MyOrderCard(order: order,driver: driver,);
            },
          ),
        ),
      ],
    );
  }
}

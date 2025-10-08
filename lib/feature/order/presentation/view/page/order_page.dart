import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/core/routes/app_route.dart';
import 'package:tracking_app/feature/order/presentation/veiw_models/order_veiw_model/order_bloc.dart';
import 'package:tracking_app/feature/order/presentation/veiw_models/order_veiw_model/order_states.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import '../../veiw_models/order_veiw_model/order_events.dart';
import '../widget/build_order_card.dart';
import '../widget/build_status_chip.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(const GetDriverOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.loc.myOrder,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocBuilder<OrderBloc, OrderStates>(
        builder: (context, state) {
          switch (state.requestState) {
            case RequestState.loading:
              return const Center(child: CircularProgressIndicator());
            case RequestState.error:
              return Center(
                child: Text(state.errorMessage ?? context.loc.error),
              );
            case RequestState.success:
              final orders = state.orders?.orders ?? [];
              if (orders.isEmpty) {
                return Center(child: Text(context.loc.noOrdersFound));
              }
              final cancelledCount = orders
                  .where((o) => o.orderInfoEntity.state == 'Cancelled')
                  .length;
              final completedCount = orders
                  .where((o) => o.orderInfoEntity.state == 'Completed')
                  .length;
              return SingleChildScrollView(
                padding: EdgeInsets.all(context.setWidth(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildStatusChip(
                          context,
                          cancelledCount,
                          "Cancelled",
                          Icons.error_outline,
                          Colors.red,
                        ),
                        SizedBox(width: context.setWidth(16)),
                        buildStatusChip(
                          context,
                          completedCount,
                          "Completed",
                          Icons.check_circle_outline,
                          Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(height: context.setHight(24)),
                    Text(
                      "Recent orders",
                      style: TextStyle(
                        fontSize: context.setSp(FontSize.s18),
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: context.setHight(4)),
                    Column(
                      children: [
                        ...orders.map((order) {
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoute.orderDriverDetails,
                                arguments: order,
                              );
                            },
                            child: buildOrderCard(order),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }



}

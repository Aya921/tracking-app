import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/order/presentation/veiw_models/order_veiw_model/order_bloc.dart';
import 'package:tracking_app/feature/order/presentation/veiw_models/order_veiw_model/order_states.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import '../../veiw_models/order_veiw_model/order_events.dart';

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
        title: Text(context.loc.orders, style: TextStyle(color: Colors.black, fontSize: context.setSp(FontSize.s20))),
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
              return Center(child: Text(state.errorMessage ?? context.loc.error));
            case RequestState.success:
              final orders = state.orders?.orders ?? [];

              if (orders.isEmpty) {
                return Center(child: Text(context.loc.noOrdersFound));
              }

              final cancelledCount = orders.where((o) => o.orderInfoEntity.state == 'Cancelled').length;
              final completedCount = orders.where((o) => o.orderInfoEntity.state == 'Completed').length;

              return SingleChildScrollView(
                padding: EdgeInsets.all(context.setWidth(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatusChip(context, cancelledCount, "Cancelled", Icons.error_outline, Colors.red),
                        SizedBox(width: context.setWidth(16)),
                        _buildStatusChip(context, completedCount, "Completed", Icons.check_circle_outline, Colors.green),
                      ],
                    ),
                    SizedBox(height: context.setHight(24)),
                    Text(
                      context.loc.orders,
                      style: TextStyle(
                        fontSize: context.setSp(FontSize.s18),
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: context.setHight(16)),
                    ...orders.map(_buildOrderCard),
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

  Widget _buildStatusChip(BuildContext context, int count, String label, IconData icon, Color color) {
    return Container(
      width: context.setWidth(160),
      padding: EdgeInsets.symmetric(horizontal: context.setWidth(10), vertical: context.setHight(24)),
      decoration: BoxDecoration(
        color: const Color(0xffF9ECF0),
        borderRadius: BorderRadius.circular(context.setWidth(20)),
        border: Border.all(color: const Color(0xffF9ECF0), width: context.setWidth(1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$count', style: TextStyle(fontSize: context.setSp(FontSize.s20), color: Colors.black)),
          SizedBox(height: context.setHight(4)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: context.setSp(20)),
              SizedBox(width: context.setWidth(4)),
              Text(label, style: TextStyle(color: Colors.black, fontSize: context.setSp(FontSize.s18))),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildOrderCard(OrderEntity order) {
    final status = order.orderInfoEntity.state;
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.help;
    if (status == 'Pending') {
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
    } else if (status == 'Cancelled') {
      statusColor = Colors.red;
      statusIcon = Icons.close;
    } else if (status == 'Completed') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status == 'inProgress') {
      statusColor = Colors.blue;
      statusIcon = Icons.play_arrow;
    }

    final userName = '${order.user.firstName} ${order.user.lastName}'.trim();
    final userAddress = order.shippingAddress.city;
    final userPhotoUrl = order.user.photo;
    String finalUserImageUrl = userPhotoUrl;
    if (!userPhotoUrl.startsWith('http')) {
      finalUserImageUrl = 'https://www.elevateegy.com/$userPhotoUrl';
    }

    final storeName = order.store.name;
    final storeAddress = order.store.address;
    final totalPrice = order.orderInfoEntity.totalPrice.toString();

    return Builder(
      builder: (context) {
        return Container(
          margin: EdgeInsets.only(bottom: context.setHight(16)),
          padding: EdgeInsets.all(context.setWidth(16)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.setWidth(16)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: context.setWidth(10), offset: Offset(0, context.setHight(2))),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.loc.flowerOrder, style: TextStyle(fontSize: context.setSp(FontSize.s18), color: Colors.black87)),
              SizedBox(height: context.setHight(8)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: context.setSp(24)),
                      SizedBox(width: context.setWidth(8)),
                      Text(status, style: TextStyle(color: statusColor, fontSize: context.setSp(FontSize.s18))),
                    ],
                  ),
                  Text('#${order.orderInfoEntity.orderNumber}', style: TextStyle(fontWeight: FontWeightManager.bold, fontSize: context.setSp(FontSize.s16))),
                ],
              ),
              SizedBox(height: context.setHight(16)),
              Divider(height: context.setHight(1), color: Colors.grey),
              SizedBox(height: context.setHight(16)),

              Text(context.loc.pickupAddress, style: getRegularStyle(fontSize: context.setSp(FontSize.s16), color: Colors.grey)),
              _buildAddressCard(
                  context: context,
                  title: storeName,
                  subtitle: storeAddress,
                  icon: Icons.location_on,
                  leadingWidget: CircleAvatar(
                    radius: context.setWidth(20),
                    backgroundColor: const Color(0xffE9406B),
                    child: Icon(
                      Icons.store, // استخدام أيقونة المتجر
                      color: Colors.white,
                      size: context.setSp(20),
                    ),
                  )),
              SizedBox(height: context.setHight(16)),
              Text(context.loc.userAddress, style: getRegularStyle(fontSize: context.setSp(FontSize.s16), color: Colors.grey)),
              _buildAddressCard(
                context: context,
                title: userName.isEmpty ? context.loc.errorReset : userName,
                subtitle: userAddress.isEmpty ? context.loc.userAddress : userAddress,
                icon: Icons.location_on,
                leadingWidget: CircleAvatar(
                  radius: context.setWidth(20),
                  backgroundImage: userPhotoUrl.isNotEmpty ? NetworkImage(finalUserImageUrl) : null,
                  child: userPhotoUrl.isEmpty ? const Icon(Icons.person) : null,
                ),
              ),
              SizedBox(height: context.setHight(16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.loc.total, style: getSemiBoldStyle(fontSize: context.setSp(FontSize.s16), color: Colors.black)),
                  Text('${context.loc.egp} $totalPrice', style: TextStyle(fontSize: context.setSp(FontSize.s16), color: Colors.black)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddressCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget leadingWidget,
  }) {
    return Container(
      margin: EdgeInsets.only(top: context.setHight(8)),
      padding: EdgeInsets.all(context.setWidth(12)),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(context.setWidth(12)),
      ),
      child: Row(
        children: [
          leadingWidget,
          SizedBox(width: context.setWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeightManager.bold, fontSize: context.setSp(FontSize.s16))),
                SizedBox(height: context.setHight(4)),
                Row(
                  children: [
                    Icon(icon, color: Colors.black54, size: context.setSp(16)),
                    SizedBox(width: context.setWidth(4)),
                    Expanded(child: Text(subtitle, style: getRegularStyle(color: Colors.black54, fontSize: context.setSp(FontSize.s14)))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
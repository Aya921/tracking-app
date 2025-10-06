import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/request_state/request_state.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/order/presentation/veiw_models/order_veiw_model/order_bloc.dart';
import 'package:tracking_app/feature/order/presentation/veiw_models/order_veiw_model/order_states.dart';

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
        title: const Text("My orders"),
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
              return Center(child: Text(state.errorMessage ?? "Error occurred"));
            case RequestState.success:
              final orders = state.orders?.orders ?? [];

              if (orders.isEmpty) {
                return const Center(child: Text("No orders found"));
              }

              final cancelledCount = orders.where((o) => o.orderInfoEntity.state == 'Cancelled').length;
              final completedCount = orders.where((o) => o.orderInfoEntity.state == 'Completed').length;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatusChip(cancelledCount, 'Cancelled', Icons.error_outline, Colors.red),
                        const SizedBox(width: 16),
                        _buildStatusChip(completedCount, 'Completed', Icons.check_circle_outline, Colors.green),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Recent orders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
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

  Widget _buildStatusChip(int count, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xffF9ECF0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffF9ECF0), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$count', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Flower order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 24),
                  const SizedBox(width: 8),
                  Text(status, style: TextStyle(color: statusColor, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('#${order.orderInfoEntity.orderNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.grey),
          const SizedBox(height: 16),


          const Text('Pickup address', style: TextStyle(fontSize: 16, color: Colors.grey)),
          _buildAddressCard(
              title: storeName,
              subtitle: storeAddress,
              icon: Icons.location_on,
              leadingWidget: const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xffE9406B),
                child: Icon(
                  Icons.local_florist,
                  color: Colors.white,
                  size: 20,
                ),
              )
          ),
          const SizedBox(height: 16),


          const Text('User address', style: TextStyle(fontSize: 16, color: Colors.grey)),
          _buildAddressCard(
            title: userName.isEmpty ? 'Unknown User' : userName,
            subtitle: userAddress.isEmpty ? 'Address N/A' : userAddress,
            icon: Icons.location_on,
            leadingWidget: CircleAvatar(
              radius: 20,
              backgroundImage: userPhotoUrl.isNotEmpty ? NetworkImage(finalUserImageUrl) : null,
              child: userPhotoUrl.isEmpty ? const Icon(Icons.person) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget leadingWidget,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          leadingWidget,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(icon, color: Colors.black54, size: 16),
                    const SizedBox(width: 4),
                    Expanded(child: Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 14))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }}
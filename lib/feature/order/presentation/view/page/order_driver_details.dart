import 'package:flutter/material.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/feature/order/domain/entity/order_item_entity.dart';

class OrderDriverDetails extends StatelessWidget {
  final OrderEntity order;

  const OrderDriverDetails({
    super.key,
    required this.order,
  });


  @override
  Widget build(BuildContext context) {
    final status = order.orderInfoEntity.state;
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.help;
    if (status == 'Completed') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status == 'inProgress') {
      statusColor = Colors.blue;
      statusIcon = Icons.play_arrow;
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.error_outline;
    }

    final totalPrice = order.orderInfoEntity.totalPrice.toString();
    final orderNumber = order.orderInfoEntity.orderNumber;
    final paymentType = order.paymentInfoEntity.paymentType;


    final userName = '${order.user.firstName} ${order.user.lastName}'.trim();
    final userAddress = order.shippingAddress.city;
    final finalUserImageUrl = order.user.fullPhotoUrl;

    final storeName = order.store.name;
    final storeAddress = order.store.address;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            context.loc.orderDetailsTitle, style: getBoldStyle(color: Colors.black, fontSize: context.setSp(FontSize.s20))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.setWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusHeader(context, status, orderNumber, statusIcon, statusColor),
            SizedBox(height: context.setHight(20)),

            Text(context.loc.pickupAddress, style: getBoldStyle(fontSize: context.setSp(FontSize.s18), color: Colors.black)),
            SizedBox(height: context.setHight(10)),
            _buildAddressCard(
              context: context,
              title: storeName,
              subtitle: storeAddress,
              icon: Icons.location_on,
              leadingWidget: CircleAvatar(
                radius: context.setWidth(20),
                backgroundColor: AppColors.pink,
                child: Icon(Icons.store, color: Colors.white, size: context.setSp(20)),
              ),
            ),
            SizedBox(height: context.setHight(14)),

            Text(context.loc.userAddress, style: getBoldStyle(fontSize: context.setSp(FontSize.s18), color: Colors.black)),
            SizedBox(height: context.setHight(10)),
            _buildAddressCard(
              context: context,
              title: userName.isEmpty ? context.loc.userAddress : userName,
              subtitle: userAddress.isEmpty ? context.loc.accept : userAddress,
              icon: Icons.location_on,
              leadingWidget: CircleAvatar(
                radius: context.setWidth(20),
                backgroundImage: finalUserImageUrl.isNotEmpty ? NetworkImage(finalUserImageUrl) : null,
                child: finalUserImageUrl.isEmpty ? const Icon(Icons.person) : null,
              ),
            ),

            SizedBox(height: context.setHight(16)),
            Text(
              context.loc.orderDetailsTitle,
              style: getBoldStyle(
                fontSize: context.setSp(FontSize.s18),
                color: Colors.black87,
              ),
            ),
            SizedBox(height: context.setHight(10)),
            ...order.orderItems.map((item) {
              return _buildOrderItemCard(context, item);
            }).toList(),

            SizedBox(height: context.setHight(30)),

            _buildDetailRow(
              context: context,
              title: context.loc.total,
              value: '${context.loc.egp} $totalPrice',
              isBold: true,
            ),

            _buildDetailRow(
              context: context,
              title: context.loc.paymentMethod,
              value: paymentType,
              isBold: false,
            ),

            SizedBox(height: context.setHight(40)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context, String status, String orderNumber, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: context.setHight(10), horizontal: context.setWidth(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.setWidth(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: context.setSp(22)),
              SizedBox(width: context.setWidth(8)),
              Text(status, style: getBoldStyle(color: color, fontSize: context.setSp(FontSize.s18))),
            ],
          ),
          Text(orderNumber, style: TextStyle(fontWeight: FontWeightManager.bold, fontSize: context.setSp(FontSize.s16))),
        ],
      ),
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
      padding: EdgeInsets.all(context.setWidth(12)),
      decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(context.setWidth(12)),
          border: Border.all(color: Colors.grey.shade300)
      ),
      child: Row(
        children: [
          leadingWidget,
          SizedBox(width: context.setWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: getBoldStyle(fontSize: context.setSp(FontSize.s16), color: Colors.black)),
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

  Widget _buildDetailRow({
    required BuildContext context,
    required String title,
    required String value,
    required bool isBold,
  }) {
    final style = isBold
        ? getBoldStyle(fontSize: context.setSp(FontSize.s16), color: Colors.black)
        : getRegularStyle(fontSize: context.setSp(FontSize.s16), color: Colors.black87);

    return Container(
      margin: EdgeInsets.only(bottom: context.setHight(10)),
      padding: EdgeInsets.all(context.setWidth(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.setWidth(12)),
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: context.setWidth(5), offset: Offset(0, context.setHight(2))),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}

Widget _buildOrderItemCard(BuildContext context, OrderItemEntity item) {
  final productName = item.product.title;
  final itemPrice = item.price.toString();
  final quantity = item.quantity;
  final imageUrl = item.product.firstImageUrl;

  return Padding(
    padding: EdgeInsets.only(bottom: context.setHight(10)),
    child: Container(
      padding: EdgeInsets.all(context.setWidth(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.setWidth(12)),
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: context.setWidth(5), offset: Offset(0, context.setHight(2))),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: context.setWidth(60),
            height: context.setWidth(60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.setWidth(8)),
            ),
            child: imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
              },
              errorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.broken_image, size: context.setSp(30))),
            )
                : Center(child: Icon(Icons.shopping_bag_outlined, size: context.setSp(30))),
          ),
          SizedBox(width: context.setWidth(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: getSemiBoldStyle(
                      fontSize: context.setSp(FontSize.s16),
                      color: Colors.black
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.setHight(4)),
                Text(
                  '${context.loc.egp} $itemPrice',
                  style: getBoldStyle(
                      fontSize: context.setSp(FontSize.s14),
                      color: Colors.black87
                  ),
                ),
              ],
            ),
          ),

          Text(
            'X$quantity',
            style: getBoldStyle(
              fontSize: context.setSp(FontSize.s18),
              color: const Color(0xffE9406B),
            ),
          ),
        ],
      ),
    ),
  );
}
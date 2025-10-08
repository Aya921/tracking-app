import 'package:flutter/material.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';
import 'package:tracking_app/core/theme/app_colors.dart';

import '../widget/build_address_card.dart';
import '../widget/build_detail_row.dart';
import '../widget/build_order_item_card.dart';
import '../widget/build_status_header.dart';


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
            buildStatusHeader(context, status, orderNumber, statusIcon, statusColor),
            SizedBox(height: context.setHight(20)),

            Text(context.loc.pickupAddress, style: getBoldStyle(fontSize: context.setSp(FontSize.s18), color: Colors.black)),
            SizedBox(height: context.setHight(10)),
            buildAddressCard(
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
            buildAddressCard(
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
              return buildOrderItemCard(context, item);
            }),

            SizedBox(height: context.setHight(30)),

            buildDetailRow(
              context: context,
              title: context.loc.total,
              value: '${context.loc.egp} $totalPrice',
              isBold: true,
            ),

            buildDetailRow(
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


  // Widget _buildAddressCard({
  //   required BuildContext context,
  //   required String title,
  //   required String subtitle,
  //   required IconData icon,
  //   required Widget leadingWidget,
  // }) {
  //   return Container(
  //     padding: EdgeInsets.all(context.setWidth(12)),
  //     decoration: BoxDecoration(
  //         color: const Color(0xffF7F7F7),
  //         borderRadius: BorderRadius.circular(context.setWidth(12)),
  //         border: Border.all(color: Colors.grey.shade300)
  //     ),
  //     child: Row(
  //       children: [
  //         leadingWidget,
  //         SizedBox(width: context.setWidth(12)),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(title, style: getBoldStyle(fontSize: context.setSp(FontSize.s16), color: Colors.black)),
  //               SizedBox(height: context.setHight(4)),
  //               Row(
  //                 children: [
  //                   Icon(icon, color: Colors.black54, size: context.setSp(16)),
  //                   SizedBox(width: context.setWidth(4)),
  //                   Expanded(child: Text(subtitle, style: getRegularStyle(color: Colors.black54, fontSize: context.setSp(FontSize.s14)))),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }


}


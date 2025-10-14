import 'package:flutter/material.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/widgets/cache_image.dart';

import '../../../../../core/theme/font_manger.dart';
import '../../../../../core/theme/font_style_manger.dart';
import '../../../../../core/common/entity/order_entity/order_entity.dart';
import 'build_address_card.dart';

Widget buildOrderCard(OrderEntity order) {
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
  final String finalUserImageUrl = userPhotoUrl;
 

  final storeName = order.store.name;
  final storeAddress = order.store.address;

  return Builder(
    builder: (context) {
      return Container(
        margin: EdgeInsets.only(bottom: context.setHight(16)),
        padding: EdgeInsets.all(context.setWidth(16)),
        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(context.setWidth(16)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xffF9F9F9),
              blurRadius: context.setWidth(10),
              offset: Offset(0, context.setHight(2)),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.loc.flowerOrder,
              style: TextStyle(
                fontSize: context.setSp(FontSize.s18),
                color: Colors.black87,
              ),
            ),
            SizedBox(height: context.setHight(10)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      statusIcon,
                      color: statusColor,
                      size: context.setSp(24),
                    ),
                    SizedBox(width: context.setWidth(8)),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: context.setSp(FontSize.s18),
                      ),
                    ),
                  ],
                ),
                Text(
                  '#${order.orderInfoEntity.orderNumber}',
                  style: TextStyle(
                    fontWeight: FontWeightManager.bold,
                    fontSize: context.setSp(FontSize.s16),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.setHight(8)),

            Text(
              context.loc.pickupAddress,
              style: getRegularStyle(
                fontSize: context.setSp(FontSize.s16),
                color: Colors.grey,
              ),
            ),

            buildAddressCard(
              context: context,
              title: storeName,
              subtitle: storeAddress,
              icon: Icons.location_on,
              leadingWidget: CircleAvatar(
                radius: context.setWidth(20),
                backgroundColor: const Color(0xffE9406B),
                child: Icon(
                  Icons.store,
                  color: Colors.white,
                  size: context.setSp(20),
                ),
              ),
            ),
            SizedBox(height: context.setHight(20)),

            Text(
              context.loc.userAddress,
              style: getRegularStyle(
                fontSize: context.setSp(FontSize.s16),
                color: Colors.grey,
              ),
            ),
            buildAddressCard(
              context: context,
              title: userName.isEmpty ? context.loc.errorReset : userName,
              subtitle: userAddress.isEmpty
                  ? context.loc.userAddress
                  : userAddress,
              icon: Icons.location_on,
              leadingWidget:CacheImage(imageUrl: finalUserImageUrl,)
            ),
            SizedBox(height: context.setHight(16)),
          
          ],
        ),
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';

import '../../../../../core/theme/font_manger.dart';
import '../../../../../core/theme/font_style_manger.dart';
import '../../../../../core/common/entity/order_entity/order_item_entity.dart';

Widget buildOrderItemCard(BuildContext context, OrderItemEntity item) {
  // final productName = item.product.title;
  final itemPrice = item.price.toString();
  final quantity = item.quantity;
  final imageUrl = item.product.firstImageUrl;
  final orderId= item.product.id;

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
                  orderId,
                  style: getSemiBoldStyle(
                      fontSize: context.setSp(FontSize.s12),
                      color: Colors.black
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.setHight(6)),
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
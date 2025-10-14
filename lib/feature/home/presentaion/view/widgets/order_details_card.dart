import 'package:flutter/material.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/core/widgets/cache_image.dart';

import '../../../../../core/common/entity/order_entity/order_item_entity.dart';

class OrderDetailsCard extends StatelessWidget {
  final OrderItemEntity orderItemEntity;

  const OrderDetailsCard({required this.orderItemEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: (8)),
          child: LayoutBuilder(
            builder: (context, size) {
              return SizeProvider(
                baseSize: const Size(311, 60),
                width: size.maxWidth,
                height: double.infinity,
                child: Container(
                  padding: EdgeInsets.all(context.setWidth(10)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.setWidth(10)),
                    color: AppColors.white,

                    boxShadow:  [
                      BoxShadow(
                        color: AppColors.white[60]??AppColors.lightPink,
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child:
                      //////  ROW OF IMAGE AND TEXT  ///////////
                      Row(
                        children: [
                          CacheImage(
                            imageUrl: orderItemEntity.product.imgCover,
                          ),

                          //////  COLUM OF TEXT  ///////////
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.setWidth(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: context.setWidth(220),
                                      child: Text(
                                        orderItemEntity.product.title,
                                        style: getRegularStyle(
                                          color: AppColors.black,
                                          fontSize: context.setSp(FontSize.s13),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    Text(
                                      "X${orderItemEntity.quantity}",
                                      style: getRegularStyle(
                                        color: AppColors.pink,
                                        fontSize: context.setSp(FontSize.s14),
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  "${context.loc.egp} ${orderItemEntity.price.toString()}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

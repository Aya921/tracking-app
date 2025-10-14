import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';

class StatusContainer extends StatelessWidget {
  final OrderEntity order;
  const StatusContainer({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.setHight(100),
      decoration: BoxDecoration(
        color: AppColors.lightPink,
        borderRadius: BorderRadius.circular(
          context.setWidth(10),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.setWidth(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${context.loc.statusLabel} ${order.orderInfoEntity.state}",
              style: getSemiBoldStyle(
                color: AppColors.green,
                fontSize: context.setSp(FontSize.s16),
              ),
            ),
            Text(
              "${context.loc.orderIdLabel} # ${order.id}",
              style: getSemiBoldStyle(
                color: AppColors.black,
                fontSize: context.setSp(FontSize.s16),
              ),
            ),
            Text(
              DateFormat(
                'EEE, dd MMM yyyy, hh:mm a',
              ).format(DateTime.now()),
              style: getMediumStyle(
                color: AppColors.gray,
                fontSize: context.setSp(FontSize.s14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';

import '../../../../../core/theme/font_manger.dart';
import '../../../../../core/theme/font_style_manger.dart';


Widget buildStatusHeader(BuildContext context, String status, String orderNumber, IconData icon, Color color) {
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

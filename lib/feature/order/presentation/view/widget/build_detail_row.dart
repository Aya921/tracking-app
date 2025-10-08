import 'package:flutter/material.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';

import '../../../../../core/theme/font_manger.dart';
import '../../../../../core/theme/font_style_manger.dart';

Widget buildDetailRow({
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
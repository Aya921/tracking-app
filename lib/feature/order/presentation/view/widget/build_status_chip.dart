import 'package:flutter/material.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';

import '../../../../../core/theme/font_manger.dart';


Widget buildStatusChip(
    BuildContext context,
    int count,
    String label,
    IconData icon,
    Color color,
    ) {
  return Container(
    width: context.setWidth(160),
    padding: EdgeInsets.symmetric(
      horizontal: context.setWidth(10),
      vertical: context.setHight(24),
    ),
    decoration: BoxDecoration(
      color: const Color(0xffF9ECF0),
      borderRadius: BorderRadius.circular(context.setWidth(20)),
      border: Border.all(
        color: const Color(0xffF9ECF0),
        width: context.setWidth(1),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: context.setSp(FontSize.s20),
            color: Colors.black,
          ),
        ),
        SizedBox(height: context.setHight(4)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: context.setSp(20)),
            SizedBox(width: context.setWidth(4)),
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: context.setSp(FontSize.s18),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
import 'package:flutter/material.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';

import '../../../../../core/theme/font_manger.dart';
import '../../../../../core/theme/font_style_manger.dart';

Widget buildAddressCard({
  required BuildContext context,
  required String title,
  required String subtitle,
  required IconData icon,
  required Widget leadingWidget,
}) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xffFFFFFF),
      borderRadius: BorderRadius.circular(context.setWidth(12)),
    ),
    child: Container(
      margin: EdgeInsets.only(top: context.setHight(12)),
      padding: EdgeInsets.all(context.setWidth(16)),
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(context.setWidth(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: context.setWidth(5),
            offset: Offset(0, context.setHight(2)),
          ),
        ],
      ),
      child: Row(
        children: [
          leadingWidget,
          SizedBox(width: context.setWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeightManager.bold,
                    fontSize: context.setSp(FontSize.s16),
                  ),
                ),
                SizedBox(height: context.setHight(6)),
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.black54,
                      size: context.setSp(16),
                    ),
                    SizedBox(width: context.setWidth(4)),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: getRegularStyle(
                          color: Colors.black54,
                          fontSize: context.setSp(FontSize.s14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';

class InfoMapWindow extends StatelessWidget {
  const InfoMapWindow({super.key, required this.iconData, required this.title});

  final IconData iconData;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pink,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: AppColors.white,
            child: Icon(iconData, color: AppColors.white),
          ),
          SizedBox(width: context.setWidth(10)),
          Text(
            title,
            style: getMediumStyle(
              color: AppColors.white,
              fontSize: context.setSp(10),
            ),
          ),
        ],
      ),
    );
  }
}

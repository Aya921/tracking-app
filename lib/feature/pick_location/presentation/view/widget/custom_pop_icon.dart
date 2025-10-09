import 'package:flutter/material.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/theme/app_colors.dart';

class CustomPopIcon extends StatelessWidget {
  const CustomPopIcon({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: MouseCursor.defer,
      child: Padding(
        padding: EdgeInsetsGeometry.only(
          left: context.setMinSize(20),
          top: context.setMinSize(30),
        ),
        child: CircleAvatar(
          backgroundColor: AppColors.pink,
          radius: 24.0,
          child: IconButton(
            onPressed: onPressed,
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

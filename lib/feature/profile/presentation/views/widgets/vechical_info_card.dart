import 'package:flutter/material.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/core/common/entity/driver_entity.dart';

class VechicalInfoCard extends StatelessWidget {
    final DriverEntity driverEntity;
  const VechicalInfoCard({super.key,required this.driverEntity});
  

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.loc.vehicalInfo,
                 style: getBoldStyle(color: AppColors.black,fontSize:context.setSp(FontSize.s18)),
                ),
                Text(
                  driverEntity.vehicle.type,
                 style: getMediumStyle(color: AppColors.black,fontSize:context.setSp(FontSize.s14)),
                ),
                Text(
                  driverEntity.vehicle.number,
                style: getMediumStyle(color: AppColors.black,fontSize:context.setSp(FontSize.s14)),
                ),
              ],
            ),
          ],
        ),
    
        const Icon(Icons.arrow_forward_ios, color: AppColors.gray),
      ],
    );
  }
}

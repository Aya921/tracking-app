import 'package:flutter/material.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/common/entity/driver_entity.dart';

class PersonalInfoCard extends StatelessWidget {
  final DriverEntity driverEntity;
  const PersonalInfoCard({super.key, required this.driverEntity});

  @override
  Widget build(BuildContext context) {
    
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(context.setMinSize(40)),
              child: Image.network(
                driverEntity.contactInfo.photo,
                height: context.setHight(50),
                width: context.setWidth(50),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: context.setWidth(10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${driverEntity.firstName} ${driverEntity.lastName}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: context.setSp(FontSize.s16),
                      ),
                ),
                Text(
                  driverEntity.contactInfo.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: context.setSp(FontSize.s14),
                      ),
                ),
                Text(
                  driverEntity.contactInfo.phone,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: context.setSp(FontSize.s14),
                      ),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/pick_location/presentation/data/address_detials_model.dart';

import '../../../../../core/enums/address_type.dart';

class AddressDetialsWidget extends StatelessWidget {
  const AddressDetialsWidget({
    super.key,
    required this.remoteDataEntity,
    required this.addressType,
    required this.isPickedAddress,
  });
 final bool isPickedAddress;
  final RemoteDataEntity remoteDataEntity;
  final AddressType addressType;

  @override
  Widget build(BuildContext context) {
    String image = "";
    String address = "";
    String name = "";
    switch (addressType) {
      case AddressType.driver:
        name =
           remoteDataEntity.driverEntity.firstName +
              remoteDataEntity.driverEntity.lastName ;
        image =   remoteDataEntity.driverEntity.nidImg;
        address =  remoteDataEntity.driverEntity.country;
      case AddressType.user:
        name =
            remoteDataEntity.userEntity!.firstName +
                remoteDataEntity.userEntity!
                    .lastName;
        address =
            remoteDataEntity.orderEntity.shippingAddress
                .city +
            remoteDataEntity.orderEntity.shippingAddress
                    .street;
        image = remoteDataEntity.orderEntity.user.photo;

      case AddressType.store:
        name = remoteDataEntity.orderEntity.store.name;
        image = remoteDataEntity.orderEntity.store.image;
        address =remoteDataEntity.orderEntity.store.address;
    }
    return Column(
      children: [
        Text(
          isPickedAddress
              ? context.loc.pickupAddress
              : context.loc.userAddress,
          style: getMediumStyle(
            color: AppColors.midGray,
            fontSize: context.setSp(14),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.setMinSize(8),
            vertical: context.setMinSize(16),
          ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              CircleAvatar(radius: 24, backgroundImage: NetworkImage(image)),
              SizedBox(width: context.setWidth(10)),
              Column(
                children: [
                  Text(
                    address,
                    style: getMediumStyle(
                      color: AppColors.midGray,
                      fontSize: context.setSp(13),
                    ),
                  ),
                  SizedBox(height: context.setHight(10)),

                  Text(
                    name,
                    style: getMediumStyle(
                      color: AppColors.black,
                      fontSize: context.setSp(13),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

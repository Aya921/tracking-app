import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';

import '../../../../../core/enums/address_type.dart';

class AddressDetialsWidget extends StatelessWidget {
  AddressDetialsWidget({
    super.key,
    required this.remoteDataEntity,
    required this.addressType,
    required this.isPickedAddress,
    this.onPressedPhone,
    this.onPressedWhatsApp,
  });

  final bool isPickedAddress;
  final RemoteDataEntity remoteDataEntity;
  final AddressType addressType;
  void Function()? onPressedPhone;

  void Function()? onPressedWhatsApp;

  @override
  Widget build(BuildContext context) {
    String image = "";
    String address = "";
    String name = "";
    String phone = "";

    switch (addressType) {
      case AddressType.driver:
        name =
            remoteDataEntity.driverEntity.firstName +
                remoteDataEntity.driverEntity.lastName ??
            "";
        image = remoteDataEntity.driverEntity.nidImg ?? "";
        address = remoteDataEntity.driverEntity.country ?? "";
        phone = remoteDataEntity.driverEntity.phone ?? "";
        break;
      case AddressType.user:
        name =
            (remoteDataEntity.orderEntity.user.firstName +
                remoteDataEntity.orderEntity.user.lastName) ??
            "user name";
        address =
            (remoteDataEntity.orderEntity.shippingAddress.city +
                remoteDataEntity.orderEntity.shippingAddress.street) ??
            "benha";
        image = remoteDataEntity.orderEntity.user.photo ?? "";
        phone = remoteDataEntity.orderEntity.user.phone;

        break;

      case AddressType.store:
        name = remoteDataEntity.orderEntity.store.name ?? "";
        image = remoteDataEntity.orderEntity.store.image ?? "";
        address = remoteDataEntity.orderEntity.store.address ?? "";
        break;
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(height: context.setHight(14)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.setMinSize(8),
              vertical: context.setMinSize(16),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.midGray,
                width: context.setWidth(1.5),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: CachedNetworkImageProvider(
                    image,

                    errorListener: (e) =>
                        const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
                SizedBox(width: context.setWidth(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        name ?? "rana",
                        style: getMediumStyle(
                          color: AppColors.midGray,
                          fontSize: context.setSp(13),
                        ),
                      ),
                      SizedBox(height: context.setHight(10)),

                      Text(
                        address ?? "benha",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(
                          color: AppColors.black,
                          fontSize: context.setSp(13),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: onPressedPhone,
                      icon: const Icon(
                        CupertinoIcons.phone,
                        color: AppColors.pink,
                      ),
                    ),
                    IconButton(
                      onPressed: onPressedWhatsApp,
                      icon: const Icon(
                        FontAwesomeIcons.whatsapp,
                        color: AppColors.pink,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

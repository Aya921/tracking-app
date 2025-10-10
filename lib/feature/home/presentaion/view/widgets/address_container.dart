import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tracking_app/core/enums/address_type.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/feature/home/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/presentaion/view/widgets/cache_image.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_events.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_view_model.dart';
//
// class AddressContainer extends StatelessWidget {
//   final String? containerName;
//   final OrderEntity orderEntity;
//   final AddressType addressType;
//   final String? phoneNum;
//   final bool fromOrderDetails;
//
//   // info about driver
//   const AddressContainer({
//     required this.addressType,
//     this.containerName,
//     required this.orderEntity,
//     required this.fromOrderDetails,
//     this.phoneNum,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     String address = '', name = '', image = '';
//     if (addressType == AddressType.store) {
//       address = orderEntity.store.address;
//       name = orderEntity.store.name;
//       image = orderEntity.store.image;
//     } else if (addressType == AddressType.user) {
//       address =
//           orderEntity.shippingAddress.city + orderEntity.shippingAddress.street;
//       name = orderEntity.user.firstName + orderEntity.user.lastName;
//       image = orderEntity.user.photo;
//     }
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//
//       children: [
//         !fromOrderDetails
//             ? Text(
//                 containerName!,
//                 style: getRegularStyle(
//                   color: AppColors.black,
//                   fontSize: context.setSp(FontSize.s13),
//                 ),
//               )
//             : const SizedBox(height: 0),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: (8)),
//           child: InkWell(
//             onTap: () {
//               // if type is user then go to map user and driver
//               // if type is store then go to map store and driver
//
//               // need information about driver,user,stor
//             },
//             child: LayoutBuilder(
//               builder: (context, size) {
//                 return SizeProvider(
//                   baseSize:  Size(311, 60),
//                   width: size.maxWidth,
//                   height: double.infinity,
//                   child: Container(
//                     padding: EdgeInsets.all(context.setWidth(10)),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(context.setWidth(10)),
//                       color: AppColors.white,
//
//                       boxShadow:  [
//                         BoxShadow(
//                           color: AppColors.white[60]??AppColors.lightPink,
//                           blurRadius: 1,
//                           spreadRadius: 1,
//                           offset:const Offset(0, 0),
//                         ),
//                       ],
//                     ),
//                     child:
//                         //////  ROW OF IMAGE AND TEXT  ///////////
//                         Row(
//                           children: [
//                             CacheImage(imageUrl: image),
//
//                             //////  COLUM OF TEXT  ///////////
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: context.setWidth(10),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       SizedBox(
//                                         width: context.setWidth(190),
//                                         child: Text(
//                                           name,
//                                           style: getRegularStyle(
//                                             color: AppColors.black,
//                                             fontSize: context.setSp(
//                                               FontSize.s13,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       fromOrderDetails
//                                           ? Row(
//                                               children: [
//                                                 InkWell(
//                                                   onTap: () {
//                                                     if (phoneNum != null) {
//                                                       context
//                                                           .read<HomeViewModel>()
//                                                           .add(
//                                                             CallUserEvent(
//                                                               phoneNum!,
//                                                             ),
//                                                           );
//                                                     }
//                                                   },
//                                                   child: Icon(
//                                                     Icons.call,
//                                                     color: AppColors.pink,
//                                                     size: context.setWidth(20),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: context.setWidth(10),
//                                                 ),
//                                                 InkWell(
//                                                   onTap: () {
//                                                     if (phoneNum != null) {
//                                                       context
//                                                           .read<HomeViewModel>()
//                                                           .add(
//                                                             WhatsAppUserEvent(
//                                                               phoneNum!,
//                                                             ),
//                                                           );
//                                                     }
//                                                   },
//                                                   child: Icon(
//                                                     FontAwesomeIcons.whatsapp,
//                                                     color: AppColors.pink,
//                                                     size: context.setWidth(22),
//                                                   ),
//                                                 ),
//                                               ],
//                                             )
//                                           : const SizedBox(),
//                                     ],
//                                   ),
//
//                                   //////  ROW OF ADDRESS  ///////////
//                                   Row(
//                                     children: [
//                                       const Icon(Icons.location_on_outlined),
//
//                                       SizedBox(
//                                         width: context.setWidth(180),
//                                         child: Text(
//                                           address,
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class AddressContainer extends StatelessWidget {
  final String? containerName;
  final OrderEntity orderEntity;
  final AddressType addressType;
  final String? phoneNum;
  final bool fromOrderDetails;
  final VoidCallback? onTap; // أضف هذا

  const AddressContainer({
    required this.addressType,
    this.containerName,
    required this.orderEntity,
    required this.fromOrderDetails,
    this.phoneNum,
    this.onTap, // أضف هذا
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String address = '', name = '', image = '';
    if (addressType == AddressType.store) {
      address = orderEntity.store.address;
      name = orderEntity.store.name;
      image = orderEntity.store.image;
    } else if (addressType == AddressType.user) {
      address =
          orderEntity.shippingAddress.city + orderEntity.shippingAddress.street;
      name = orderEntity.user.firstName + orderEntity.user.lastName;
      image = orderEntity.user.photo;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !fromOrderDetails
            ? Text(
          containerName!,
          style: getRegularStyle(
            color: AppColors.black,
            fontSize: context.setSp(FontSize.s13),
          ),
        )
            : const SizedBox(height: 0),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: InkWell(
            onTap: onTap, // استخدم onTap هنا
            child: LayoutBuilder(
              builder: (context, size) {
                return SizeProvider(
                  baseSize: const Size(311, 60),
                  width: size.maxWidth,
                  height: double.infinity,
                  child: Container(
                    padding: EdgeInsets.all(context.setWidth(10)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.setWidth(10)),
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.white[60] ?? AppColors.lightPink,
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CacheImage(imageUrl: image),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.setWidth(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: context.setWidth(190),
                                    child: Text(
                                      name,
                                      style: getRegularStyle(
                                        color: AppColors.black,
                                        fontSize: context.setSp(FontSize.s13),
                                      ),
                                    ),
                                  ),
                                  fromOrderDetails
                                      ? Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (phoneNum != null) {
                                            context
                                                .read<HomeViewModel>()
                                                .add(
                                              CallUserEvent(
                                                phoneNum!,
                                              ),
                                            );
                                          }
                                        },
                                        child: Icon(
                                          Icons.call,
                                          color: AppColors.pink,
                                          size: context.setWidth(20),
                                        ),
                                      ),
                                      SizedBox(
                                        width: context.setWidth(10),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (phoneNum != null) {
                                            context
                                                .read<HomeViewModel>()
                                                .add(
                                              WhatsAppUserEvent(
                                                phoneNum!,
                                              ),
                                            );
                                          }
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.whatsapp,
                                          color: AppColors.pink,
                                          size: context.setWidth(22),
                                        ),
                                      ),
                                    ],
                                  )
                                      : const SizedBox(),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined),
                                  SizedBox(
                                    width: context.setWidth(180),
                                    child: Text(
                                      address,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
              },
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:tracking_app/core/enums/address_type.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/feature/order/domain/entity/order_entity.dart';
import 'package:tracking_app/feature/home/presentaion/view/widgets/address_container.dart';
import 'package:tracking_app/feature/home/presentaion/view/widgets/custum_btn.dart';

class OrderCards extends StatelessWidget {
  final List<OrderEntity> orders;
  const OrderCards({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return 
              MyOrderCard(order: order);
            },
          ),
        ),
      ],
    );
  }
}

class MyOrderCard extends StatelessWidget {
  const MyOrderCard({
    super.key,
    required this.order,
  });

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,size) {

        
        return SizeProvider(
          baseSize:const  Size(343,299),
          height:size.maxHeight,
          width: size.maxWidth,
          child: Container(
            margin:  EdgeInsets.symmetric(vertical: context.setHight(10)),
            padding:  EdgeInsets.all(context.setWidth(15)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.setWidth(10)),
              color: AppColors.white,
          
              boxShadow: const [
                BoxShadow(
                  color: AppColors.lightGray30,
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: context.setHight(8)),
                  child: Text(
                    context.loc.flowerOrder,
                    style: getBoldStyle(
                      color: AppColors.black,
                      fontSize: context.setSp(FontSize.s18),
                    ),
                  ),
                ),
                AddressContainer(
                  addressType: AddressType.store,
                  containerName:context.loc.pickupAddress,
                  orderEntity:order,
                  fromOrderDetails: false,),
                 SizedBox(height:context.setHight(15) ),
                AddressContainer(
                  addressType:AddressType.user,
                  containerName: context.loc.userAddress,
                  orderEntity:order,
                  fromOrderDetails: false,),
          
                SizedBox(height:context.setHight(10) ),
          
                CustumBtn(order: order,),
              ],
            ),
          ),
        );
      },
    );
  }
}

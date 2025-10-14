import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/core/common/driver_entity/driver_entity.dart';
import 'package:tracking_app/feature/home/domain/enum/order_state_enum.dart';
import 'package:tracking_app/core/common/entity/order_entity/order_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_events.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_view_model.dart';

class CustumBtn extends StatelessWidget {
  final OrderEntity order;
  final DriverEntity? driver;
  CustumBtn({super.key, required this.order, required this.driver});
  final HomeViewModel _homeViewModel = getIt.get<HomeViewModel>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeViewModel,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            " ${context.loc.egp} ${order.orderInfoEntity.totalPrice}",
            style: getBoldStyle(
              color: AppColors.black,
              fontSize: context.setSp(FontSize.s18),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              side: const BorderSide(color: AppColors.pink),
            ),

            onPressed: () {
              _homeViewModel.add(DeleteOrderLocalyEvent(order.id));
            },
            child: Text(
              context.loc.reject,
              style: getRegularStyle(
                color: AppColors.pink,
                fontSize: context.setSp(FontSize.s16),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (driver != null) {
               
                final fakeRemoteDataEntity = RemoteDataEntity(
                  driver!,

                  order.copyWith(
                    orderInfoEntity: order.orderInfoEntity.copyWith(
                      state: ApiOrderStates.inProgress.name,
                    ),
                  ),
                  "Accepted",  // will be see soon
                );

                _homeViewModel.add(StartProgressEvnet(fakeRemoteDataEntity));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text(context.loc.noAccountDriverFound)),
                );
              }
            },
            child: Text(
              context.loc.accept,
              style: getRegularStyle(
                color: AppColors.white,
                fontSize: context.setSp(FontSize.s16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

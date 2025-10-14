import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/assets_manager/assets_manger.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/routes/app_route.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';
import 'package:tracking_app/core/widgets/common_loading.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_events.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_states.dart';
import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_view_model.dart';

import '../../../domain/entity/start_order_request_entity.dart';

class ThanksPage extends StatefulWidget {
  final String orderId;

  const ThanksPage({super.key, required this.orderId});

  @override
  State<ThanksPage> createState() => _ThanksPageState();
}

class _ThanksPageState extends State<ThanksPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(value: getIt<HomeViewModel>()
        ..add(UpdateOrderEvent(widget.orderId, const UpdateOrderRequestEntity(
           "completed"
        )))
        , child: BlocConsumer<HomeViewModel, HomeStates>(
          listener: (context, state) {
            if(state.errorMessage!=null ){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const CommonLoading();
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: context.setWidth(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImgAssets.successOrderPlaced),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: context.setHight(25)),
                    child: SizedBox(
                      child: Text(
                        context.loc.orderPlacedSuccessfullyTitle,
                        textAlign: TextAlign.center,
                        style: getBoldStyle(
                          color: AppColors.black[50]!,
                          fontSize: context.setSp(FontSize.s30),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoute.home);
                      },
                      child: Text(
                        context.loc.done,
                        style: getRegularStyle(
                          color: AppColors.white,
                          fontSize: context.setSp(FontSize.s16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

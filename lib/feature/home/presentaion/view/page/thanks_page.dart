import 'package:flutter/material.dart';
import 'package:tracking_app/core/assets_manager/assets_manger.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/routes/app_route.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/core/theme/font_manger.dart';
import 'package:tracking_app/core/theme/font_style_manger.dart';

class ThanksPage extends StatelessWidget {
  const ThanksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.setWidth(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImgAssets.successOrderPlaced),
            Padding(
              padding: EdgeInsets.symmetric(vertical: context.setHight(25)),
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
      ),
    );
  }
}

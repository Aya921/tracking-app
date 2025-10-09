import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tracking_app/core/assets_manager/assets_manger.dart';
import 'package:tracking_app/core/l10n/translations/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';

class ThanksScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Lottie.asset(ImgAssets.thankslogo,height:300,width: 300,fit: BoxFit.cover)),
          SizedBox(height:20),
          Center(child: Text(AppLocalizations.of(context)!.thanku, style: Theme.of(context).textTheme.titleLarge,)),
          SizedBox(height: 20,),
          Center(child: Text(AppLocalizations.of(context)!.orderCompleted, style: Theme.of(context).textTheme.titleLarge?.copyWith(color:  AppColors.black))),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){}, child:Text(AppLocalizations.of(context)!., style: Theme.of(context).textTheme.titleLarge?.copyWith(color:  AppColors.white)),
            style: ElevatedButton.styleFrom(
            minimumSize: Size(200, 50),
            backgroundColor: AppColors.pink[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),),


        ],
      ),
    );
  }

}
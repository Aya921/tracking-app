import 'package:device_preview/device_preview.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/config/app_language_config/app_language_config.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/constants/constants.dart';
import 'package:tracking_app/core/helper/shared_preference.dart';
import 'package:tracking_app/core/l10n/translations/app_localizations.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/core/routes/app_route.dart';
import 'package:tracking_app/core/routes/routes.dart';
import 'package:tracking_app/core/theme/app_theme.dart';

void main() async {
  ///ensure engine is Oky
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await getIt.get<AppLanguageConfig>().setSelectedLocal();


  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => ChangeNotifierProvider.value(
        value: getIt.get<AppLanguageConfig>(),
        child:const MyApp(

        ),
      ),
    ),
  );
}

bool isLogin =  false;
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key, });
//
//
//   @override
//   Widget build(BuildContext context) {
//     final appLanguageConfig = Provider.of<AppLanguageConfig>(context);
//     final initialRoute =  isLogin ? AppRoute.home : AppRoute.onBoarding;
//
//     return SizeProvider(
//       baseSize: const Size(375, 812),
//       height: context.screenHight,
//       width: context.screenWidth,
//       child: MaterialApp(
//         initialRoute: initialRoute,
//         debugShowCheckedModeBanner: false,
//         localizationsDelegates: AppLocalizations.localizationsDelegates,
//         supportedLocales: AppLocalizations.supportedLocales,
//         locale: Locale(appLanguageConfig.selectedLocal),
//         theme: AppTheme.lightTheme,
//         onGenerateRoute: Routes.onGenerate,
//       ),
//     );
//   }
//
//
// }
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appLanguageConfig = Provider.of<AppLanguageConfig>(context);

    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(

              ),
            ),
          );
        }

        final bool isLoggedIn = snapshot.data ?? false;
        final initialRoute = isLoggedIn ? AppRoute.home : AppRoute.onBoarding;

        return SizeProvider(
          baseSize: const Size(375, 812),
          height: context.screenHight,
          width: context.screenWidth,
          child: MaterialApp(
            initialRoute: initialRoute,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(appLanguageConfig.selectedLocal),
            theme: AppTheme.lightTheme,
            onGenerateRoute: Routes.onGenerate,
          ),
        );
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    final bool isRemembered =await SharedPreferHelper.isLogin(Constants.rememberMe);
    return  isRemembered;
  }
}

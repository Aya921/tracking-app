import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/config/app_language_config/app_language_config.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/constants/constants.dart';
import 'package:tracking_app/core/l10n/translations/app_localizations.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/core/routes/app_route.dart';
import 'package:tracking_app/core/routes/routes.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'package:tracking_app/feature/auth/api/data_source/local/user_local_storage_impl.dart';



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

bool isRemembered =  false;

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
             debugShowCheckedModeBanner: false,
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
            initialRoute:  AppRoute.onBoarding,
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
      isRemembered =await UserLocalStorageImpl().isLoggedIn(
        Constants.rememberMe);
    return  isRemembered;
  }
}
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/config/app_language_config/app_language_config.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/l10n/translations/app_localizations.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/core/responsive/size_provider.dart';
import 'package:tracking_app/core/routes/app_route.dart';
import 'package:tracking_app/core/routes/routes.dart';
import 'package:tracking_app/core/theme/app_theme.dart';
import 'feature/auth/api/data_source/local/user_local_storage_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await getIt.get<AppLanguageConfig>().setSelectedLocal();
  runApp(
    DevicePreview(
      enabled: false,
    builder: (context) =>
    ChangeNotifierProvider.value(
      value: getIt.get<AppLanguageConfig>(),
      child: const  MyApp()),

    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _loginFuture;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() {
    _loginFuture = UserLocalStorageImpl().isLoggedIn();
  }
  @override
  Widget build(BuildContext context) {
    final appLanguageConfig = Provider.of<AppLanguageConfig>(context);

    return SizeProvider(
      baseSize: const Size(375, 812),
      height: context.screenHight,
      width: context.screenWidth,
      child: FutureBuilder<bool>(
        future: _loginFuture,
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

          final isLoggedIn = snapshot.hasData ?
          snapshot.data! : false;
          final initialRoute = isLoggedIn ?
          AppRoute.home : AppRoute.onBoarding;

          return MaterialApp(
            navigatorKey: Routes.navigatorKey,
            initialRoute: initialRoute,

            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(appLanguageConfig.selectedLocal),
            theme: AppTheme.lightTheme,
            onGenerateRoute: Routes.onGenerate,
          );
        },
      ),
    );
  }
}
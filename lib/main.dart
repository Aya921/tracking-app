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
import 'package:tracking_app/feature/auth/domain/entity/driver_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/store_entity.dart';
import 'package:tracking_app/feature/home/domain/entity/user_entity.dart';
import 'package:tracking_app/feature/pick_location/presentation/data/address_detials_model.dart';
import 'feature/auth/api/data_source/local/user_local_storage_impl.dart';
import 'feature/pick_location/presentation/view/screens/pick_up_location_screen.dart';

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
          //  home: PickUpLocationScreen(),
          //initialRoute: AppRoute.onBoarding,
//             home:  PickUpLocationScreen(
// // addressModel:AddressDetailsModel(
// //     userEntity: UserEntity(id: "68c4b421dd8937e0573ce528", firstName: "mariam",
// //         lastName: "mohmed", email: "mar@gmail.com",
// //         gender: "female", phone: "01061728082",
// //         photo: "default-profile.png") ,storeEntity: StoreEntity(
// // name: "Elevate FlowerApp Store",
// //     image: "https://www.elevateegy.com/elevate.png",
// //     address: "123 Fixed Address, City, Country",
// //     phoneNumber: "1234567890",
// //     latLong: "37.7749,-122.4194"
// // ), driverEntity: DriverEntity(id: "", country: "Egypt",
// //     firstName: "mki", lastName: "pop", vehicleType: "Sedan",
// //     vehicleNumber: "12345678", vehicleLicense: "", nid: "",
// //     nidImg: "",
// //     email: "",
// //     gender: "",
// //     phone: "",
// //     photo: "",
// //     role: "",
// //     createdAt: "")), isStore: true ,
//             ),
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
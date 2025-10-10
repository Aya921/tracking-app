import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/core/enums/address_type.dart';
import 'package:tracking_app/core/extensions/app_localization_extenstion.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/pick_location/presentation/view/widget/address_detials_widget.dart';
import 'package:tracking_app/feature/pick_location/presentation/view_model/pick_up_location_view_model.dart';
import '../../../../home/presentaion/view_models/home_view_model/home_events.dart';
import '../widget/custom_map.dart';
import '../widget/custom_pop_icon.dart';
import 'package:tracking_app/core/assets_manager/assets_manger.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
class PickUpLocationScreen extends StatefulWidget {
  final RemoteDataEntity? remoteDataEntity;
  final bool? isStore;

  const PickUpLocationScreen({
    super.key,
     this.remoteDataEntity,
     this.isStore,
  });

  @override
  State<PickUpLocationScreen> createState() => _PickUpLocationScreenState();
}

class _PickUpLocationScreenState extends State<PickUpLocationScreen> {
  late final MapViewModel _provider;

  @override
  void initState() {
    super.initState();
    // Create the provider instance directly using getIt
    _provider = getIt<MapViewModel>();
    // Initialize the map after a small delay to ensure widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.initMap(widget.remoteDataEntity!, widget.isStore!);
    });
    //context.read<HomeViewModel>();
  }




  @override
  Widget build(BuildContext context) {
    print("gooooooooooooooooooooooooooo to user");
final parts=
widget.remoteDataEntity!.orderEntity.store.latLong.split(",");


return
      ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        body: Consumer<MapViewModel>(
          builder: (context, provider, _) {


            if (provider.isLoading) {
              return  Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Lottie.asset(ImgAssets.loading,
                    width: context.setWidth(100),
                      height: context.setHight(120),
                      fit: BoxFit.cover
                    ),
                      SizedBox(height: context.setHight(16)),
                      Text(context.loc.loadingMap),
                    ],
                  ),
                ),
              );
            }

            if (provider.driverLocation == null) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_off, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('Unable to get your location'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          provider.initMap(widget.remoteDataEntity!,
                              widget.isStore!);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child:             Stack(
                    children: [
                      CustomMap(
                        driverLocation: provider.driverLocation!,
                        mapController: provider.controller,

                        polylines:
                        {
                          Polyline(
                              color: AppColors.pink,
                              width: 3,
                              polylineId:const PolylineId("polyline 11 "),
                              points:       widget.isStore==true? [
                                provider.driverLocation! ,
                                LatLng(double.parse(parts[0]),
                                    double.parse(parts[1]))
                              ]:[

                                provider.driverLocation! ,

                                LatLng(double.
                                parse(widget.remoteDataEntity!.orderEntity.shippingAddress.lat),
                                    double.parse(widget.remoteDataEntity!
                                        .orderEntity.shippingAddress.long)),
                              ]
                          )
                        }
                        ,

                      ),
                      Positioned(
                        top: 20,
                        left: 10,
                        child: CustomPopIcon(
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),


                    ],
                  ),
                ),
                widget.isStore==true?
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      AddressDetialsWidget(
                          remoteDataEntity: widget.remoteDataEntity!,
                          addressType: AddressType.store,
                          isPickedAddress: true,
                        onPressedPhone: () {
                            provider.homeViewModel.add(CallUserEvent(widget.remoteDataEntity!.orderEntity.store.phoneNumber));
                        },
                        onPressedWhatsApp: () {
                          provider.homeViewModel.add(WhatsAppUserEvent
                            (widget.remoteDataEntity!.orderEntity.store.phoneNumber));

                        },
                      ),
                      SizedBox(height: context.setHight(10),),
                      AddressDetialsWidget(
                          remoteDataEntity: widget.remoteDataEntity!,
                          addressType: AddressType.user,
                          isPickedAddress: false,
                        onPressedPhone: () {
                          provider.homeViewModel.add(
                              CallUserEvent(widget.remoteDataEntity!.
                              orderEntity
                                  .user.phone));
                        },
                        onPressedWhatsApp: () {
                          provider.homeViewModel.add(WhatsAppUserEvent
                            (widget.remoteDataEntity!.orderEntity.user.phone));

                        },
                      ),

                    ],
                  ),
                ):
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      AddressDetialsWidget(
                          remoteDataEntity: widget.remoteDataEntity!,
                          addressType: AddressType.user,
                          onPressedPhone: () {
                            provider.homeViewModel.add(
                                CallUserEvent(widget.remoteDataEntity!.
                                orderEntity
                                .user.phone));
                          },
                          onPressedWhatsApp: () {
                            provider.homeViewModel.add(WhatsAppUserEvent
                              (widget.remoteDataEntity!.orderEntity.user.phone));

                          },
                          isPickedAddress: false),
                      SizedBox(height: context.setHight(10),

                      ),
                      AddressDetialsWidget(
                          onPressedPhone: () {
                            provider.homeViewModel.add(CallUserEvent(widget.remoteDataEntity!.orderEntity.store.phoneNumber));
                          },
                          onPressedWhatsApp: () {
                            provider.homeViewModel.add(WhatsAppUserEvent
                              (widget.remoteDataEntity!.orderEntity.store.phoneNumber));

                          },
                          remoteDataEntity: widget.remoteDataEntity!,
                          addressType: AddressType.store,
                          isPickedAddress: true),

                    ],
                  ),
                )
              ],
            );


          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up if needed
    super.dispose();
  }
}

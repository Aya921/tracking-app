import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/config/di/di.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import 'package:tracking_app/feature/pick_location/presentation/view_model/pick_up_location_view_model.dart';
import '../widget/custom_map.dart';
import '../widget/custom_pop_icon.dart';



// class PickUpLocationScreen extends StatelessWidget {
//   const PickUpLocationScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     var provider=Provider.of<MapViewModel>(context);
//     return ChangeNotifierProvider.value(
//         value: getIt<MapViewModel>(),
//     child:   Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(
//             child: Stack(
//               children: [
//                 CustomMap(
//                   driverLocation:provider.driverLocation!,
//                   mapController: provider.controller,
//                 ),
//                 CustomPopIcon(onPressed: (){})
//               ],
//             ),
//           ),
//
//         ],
//       ),
//     )
//     );
//
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tracking_app/config/di/di.dart';
// import 'package:tracking_app/feature/pick_location/presentation/view_model/pick_up_location_view_model.dart';
// import '../widget/custom_map.dart';
// import '../widget/custom_pop_icon.dart';
//
// class PickUpLocationScreen extends StatelessWidget {
//   const PickUpLocationScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => getIt<MapViewModel>(),
//       builder: (context, _) {
//         final provider = context.watch<MapViewModel>();
//
//         if (provider.isLoading || provider.driverLocation == null) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//         return Scaffold(
//           body: CustomScrollView(
//             slivers: [
//               SliverToBoxAdapter(
//                 child: Stack(
//                   children: [
//                     CustomMap(
//                       driverLocation: provider.driverLocation!,
//                       mapController: provider.controller,
//                       markers: provider.markers,
//                       polylines: provider.polylines,
//                     ),
//                     CustomPopIcon(onPressed: () =>
//                         Navigator.pop(context)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:tracking_app/feature/pick_location/presentation/data/address_detials_model.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:tracking_app/core/theme/app_colors.dart';

// class PickUpLocationScreen extends StatelessWidget {
//   final AddressDetailsModel addressDetailsModel;
//   final bool isStore;
//
//   const PickUpLocationScreen({
//     super.key,
//     required this.addressDetailsModel,
//     required this.isStore,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return   Scaffold(
//       body: Stack(
//         children: [
//           CustomMap(
//             driverLocation: provider.driverLocation!,
//             mapController: provider.controller,
//             markers: provider.markers,
//             polylines: provider.polylines,
//           ),
//           CustomPopIcon(onPressed: () => Navigator.pop(context)),
//
//           // أزرار الاتصال والواتساب
//           Positioned(
//             bottom: 25,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 FloatingActionButton(
//                   heroTag: "callBtn",
//                   backgroundColor: AppColors.pink,
//                   onPressed: () {
//                     final phone = isStore
//                         ? addressDetailsModel.storeEntity.phoneNumber
//                         : addressDetailsModel.userEntity.phone;
//
//                   },
//                   child: const Icon(Icons.call),
//                 ),
//                 FloatingActionButton(
//                   heroTag: "whatsappBtn",
//                   backgroundColor: Colors.green,
//                   onPressed: () {
//                     final phone = isStore
//                         ? addressDetailsModel.storeEntity.phoneNumber
//                         : addressDetailsModel.userEntity.phone;
//
//                   },
//                   child: const Icon(Icons.g_mobiledata),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
// }

//
//
// class PickUpLocationScreen extends StatefulWidget {
//   final AddressDetailsModel addressDetailsModel;
//   final bool isStore;
//
//   const PickUpLocationScreen({
//     super.key,
//     required this.addressDetailsModel,
//     required this.isStore,
//   });
//
//   @override
//   State<PickUpLocationScreen> createState() => _PickUpLocationScreenState();
// }
//
// class _PickUpLocationScreenState extends State<PickUpLocationScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = context.read<MapViewModel>();
//       provider.initMap(widget.addressDetailsModel, widget.isStore);
//     });
//   }
//
//   Future<void> _makePhoneCall(String phoneNumber) async {
//     final Uri launchUri = Uri(
//       scheme: 'tel',
//       path: phoneNumber,
//     );
//     if (await canLaunchUrl(launchUri)) {
//       await launchUrl(launchUri);
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Could not launch $phoneNumber')),
//         );
//       }
//     }
//   }
//
//   Future<void> _launchWhatsApp(String phoneNumber) async {
//     // Remove any non-digit characters from phone number
//     final cleanedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
//
//     final Uri launchUri = Uri(
//       scheme: 'https',
//       host: 'wa.me',
//       path: cleanedPhone,
//     );
//     if (await canLaunchUrl(launchUri)) {
//       await launchUrl(launchUri);
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not launch WhatsApp')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => getIt<MapViewModel>(),
//       child: Scaffold(
//         body: Consumer<MapViewModel>(
//           builder: (context, provider, _) {
//             if (provider.isLoading) {
//               return const Scaffold(
//                 body: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(),
//                       SizedBox(height: 16),
//                       Text('Loading map...'),
//                     ],
//                   ),
//                 ),
//               );
//             }
//
//             if (provider.driverLocation == null) {
//               return Scaffold(
//                 body: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.location_off, size: 64, color: Colors.red),
//                       const SizedBox(height: 16),
//                       const Text('Unable to get your location'),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () {
//                           provider.initMap(widget.addressDetailsModel, widget.isStore);
//                         },
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//
//             return Stack(
//               children: [
//                 CustomMap(
//                   driverLocation: provider.driverLocation!,
//                   mapController: provider.controller,
//                   markers: provider.markers,
//                   polylines: provider.polylines,
//                 ),
//                 Positioned(
//                   top: 50,
//                   left: 20,
//                   child: CustomPopIcon(
//                     onPressed: ()=>Navigator.pop(context),
//                   ),
//                 ),
//
//                 // Destination info card
//                 Positioned(
//                   top: 50,
//                   right: 20,
//                   left: 80,
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 8,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           provider.getDestinationName(widget.isStore, widget.addressDetailsModel),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           widget.isStore
//                               ? widget.addressDetailsModel.storeEntity.address
//                               : widget.addressDetailsModel.shippingAddress.street,
//                           style: TextStyle(color: Colors.grey[600]),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 // Call and WhatsApp buttons
//                 Positioned(
//                   bottom: 25,
//                   left: 0,
//                   right: 0,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       FloatingActionButton(
//                         heroTag: "callBtn",
//                         backgroundColor: AppColors.pink,
//                         onPressed: () {
//                           final phone = provider.getDestinationPhone(
//                               widget.isStore,
//                               widget.addressDetailsModel
//                           );
//                           _makePhoneCall(phone);
//                         },
//                         child: const Icon(Icons.call),
//                       ),
//                       FloatingActionButton(
//                         heroTag: "whatsappBtn",
//                         backgroundColor: Colors.green,
//                         onPressed: () {
//                           final phone = provider.getDestinationPhone(
//                               widget.isStore,
//                               widget.addressDetailsModel
//                           );
//                           _launchWhatsApp(phone);
//                         },
//                         child: const Icon(Icons.chat),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//





















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
  }




  @override
  Widget build(BuildContext context) {
    print("gooooooooooooooooooooooooooo to user");

    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        body: Consumer<MapViewModel>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading map...'),
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

            return Column(
              children: [
                Stack(
                  children: [
                    CustomMap(
                      driverLocation: provider.driverLocation!,
                      mapController: provider.controller,
                      markers: provider.markers,
                      polylines: provider.polylines,

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
                Text("driver ===>  ${provider.driverLocation!.longitude} ${provider.driverLocation!.latitude}               ")
              ,  Text("user ===>  ${provider.polylines}")

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

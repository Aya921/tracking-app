

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart' ;
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import '../../../home/presentaion/view_models/home_view_model/home_view_model.dart';


@singleton
class MapViewModel with ChangeNotifier {
  final Completer<GoogleMapController> _controller = Completer();
  Completer<GoogleMapController> get controller => _controller;
  final HomeViewModel homeViewModel;
   MapViewModel(this.homeViewModel);


  final Location location = Location();
  LatLng? driverLocation;
  bool isLoading = true;
  StreamSubscription<LocationData>? _locationSubscription;



  Future<void> initMap(RemoteDataEntity model, bool isStore) async {
    try {
      isLoading = true;
      notifyListeners();

      await setDriverLocation(model,isStore);




    } catch (e) {
      debugPrint("Error initializing map: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setDriverLocation(RemoteDataEntity remote,bool isStore) async {
    try {
      // First, check if location service is enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled');
        }
      }

      // Check and request permission
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw Exception('Location permission denied');
        }
      }

      // Get current location
   final   LocationData currentLocation = await location.getLocation();
      driverLocation = LatLng(
        currentLocation.latitude ?? 0.0,
        currentLocation.longitude ?? 0.0,
      );

      // Listen for location updates
      _locationSubscription = location.onLocationChanged.listen((
          LocationData newLocation) {
        if (newLocation.latitude != null && newLocation.longitude != null) {
          driverLocation = LatLng(
            newLocation.latitude!,
            newLocation.longitude!,
          );
       //   _updateDriverMarker();
         // _updatePolylineStartPoint(driverLocation!);
          notifyListeners();
        }
      });

      // Enable background mode for continuous tracking
      await location.enableBackgroundMode(enable: true);

    } catch (e) {
      debugPrint("Error getting location: $e");
      // Fallback to a default location if needed
      driverLocation = isStore? parseLatLng(remote.orderEntity.store.latLong):
      LatLng(double.parse(remote.orderEntity.shippingAddress.lat),
          double.parse(remote.orderEntity.shippingAddress.long));
      rethrow;
    }
  }

  LatLng parseLatLng(String latLngStr) {
    final parts = latLngStr.split(',');
    if (parts.length != 2) {
      throw FormatException('Invalid latLong format: $latLngStr');
    }
    return LatLng(
      double.parse(parts[0].trim()),
      double.parse(parts[1].trim()),
    );
  }


  void updateDriverLocationFromFirebase(LatLng newLocation) {
    driverLocation = newLocation;
   // _moveCameraToDriver();
    notifyListeners();
  }
  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

}

// @singleton
// class MapViewModel with ChangeNotifier {
//   final Completer<GoogleMapController> _controller = Completer();
//   Completer<GoogleMapController> get controller => _controller;
//
//   final HomeViewModel homeViewModel;
//   MapViewModel(this.homeViewModel);
//
//   final Location location = Location();
//   LatLng? driverLocation;
//   bool isLoading = true;
//   StreamSubscription<LocationData>? _locationSubscription;
//
//   Future<void> initMap(RemoteDataEntity model, bool isStore) async {
//     try {
//       isLoading = true;
//       notifyListeners();
//
//       await _setDriverLocation(model.driverEntity);
//
//       LatLng destinationLatLng;
//       if (isStore) {
//         destinationLatLng =
//             _parseLatLng(model.orderEntity.store.latLong);
//       } else {
//         destinationLatLng = LatLng(
//           double.parse(model.orderEntity.shippingAddress.lat),
//           double.parse(model.orderEntity.shippingAddress.long),
//         );
//       }
//
//     } catch (e) {
//       debugPrint("Error initializing map: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> _setDriverLocation(DriverEntity driver) async {
//     try {
//       // تأكد من تفعيل خدمة الموقع
//       bool serviceEnabled = await location.serviceEnabled();
//       if (!serviceEnabled) {
//         serviceEnabled = await location.requestService();
//         if (!serviceEnabled) throw Exception('Location services are disabled');
//       }
//
//       // تحقق من الصلاحيات
//       PermissionStatus permissionGranted = await location.hasPermission();
//       if (permissionGranted == PermissionStatus.denied) {
//         permissionGranted = await location.requestPermission();
//         if (permissionGranted != PermissionStatus.granted) {
//           throw Exception('Location permission denied');
//         }
//       }
//
//       // احصل على الموقع الحالي
//       LocationData currentLocation = await location.getLocation();
//       driverLocation = LatLng(
//         currentLocation.latitude ?? 0.0,
//         currentLocation.longitude ?? 0.0,
//       );
//
//       // 👇 حرك الكاميرا أول مرة على مكان السواق
//       //await _moveCameraToDriver();
//
//       // تتبع الموقع بشكل مستمر
//       _locationSubscription =
//           location.onLocationChanged.listen((LocationData newLocation) {
//             if (newLocation.latitude != null && newLocation.longitude != null) {
//               driverLocation = LatLng(
//                 newLocation.latitude!,
//                 newLocation.longitude!,
//               );
//               // 👇 حرك الكاميرا أثناء الحركة
//              // _moveCameraToDriver();
//               notifyListeners();
//             }
//           });
//
//       // تفعيل التتبع في الخلفية
//       await location.enableBackgroundMode(enable: true);
//
//     } catch (e) {
//       debugPrint("Error getting location: $e");
//       driverLocation = const LatLng(30.0444, 31.2357); // القاهرة كـ fallback
//       rethrow;
//     }
//   }
//
//   LatLng _parseLatLng(String latLngStr) {
//     final parts = latLngStr.split(',');
//     if (parts.length != 2) {
//       throw FormatException('Invalid latLong format: $latLngStr');
//     }
//     return LatLng(
//       double.parse(parts[0].trim()),
//       double.parse(parts[1].trim()),
//     );
//   }
//
//   // Future<void> _moveCameraToDriver() async {
//   //   try {
//   //     if (!_controller.isCompleted) {
//   //       // ⏳ لسه الماب متحملتش بالكامل
//   //       debugPrint("⚠️ Map controller not ready yet, waiting...");
//   //       return;
//   //     }
//   //
//   //     if (driverLocation == null) return;
//   //
//   //     final GoogleMapController mapController = await _controller.future;
//   //     await mapController.animateCamera(
//   //       CameraUpdate.newCameraPosition(
//   //         CameraPosition(
//   //           target: driverLocation!,
//   //           zoom: 14,
//   //         ),
//   //       ),
//   //     );
//   //   } catch (e) {
//   //     debugPrint("⚠️ Error animating camera: $e");
//   //   }
//   // }
//
//
//
//   void updateDriverLocationFromFirebase(LatLng newLocation) {
//     driverLocation = newLocation;
//     //_moveCameraToDriver();
//     notifyListeners();
//   }
//
//   @override
//   void dispose() {
//     _locationSubscription?.cancel();
//     super.dispose();
//   }
// }



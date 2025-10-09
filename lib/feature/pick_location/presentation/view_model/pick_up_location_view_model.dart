

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_colors.dart';
import 'package:tracking_app/feature/home/domain/entity/remote_data_entity.dart';
import '../../../auth/domain/entity/driver_entity.dart';
import '../../../home/presentaion/view_models/home_view_model/home_view_model.dart';
// @singleton
// class MapViewModel with ChangeNotifier {
//   final Completer<GoogleMapController> _controller = Completer();
//   Completer<GoogleMapController> get controller => _controller;
//  final  HomeViewModel homeViewModel;
//   MapViewModel(this.homeViewModel);
//   Set<Marker> markers = {};
//   Set<Polyline> polylines = {};
// final Location location=Location();
//   LatLng? driverLocation;
//   bool isLoading = true;
//
//   Future<void> initMap(AddressDetailsModel model,
//       bool isStore) async {
//     try {
//       isLoading = true;
//       notifyListeners();
//
//       await _setDriverLocation(model.driverEntity);
//
//       if (isStore) {
//         _addMarkers(
//           driverLatLng: driverLocation!,
//           destinationLatLng: _parseLatLng(model.storeEntity.latLong),
//           destinationName: model.storeEntity.name,
//         );
//         _drawRoute(driverLocation!, _parseLatLng(model.storeEntity.latLong));
//       } else {
//         _addMarkers(
//           driverLatLng: driverLocation!,
//           destinationLatLng: _parseLatLng(model.userEntity.phone), // ← هنا المفروض تضيفي latLong لو عندك في userEntity
//           destinationName:
//           "${model.userEntity.firstName} ${model.userEntity.lastName}",
//         );
//         _drawRoute(driverLocation!,
//             _parseLatLng(model.userEntity.phone));
//       }
//     } catch (e) {
//       debugPrint("Error initializing map: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> _setDriverLocation(DriverEntity driver) async {
// await location.getLocation();
//
//
//   }
//   LatLng _parseLatLng(String latLngStr) {
//     final parts = latLngStr.split(',');
//     return LatLng(double.parse(parts[0]), double.parse(parts[1]));
//   }
//
//   void _addMarkers({
//     required LatLng driverLatLng,
//     required LatLng destinationLatLng,
//     required String destinationName,
//
//   }) {
//     markers = {
//       Marker(
//         markerId: const MarkerId('driver'),
//         position: driverLatLng,
//         infoWindow: const InfoWindow(title: "Your Location"),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
//       ),
//       Marker(
//         markerId: const MarkerId('destination'),
//         position: destinationLatLng,
//         infoWindow: InfoWindow(title: destinationName),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
//       ),
//     };
//   }
//
//   void _drawRoute(LatLng start, LatLng end) {
//     polylines = {
//       Polyline(
//         polylineId: const PolylineId('route'),
//         points: [start, end],
//         color: Colors.pinkAccent,
//         width: 5,
//       ),
//     };
//   }
//
//
//   // Future<LatLng> getLatLngFromCountry(String country) async {
//   //   try {
//   //     List<Location> locations = await locationFromAddress(country);
//   //
//   //     if (locations.isNotEmpty) {
//   //       return LatLng(locations.first.latitude, locations.first.longitude);
//   //     } else {
//   //       throw Exception('No location found for $country');
//   //     }
//   //   } catch (e) {
//   //     throw Exception('Error getting location for $country: $e');
//   //   }
//   // }
// }

// import 'package:flutter/cupertino.dart';
// import 'package:injectable/injectable.dart';
// import 'package:location/location.dart';
// import 'package:tracking_app/feature/home/presentaion/view_models/home_view_model/home_view_model.dart';
// import 'package:tracking_app/feature/pick_location/presentation/data/address_detials_model.dart';
// @singleton
// class PickUpLocationViewModel with ChangeNotifier{
//   LocationData? currentLocation;
//   final Location location=Location();
//   final HomeViewModel homeViewModel;
//   PickUpLocationViewModel(this.homeViewModel);
//   Future<void> getCurrentLocation(AddressDetailsModel model)async{
//   var userLocation=await location.getLocation();
//   currentLocation=userLocation;
//   notifyListeners();
//   location.onLocationChanged.listen((LocationData newLocation){
//     currentLocation=newLocation;
//     notifyListeners();
//   });
//   }
//
//
// }
// @singleton
// class MapViewModel with ChangeNotifier {
//   final Completer<GoogleMapController> _controller = Completer();
//   Completer<GoogleMapController> get controller => _controller;
//   final HomeViewModel homeViewModel;
//   MapViewModel(this.homeViewModel);
//
//   Set<Marker> markers = {};
//   Set<Polyline> polylines = {};
//   final Location location = Location();
//   LatLng? driverLocation;
//   bool isLoading = true;
//   StreamSubscription<LocationData>? _locationSubscription;
//
//   @override
//   void dispose() {
//     _locationSubscription?.cancel();
//     super.dispose();
//   }
//
//   Future<void> initMap(RemoteDataEntity model, bool isStore) async {
//     try {
//       isLoading = true;
//       notifyListeners();
//
//       await _setDriverLocation(model.driverEntity);
//
//       if (isStore) {
//         // For store location
//         _addMarkers(
//           driverLatLng: driverLocation!,
//           destinationLatLng: _parseLatLng(model.orderEntity.store.latLong),
//           destinationName: model.orderEntity.store.name,
//         );
//         _drawRoute(driverLocation!,
//             _parseLatLng(model.orderEntity.store.latLong));
//       } else {
//         // For customer location - use shipping address coordinates
//         final customerLatLng = LatLng(
//           double.parse(model.orderEntity.shippingAddress.lat),
//           double.parse(model.orderEntity.shippingAddress.long),
//         );
//
//         _addMarkers(
//           driverLatLng: driverLocation!,
//           destinationLatLng: customerLatLng,
//           destinationName: "${model.orderEntity.user.firstName} ${model.orderEntity.user.lastName}",
//         );
//         _drawRoute(driverLocation!, customerLatLng);
//       }
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
//       // First, check if location service is enabled
//       bool serviceEnabled = await location.serviceEnabled();
//       if (!serviceEnabled) {
//         serviceEnabled = await location.requestService();
//         if (!serviceEnabled) {
//           throw Exception('Location services are disabled');
//         }
//       }
//
//       // Check and request permission
//       PermissionStatus permissionGranted = await location.hasPermission();
//       if (permissionGranted == PermissionStatus.denied) {
//         permissionGranted = await location.requestPermission();
//         if (permissionGranted != PermissionStatus.granted) {
//           throw Exception('Location permission denied');
//         }
//       }
//
//       // Get current location
//       LocationData currentLocation = await location.getLocation();
//       driverLocation = LatLng(currentLocation.latitude!,
//           currentLocation.longitude!);
//
//       // Listen for location updates
//       _locationSubscription = location.onLocationChanged.listen((
//           LocationData newLocation) {
//         if (newLocation.latitude != null && newLocation.longitude != null) {
//           driverLocation =
//               LatLng(newLocation.latitude!, newLocation.longitude!);
//           _updateDriverMarker();
//           notifyListeners();
//         }
//       });
//
//       // Enable background mode for continuous tracking
//       await location.enableBackgroundMode(enable: true);
//
//     } catch (e) {
//       debugPrint("Error getting location: $e");
//       // You might want to show an error to the user or use a default location
//       rethrow;
//     }
//   }
//
//   LatLng _parseLatLng(String latLngStr) {
//     final parts = latLngStr.split(',');
//     if (parts.length != 2) {
//       throw FormatException('Invalid latLong format: $latLngStr');
//     }
//     return LatLng(double.parse(parts[0].trim()), double.parse(parts[1].trim()));
//   }
//
//   void _addMarkers({
//     required LatLng driverLatLng,
//     required LatLng destinationLatLng,
//     required String destinationName,
//   }) {
//     markers = {
//       Marker(
//         markerId: const MarkerId('driver'),
//         position: driverLatLng,
//         infoWindow: const InfoWindow(title: "Your Location"),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
//       ),
//       Marker(
//         markerId: const MarkerId('destination'),
//         position: destinationLatLng,
//         infoWindow: InfoWindow(title: destinationName),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
//       ),
//     };
//     notifyListeners();
//   }
//
//   void _drawRoute(LatLng start, LatLng end) {
//     polylines = {
//       Polyline(
//         polylineId:  PolylineId('route'),
//         points: [start, end],
//         color: AppColors.pink,
//         width: 5,
//       ),
//     };
//     notifyListeners();
//   }
//
//
//
//   void _updateDriverMarker() {
//     if (driverLocation == null) return;
//
//     markers.removeWhere((marker) => marker.markerId.value == 'driver');
//     markers.add(Marker(
//       markerId: const MarkerId('driver'),
//       position: driverLocation!,
//       infoWindow: const InfoWindow(title: "Your Location"),
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
//     ));
//     notifyListeners();
//   }
//
//   // Method to update driver location from Firebase stream
//   void updateDriverLocationFromFirebase(LatLng newLocation) {
//     driverLocation = newLocation;
//     _updateDriverMarker();
//
//     // Update polyline if needed
//     if (polylines.isNotEmpty) {
//       final polyline = polylines.first;
//       final newPoints = [...polyline.points];
//       if (newPoints.isNotEmpty) {
//         newPoints[0] = newLocation;
//         polylines = {
//           polyline.copyWith(pointsParam: newPoints),
//         };
//       }
//     }
//
//     notifyListeners();
//   }
//
//   // Method to get destination phone number based on context
//   String getDestinationPhone(bool isStore, RemoteDataEntity model) {
//     return isStore ? model.orderEntity.store.phoneNumber
//         : model.orderEntity.shippingAddress.phone;
//   }
//
//   // Method to get destination name based on context
//   String getDestinationName(bool isStore, RemoteDataEntity model) {
//     return isStore
//         ? model.orderEntity.store.name
//         : "${model.orderEntity.user.firstName} ${model.orderEntity.user.lastName}";
//   }
// }
@singleton
class MapViewModel with ChangeNotifier {
  final Completer<GoogleMapController> _controller = Completer();
  Completer<GoogleMapController> get controller => _controller;
  final HomeViewModel homeViewModel;
  MapViewModel(this.homeViewModel);

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  final Location location = Location();
  LatLng? driverLocation;
  bool isLoading = true;
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> initMap(RemoteDataEntity model, bool isStore) async {
    try {
      isLoading = true;
      notifyListeners();

      await _setDriverLocation(model.driverEntity);

      LatLng destinationLatLng;
      String destinationName;

      if (isStore) {
        // For store location
        destinationLatLng = _parseLatLng(model.orderEntity.store.latLong);
        destinationName = model.orderEntity.store.name;
      } else {
        // For customer location - use shipping address coordinates
        destinationLatLng = LatLng(
          double.parse(model.orderEntity.shippingAddress.lat),
          double.parse(model.orderEntity.shippingAddress.long),
        );
        destinationName = "${model.orderEntity.user.firstName} ${model.orderEntity.user.lastName}";
      }

      _addMarkers(
        driverLatLng: driverLocation!,
        destinationLatLng: destinationLatLng,
        destinationName: destinationName,
      );

      await _drawRoute(driverLocation!, destinationLatLng);

      // Move camera to fit both locations
      await _moveCameraToFitBothLocations(driverLocation!, destinationLatLng);

    } catch (e) {
      debugPrint("Error initializing map: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _setDriverLocation(DriverEntity driver) async {
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
      LocationData currentLocation = await location.getLocation();
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
          _updateDriverMarker();
          _updatePolylineStartPoint(driverLocation!);
          notifyListeners();
        }
      });

      // Enable background mode for continuous tracking
      await location.enableBackgroundMode(enable: true);

    } catch (e) {
      debugPrint("Error getting location: $e");
      // Fallback to a default location if needed
      driverLocation = const LatLng(30.0444, 31.2357); // Cairo coordinates as fallback
      rethrow;
    }
  }

  LatLng _parseLatLng(String latLngStr) {
    final parts = latLngStr.split(',');
    if (parts.length != 2) {
      throw FormatException('Invalid latLong format: $latLngStr');
    }
    return LatLng(
      double.parse(parts[0].trim()),
      double.parse(parts[1].trim()),
    );
  }

  void _addMarkers({
    required LatLng driverLatLng,
    required LatLng destinationLatLng,
    required String destinationName,
  }) {
    markers = {
      Marker(
        markerId: const MarkerId('driver'),
        position: driverLatLng,
        infoWindow: const InfoWindow(title: "Your Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        zIndex: 2,
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: destinationLatLng,
        infoWindow: InfoWindow(title: destinationName),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
        zIndex: 1,
      ),
    };
    notifyListeners();
  }

  Future<void> _drawRoute(LatLng start, LatLng end) async {
    try {
      // For now, using straight line. You can integrate Google Directions API later
      polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: [start, end],
          color: AppColors.pink.withOpacity(0.8),
          width: 6,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
          zIndex: 1,
        ),
      };

      debugPrint("Polyline created from: $start to: $end");
      debugPrint("Polyline points count: ${polylines.first.points.length}");

      notifyListeners();
    } catch (e) {
      debugPrint("Error drawing route: $e");
      // Fallback to basic polyline
      polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: [start, end],
          color: Colors.blue, // Fallback color
          width: 4,
        ),
      };
      notifyListeners();
    }
  }

  void _updateDriverMarker() {
    if (driverLocation == null) return;

    final newMarkers = markers.map((marker) {
      if (marker.markerId.value == 'driver') {
        return marker.copyWith(
          positionParam: driverLocation!,
        );
      }
      return marker;
    }).toSet();

    markers = newMarkers;
    notifyListeners();
  }

  void _updatePolylineStartPoint(LatLng newStartPoint) {
    if (polylines.isEmpty) return;

    final updatedPolylines = polylines.map((polyline) {
      if (polyline.polylineId.value == 'route' && polyline.points.length >= 2) {
        final newPoints = [newStartPoint, ...polyline.points.sublist(1)];
        return polyline.copyWith(
          pointsParam: newPoints,
        );
      }
      return polyline;
    }).toSet();

    polylines = updatedPolylines;
    notifyListeners();
  }

  Future<void> _moveCameraToFitBothLocations(LatLng start, LatLng end) async {
    try {
      final controller = await _controller.future;

      // Calculate bounds that include both points
      final southwest = LatLng(
        start.latitude < end.latitude ? start.latitude : end.latitude,
        start.longitude < end.longitude ? start.longitude : end.longitude,
      );
      final northeast = LatLng(
        start.latitude > end.latitude ? start.latitude : end.latitude,
        start.longitude > end.longitude ? start.longitude : end.longitude,
      );

      final bounds = LatLngBounds(southwest: southwest, northeast: northeast);

      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100.0),
      );
    } catch (e) {
      debugPrint("Error moving camera: $e");
      // Fallback to showing start point
      final controller = await _controller.future;
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(start, 14.0),
      );
    }
  }

  // Method to update driver location from Firebase stream
  void updateDriverLocationFromFirebase(LatLng newLocation) {
    driverLocation = newLocation;
    _updateDriverMarker();
    _updatePolylineStartPoint(newLocation);
    notifyListeners();
  }

  // Method to get destination phone number based on context
  String getDestinationPhone(bool isStore, RemoteDataEntity model) {
    return isStore
        ? model.orderEntity.store.phoneNumber
        : model.orderEntity.shippingAddress.phone;
  }

  // Method to get destination name based on context
  String getDestinationName(bool isStore, RemoteDataEntity model) {
    return isStore
        ? model.orderEntity.store.name
        : "${model.orderEntity.user.firstName} ${model.orderEntity.user.lastName}";
  }

  // Debug method to check polyline state
  void debugPolylineState() {
    debugPrint("=== Polyline Debug ===");
    debugPrint("Polylines count: ${polylines.length}");
    if (polylines.isNotEmpty) {
      final polyline = polylines.first;
      debugPrint("Polyline ID: ${polyline.polylineId.value}");
      debugPrint("Polyline points count: ${polyline.points.length}");
      if (polyline.points.isNotEmpty) {
        debugPrint("Start point: ${polyline.points.first}");
        debugPrint("End point: ${polyline.points.last}");
      }
    }
    debugPrint("Markers count: ${markers.length}");
    debugPrint("Driver location: $driverLocation");
    debugPrint("======================");
  }

  // Refresh map data
  Future<void> refreshMap(RemoteDataEntity model, bool isStore) async {
    await initMap(model, isStore);
  }
}
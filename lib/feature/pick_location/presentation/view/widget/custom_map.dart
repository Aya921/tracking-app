
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/assets_manager/assets_manger.dart';

// class CustomMap extends StatefulWidget {
//   const CustomMap({
//     super.key,
//     required this.mapController,
//     required this.driverLocation,
//
//     required this.polylines,
//   });
//
//   final Completer<GoogleMapController> mapController;
//   final LatLng driverLocation;
//   final Set<Polyline> polylines;
//
//   @override
//   State<CustomMap> createState() => _CustomMapState();
// }
//
// class _CustomMapState extends State<CustomMap> {
//   String? _mapStyle;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMapStyle();
//   }
//
//   Future<void> _loadMapStyle() async {
//     final style = await rootBundle.loadString(ImgAssets.mapStyle);
//     setState(() => _mapStyle = style);
//   }
//
//   void _onMapCreated(GoogleMapController controller) {
//     if (!widget.mapController.isCompleted) {
//       widget.mapController.complete(controller);
//     }
//
//     if (_mapStyle != null) {
//       controller.setMapStyle(_mapStyle);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.6,
//       child: GoogleMap(
//        // zoomControlsEnabled: false,
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: widget.driverLocation,
//           zoom: 14.0,
//
//         ),
//         myLocationEnabled: true,
//         myLocationButtonEnabled: false,
//         compassEnabled: true,
//         rotateGesturesEnabled: true,
//         scrollGesturesEnabled: true,
//         zoomGesturesEnabled: true,
//         polylines: widget.polylines,
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/core/theme/app_colors.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({
    super.key,
    required this.mapController,
    required this.driverLocation,
    required this.polylines,
  });

  final Completer<GoogleMapController> mapController;
  final LatLng driverLocation;
  final Set<Polyline> polylines;

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
    final style = await rootBundle.loadString(ImgAssets.mapStyle);
    setState(() => _mapStyle = style);
  }

  void _onMapCreated(GoogleMapController controller) {
    if (!widget.mapController.isCompleted) {
      widget.mapController.complete(controller);
    }
    if (_mapStyle != null) {
      controller.setMapStyle(_mapStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: widget.driverLocation,
          zoom: 6,
        ),
       myLocationEnabled: true,

        myLocationButtonEnabled: false,
       compassEnabled: true,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        polylines: widget.polylines,
      ),
    );
  }
}

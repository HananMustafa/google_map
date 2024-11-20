import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_map/googleMap/direction/direction.dart';
import 'package:google_map/provider/map_providers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Index extends ConsumerStatefulWidget {
  const Index({super.key});

  @override
  ConsumerState<Index> createState() => _IndexState();
}

class _IndexState extends ConsumerState<Index> {
  final Location _locationController = Location();

  @override
  initState() {
    super.initState();
    getLocationUpdates();
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {

        //Replaced with setState
        ref.read(locationProvider.notifier).state =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = ref.watch(locationProvider);

    return Scaffold(
      body: Stack(
        children: [
          currentLocation == null
              ? const Center(child: Text('Loading...'))
              : GoogleMap(
                  initialCameraPosition: CameraPosition(target: currentLocation, zoom: 13),
                  markers: {
                    Marker(
                      markerId: const MarkerId("_currentLocation"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                      position: currentLocation,
                    ),
                  },
                ),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.only(bottom: 120),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Direction(
                      sourceLat: currentLocation!.latitude,
                      sourceLong: currentLocation.longitude,
                      sourceDescription: "Your Location",
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.directions,
                size: 45,
                color: const Color.fromRGBO(5, 185, 95, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

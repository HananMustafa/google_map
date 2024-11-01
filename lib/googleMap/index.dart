import 'package:flutter/material.dart';
import 'package:google_map/googleMap/direction/direction.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  static const LatLng _pSource = LatLng(33.5968788, 73.0528412);

  //For getting Current Location
  final Location _locationController = Location();

  LatLng? _currentP;
  double? currentLat=0;
  double? currentLong=0;
  String? sourceDescription;

  @override
  initState() {
    super.initState();
    getLocationUpdates();
  }

  //Function to get Current Location
  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    //GETTING CONTINOUS CALLBACKS WHEN LOCATION IS CHANGING
    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          //Updating the current location
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
              currentLat= currentLocation.latitude;
              currentLong= currentLocation.longitude;
              sourceDescription= "Your Location";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //IF Current Position = null
        body: Stack(
      children: [
        _currentP == null
            ? const Center(
                child: Text('Loading...'),
              )

            //If we have the Current Position
            : GoogleMap(
                initialCameraPosition:
                    const CameraPosition(target: _pSource, zoom: 13),
                markers: {
                  Marker(
                      markerId: const MarkerId("_currentLocation"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
                      position: _currentP!),
                },
              ),
        Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.only(bottom: 120),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Direction(
                    sourceLat: currentLat!, 
                    sourceLong: currentLong!,
                    sourceDescription: sourceDescription!,
                    )));
                },
                icon: const Icon(
                  Icons.directions,
                  size: 45,
                  color: Color.fromRGBO(62, 75, 255, 1),
                ))),
      ],
    ));
  }
}

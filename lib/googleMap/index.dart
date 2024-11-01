import 'package:flutter/material.dart';
import 'package:google_map/googleMap/direction/direction.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class index extends StatefulWidget {
  const index({super.key});

  @override
  State<index> createState() => _indexState();
}

class _indexState extends State<index> {
  static const LatLng _pSource = LatLng(33.5968788, 73.0528412);

  //For getting Current Location
  Location _locationController = new Location();

  LatLng? _currentP = null;
  double? currentLat=0;
  double? currentLong=0;
  String? sourceDescription=null;

  @override
  initState() {
    super.initState();
    getLocationUpdates();
  }

  //Function to get Current Location
  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
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
                    CameraPosition(target: _pSource, zoom: 13),
                markers: {
                  Marker(
                      markerId: MarkerId("_currentLocation"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
                      position: _currentP!),
                },
              ),
        Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(bottom: 120),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>direction(
                    sourceLat: currentLat!, 
                    sourceLong: currentLong!,
                    sourceDescription: sourceDescription!,
                    )));
                },
                icon: Icon(
                  Icons.directions,
                  size: 45,
                  color: Color.fromRGBO(62, 75, 255, 1),
                ))),
      ],
    ));
  }
}

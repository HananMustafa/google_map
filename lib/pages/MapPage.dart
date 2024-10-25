import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);

  //For getting Current Location
  Location _locationController = new Location();

  LatLng? _currentP = null;



  @override
  initState() {
    super.initState();
    getLocationUpdates();
  }








  //Function to get Current Location
  Future<void> getLocationUpdates() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if(_serviceEnabled){
      _serviceEnabled = await _locationController.requestService();
    }else{
      return;
    }


    _permissionGranted = await _locationController.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await _locationController.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }


    //GETTING CONTINOUS CALLBACKS WHEN LOCATION IS CHANGING
  _locationController.onLocationChanged.listen((LocationData currentLocation) {
        if(currentLocation.latitude != null && currentLocation.longitude !=null){
              setState(() {
                //Updating the current location
                _currentP= LatLng(currentLocation.latitude!, currentLocation.longitude!);
                print("Ping: $_currentP");
              });
            }
    });

  }













  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _pGooglePlex, 
          zoom: 13),

          markers: { 
            Marker(markerId: MarkerId("_currentLocation"), 
            icon: BitmapDescriptor.defaultMarker, 
            position: _pGooglePlex),

            Marker(markerId: MarkerId("_sourceLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pApplePark)
          },
      ),
    );
  }
}

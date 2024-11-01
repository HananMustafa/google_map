import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map/googleMap/direction/Direction.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class DisplayPolyline extends StatefulWidget {
  final double sourceLat;
  final double sourceLong;
  final double destLat;
  final double destLong;

  const DisplayPolyline(
      {super.key,
      required this.sourceLat,
      required this.sourceLong,
      required this.destLat,
      required this.destLong});

  @override
  State<DisplayPolyline> createState() => _DisplayPolylineState();
}

class _DisplayPolylineState extends State<DisplayPolyline> {
  late LatLng _pSource;
  late LatLng _pDestination;

  //For getting Current Location
  final Location _locationController = Location();

  LatLng? _currentP;
  double? currentLat = 0;
  double? currentLong = 0;
  String? sourceDescription;

  Map<PolylineId, Polyline> polylines = {};

  @override
  initState() {
    super.initState();
    _pSource = LatLng(widget.sourceLat, widget.sourceLong);
    _pDestination = LatLng(widget.destLat, widget.destLong);

    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then((coordinates) => {
              // print(coordinates),
              generatePolyLineFromPoints(coordinates),
            }),
      },
    );
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
          currentLat = currentLocation.latitude;
          currentLong = currentLocation.longitude;
          sourceDescription = "Your Location";

          // print("Ping: $_currentP");
          // print("Source Lat: ${widget.sourceLat}");
          // print("Source Long: ${widget.sourceLong}");
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
                      markerId: const MarkerId("_currentLocation"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
                      position: _currentP!),
                  Marker(
                      markerId: const MarkerId("_sourceLocation"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
                      position: _pSource),
                  Marker(
                      markerId: const MarkerId("_destinationLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _pDestination)
                },
                polylines: Set<Polyline>.of(polylines.values),
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

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: dotenv.env['API_KEY'],
      request: PolylineRequest(
        origin: PointLatLng(_pSource.latitude, _pSource.longitude),
        destination:
            PointLatLng(_pDestination.latitude, _pDestination.longitude),
        mode: TravelMode.driving,
      ),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      // print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }
}

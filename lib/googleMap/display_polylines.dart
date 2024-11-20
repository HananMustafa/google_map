import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_map/googleMap/direction/direction.dart';
import 'package:google_map/provider/map_providers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DisplayPolyline extends ConsumerStatefulWidget {
  final double sourceLat;
  final double sourceLong;
  final double destLat;
  final double destLong;

  const DisplayPolyline({
    super.key,
    required this.sourceLat,
    required this.sourceLong,
    required this.destLat,
    required this.destLong,
  });

  @override
  ConsumerState<DisplayPolyline> createState() => _DisplayPolylineState();
}

class _DisplayPolylineState extends ConsumerState<DisplayPolyline> {
  //To get Source LatLng & Destination LatLng from widget.
  late LatLng _pSource;
  late LatLng _pDestination;

  //for Custom Icon
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  //LatLng? station;

  //Storing static dummy data into wayPoints
  double station1Lat = 33.6136184;
  double station1Lng = 72.9960971;
  late LatLng station1 = LatLng(station1Lat, station1Lng);

  double station2Lat = 33.6115179;
  double station2Lng = 72.970696;
  late LatLng station2 = LatLng(station2Lat, station2Lng);
  //late List<PolylineWayPoint> wayPoints = [PolylineWayPoint(location: "$station1Lat, $station1Lng" ), PolylineWayPoint(location: "$station2Lat, $station2Lng")];

  


  late List<PolylineWayPoint> wayPoints = [];

  //Practice to get specific obj from json list
  //late int route1FirstStationId = route['route1']![0]['id'];
  


  @override
  initState() {
    super.initState();

    //Loop to add lat.long into wayPoints
    route['route1']?.forEach((station){
    String lat = station['lat'];
    String long = station['long'];

    wayPoints.add(PolylineWayPoint(location: "$lat, $long"));
  });
  print(wayPoints);


    //Setting Lat,Long into Source & Destination
    _pSource = LatLng(widget.sourceLat, widget.sourceLong);
    _pDestination = LatLng(widget.destLat, widget.destLong);


    //Getting coordinates & generating polyline
    getPolylinePoints()
        .then((coordinates) => generatePolyLineFromPoints(coordinates));

    //Calling function to load+display custom icon
    loadBitmap("assets/images/busstation.png", const Size(20, 20));
        
  }



  //Loading Custom Icon
  void loadBitmap(String assetPath, size){
    BitmapDescriptor.asset(
      ImageConfiguration(), 
      assetPath).then((value){
      setState(() {
        currentLocationIcon = value;
      });
    });
  }




  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: dotenv.env['API_KEY'],
      request: PolylineRequest(
        wayPoints: wayPoints,
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

      // setState(() {
      //   station = polylineCoordinates[15];
      // });
    } else {
      // print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) {
    final polyline = Polyline(
      polylineId: const PolylineId("poly"),
      color: const Color.fromRGBO(5, 185, 95, 1),
      points: polylineCoordinates,
      width: 8,
    );


    //Replaced with setState
    ref.read(polylinesProvider.notifier).state = {
      ...ref.read(polylinesProvider),
      const PolylineId("poly"): polyline,
    };
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = ref.watch(locationProvider);
    final polylines = ref.watch(polylinesProvider);

    return Scaffold(
      body: Stack(
        children: [
          currentLocation == null
              ? const Center(child: Text('Loading...'))
              : GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _pSource, zoom: 13),
                  markers: {
                    // Marker(
                    //   markerId: const MarkerId("_currentLocation"),
                    //   position: currentLocation,
                    // ),
                    Marker(
                        markerId: const MarkerId("_sourceLocation"),
                        icon: currentLocationIcon,
                        position: _pSource),
                    Marker(
                        markerId: const MarkerId("_destinationLocation"),
                        position: _pDestination),

                        
                    Marker(
                        markerId: const MarkerId("_Station1"),
                        position: station1),

                    Marker(
                        markerId: const MarkerId("_Station2"),
                        position: station2),

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



  Map<String, List<Map<String, dynamic>>> route = {
    'route1': [
      {
        "id": 17,
        "name": "Gulberg",
        "lat": "33.598455",
        "long": "73.138025",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      {
        "id": 16,
        "name": "Karal Chowk",
        "lat": "33.602624",
        "long": "73.132887",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      {
        "id": 15,
        "name": "Gangal",
        "lat": "33.612756",
        "long": "73.125603",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      {
        "id": 14,
        "name": "Fazaia",
        "lat": "33.621026",
        "long": "73.119329",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      {
        "id": 13,
        "name": "Khanna Pul",
        "lat": "33.625948",
        "long": "73.115516",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      {
        "id": 12,
        "name": "Zia Masjid",
        "lat": "33.636718",
        "long": "73.107741",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      {
        "id": 11,
        "name": "Kuri Road",
        "lat": "33.642219",
        "long": "73.103515",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      {
        "id": 10,
        "name": "Iqbal Town",
        "lat": "33.645841",
        "long": "73.100884",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      {
        "id": 9,
        "name": "Dhoke Kala Khan",
        "lat": "33.649809",
        "long": "73.097746",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      {
        "id": 8,
        "name": "Soan Highway Faizabad",
        "lat": "33.659717",
        "long": "73.090487",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      {
        "id": 7,
        "name": "I-8/Parade Ground",
        "lat": "33.673286",
        "long": "73.080213",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      {
        "id": 6,
        "name": "H-8/Shakarparia",
        "lat": "33.683992",
        "long": "73.07233",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      {
        "id": 5,
        "name": "Zero Point",
        "lat": "33.697987",
        "long": "73.061922",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      {
        "id": 4,
        "name": "Jinnah Avenue Gate#1",
        "lat": "33.705462",
        "long": "73.056209",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      {
        "id": 3,
        "name": "Centaurus",
        "lat": "33.701529",
        "long": "73.043305",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      {
        "id": 2,
        "name": "G7/G8",
        "lat": "33.705684",
        "long": "73.048322",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
    ],
    'route2': [
      {
        "id": 1,
        "name": "PIMS",
        "lat": "33.70534115775543",
        "long": "73.05075258214873",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/blue_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": true
      },
      {
        "id": 23,
        "name": "Katchery",
        "lat": "33.70242659",
        "long": "73.04200172",
        "status": "Active",
        "pictures_url":
            "https://backend-raasta-laravel.nerdflow.tech/assets/images/route/red_line/station/test.jpg",
        "arrival_time": "5-10 mins",
        "price": 50,
        "interchange_station": false
      },
      // Add the rest of the stations here
    ]
  };
}

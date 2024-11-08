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
  late LatLng _pSource;
  late LatLng _pDestination;

  LatLng? station;

  @override
  initState() {
    super.initState();
    _pSource = LatLng(widget.sourceLat, widget.sourceLong);
    _pDestination = LatLng(widget.destLat, widget.destLong);

    getPolylinePoints()
        .then((coordinates) => generatePolyLineFromPoints(coordinates));
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

      setState(() {
        station = polylineCoordinates[15];
      });
    } else {
      // print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) {
    final polyline = Polyline(
      polylineId: const PolylineId("poly"),
      color: Colors.blue,
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
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue),
                        position: _pSource),
                    Marker(
                        markerId: const MarkerId("_destinationLocation"),
                        position: _pDestination),

                        if(station != null)
                    Marker(
                        markerId: const MarkerId("_Station"),
                        position: station!),
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
                color: Color.fromRGBO(62, 75, 255, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//Provider to manage current location
final locationProvider = StateProvider<LatLng?>((ref) => null);

//Provider to manage polylines
final polylinesProvider = StateProvider<Map<PolylineId, Polyline>>((ref) => {});

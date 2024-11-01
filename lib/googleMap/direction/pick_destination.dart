import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_map/googleMap/display_polylines.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class PickDestination extends StatefulWidget {
  final double sourceLat;
  final double sourceLong;
  const PickDestination(
      {super.key, required this.sourceLat, required this.sourceLong});

  @override
  State<PickDestination> createState() => _PickDestinationState();
}

class _PickDestinationState extends State<PickDestination> {
  TextEditingController predictctrl = new TextEditingController();
  double dlat = 0;
  double dlng = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pick Destination',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(62, 75, 255, 1),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            placesAutoCompleteTextField(),
          ],
        ),
      ),
    );
  }

  placesAutoCompleteTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: predictctrl,
        textStyle: const TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
        googleAPIKey: dotenv.env["API_KEY"]!,
        inputDecoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: "Enter Destination",
        ),
        debounceTime: 400,
        countries: const ["pk"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          log(prediction.description.toString());
          ////focusNode.unfocus();
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          // sheetHeight = 25.h;
          dlat = double.parse(prediction.lat!);
          dlng = double.parse(prediction.lng!);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DisplayPolyline(
                      sourceLat: widget.sourceLat,
                      sourceLong: widget.sourceLong,
                      destLat: dlat,
                      destLong: dlng)));

          // _updateSelectedLocation(
          //     LatLng(itemlat, itemlng));
          // _getRoute();
        },
        itemClick: (Prediction prediction) {
          predictctrl.text = prediction.description ?? "";
          predictctrl.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
        },
        seperatedBuilder: const Divider(),
        containerHorizontalPadding: 10,
        // OPTIONAL// If you want to customize list view item builder
        itemBuilder: (context, index, Prediction prediction) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(
                      width: 7,
                    ),
                    Expanded(child: Text(prediction.description ?? ""))
                  ],
                ),
              ),
            ],
          );
        },
        isCrossBtnShown: true,
        // default 600 ms ,
      ),
    );
  }
}

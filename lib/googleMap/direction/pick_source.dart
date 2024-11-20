import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_map/googleMap/direction/direction.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class PickSource extends StatefulWidget {
  const PickSource({super.key});

  @override
  State<PickSource> createState() => _PickSourceState();
}

class _PickSourceState extends State<PickSource> {
  TextEditingController predictctrl = TextEditingController();
  double slat = 0;
  double slng = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pick Source',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(5, 185, 95, 1),
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
          hintText: "Enter Source",
        ),
        debounceTime: 400,
        countries: const ["pk"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          log(prediction.description.toString());
          log(prediction.lat.toString());
          ////focusNode.unfocus();
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          // sheetHeight = 25.h;
          slat = double.parse(prediction.lat!);
          slng = double.parse(prediction.lng!);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Direction(
                      sourceLat: slat,
                      sourceLong: slng,
                      sourceDescription: prediction.description.toString())));
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

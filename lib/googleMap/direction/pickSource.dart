import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_map/googleMap/direction/direction.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class pickSource extends StatefulWidget {
  const pickSource({super.key});

  @override
  State<pickSource> createState() => _pickSourceState();
}

class _pickSourceState extends State<pickSource> {
  TextEditingController predictctrl = new TextEditingController();
  double slat = 0;
  double slng = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pick Source',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(62, 75, 255, 1),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            placesAutoCompleteTextField(),
          ],
        ),
      ),
    );
  }

  placesAutoCompleteTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: predictctrl,
        textStyle: TextStyle(
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
                  builder: (context) => direction(
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

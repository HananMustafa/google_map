import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';

class predictPlaces extends StatefulWidget {
  const predictPlaces({super.key});

  @override
  State<predictPlaces> createState() => _predictPlacesState();
}

class _predictPlacesState extends State<predictPlaces> {

  TextEditingController predictctrl = new TextEditingController();
  double dlat= 0;
  double dlng=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
                                      googleAPIKey: "",
                                      inputDecoration: const InputDecoration(
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        hintText: "Destination",
                                      ),
                                      debounceTime: 400,
                                      countries: const ["pk"],
                                      isLatLngRequired: true,
                                      getPlaceDetailWithLatLng:
                                          (Prediction prediction) {
                                            log(prediction.description.toString());
                                        ////focusNode.unfocus();
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                        // sheetHeight = 25.h;
                                        dlat = double.parse(prediction.lat!);
                                        dlng = double.parse(prediction.lng!);

                                        
                                        // _updateSelectedLocation(
                                        //     LatLng(itemlat, itemlng));
                                        // _getRoute();
                                      },
                                      itemClick: (Prediction prediction) {
                                        predictctrl.text =
                                            prediction.description ?? "";
                                        predictctrl.selection =
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset: prediction
                                                            .description
                                                            ?.length ??
                                                        0));
                                      },
                                      seperatedBuilder: const Divider(),
                                      containerHorizontalPadding: 10,
                                      // OPTIONAL// If you want to customize list view item builder
                                      itemBuilder: (context, index,
                                          Prediction prediction) {
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
                                                  Expanded(
                                                      child: Text(prediction
                                                              .description ??
                                                          ""))
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
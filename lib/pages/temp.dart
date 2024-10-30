  // placesAutoCompleteTextField(
  //                                     textEditingController: predictctrl,
  //                                     textStyle: TextStyle(
  //                                       fontSize: 15.sp,
  //                                       color: black,
  //                                     ),
  //                                     googleAPIKey: "AIzaSyDd_DAaGN6XCBtM0KPjYn1AZjhU9c2KzC4",
  //                                     inputDecoration: const InputDecoration(
  //                                       border: InputBorder.none,
  //                                       enabledBorder: InputBorder.none,
  //                                       hintText: "Destination",
  //                                     ),
  //                                     debounceTime: 400,
  //                                     countries: const ["pk"],
  //                                     isLatLngRequired: true,
  //                                     getPlaceDetailWithLatLng:
  //                                         (Prediction prediction) {
  //                                       focusNode.unfocus();
  //                                       SystemChannels.textInput
  //                                           .invokeMethod('TextInput.hide');
  //                                       // sheetHeight = 25.h;
  //                                       dlat = double.parse(prediction.lat!);
  //                                       dlng = double.parse(prediction.lng!);
  //                                       // _updateSelectedLocation(
  //                                       //     LatLng(itemlat, itemlng));
  //                                       // _getRoute();
  //                                     },
  //                                     itemClick: (Prediction prediction) {
  //                                       dcontroller.text =
  //                                           prediction.description ?? "";
  //                                       dcontroller.selection =
  //                                           TextSelection.fromPosition(
  //                                               TextPosition(
  //                                                   offset: prediction
  //                                                           .description
  //                                                           ?.length ??
  //                                                       0));
  //                                     },
  //                                     seperatedBuilder: const Divider(),
  //                                     containerHorizontalPadding: 10,
  //                                     // OPTIONAL// If you want to customize list view item builder
  //                                     itemBuilder: (context, index,
  //                                         Prediction prediction) {
  //                                       return Column(
  //                                         children: [
  //                                           Container(
  //                                             padding: const EdgeInsets.all(10),
  //                                             child: Row(
  //                                               children: [
  //                                                 const Icon(Icons.location_on),
  //                                                 const SizedBox(
  //                                                   width: 7,
  //                                                 ),
  //                                                 Expanded(
  //                                                     child: Text(prediction
  //                                                             .description ??
  //                                                         ""))
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       );
  //                                     },
  //                                     isCrossBtnShown: true,
  //                                     // default 600 ms ,
  //                                   ),
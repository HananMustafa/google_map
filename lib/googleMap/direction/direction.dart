import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map/googleMap/direction/pickDestination.dart';
import 'package:google_map/googleMap/direction/pickSource.dart';

class direction extends StatefulWidget {
  final double sourceLat;
  final double sourceLong;
  final String sourceDescription;

  const direction(
      {super.key,
      required this.sourceLat,
      required this.sourceLong,
      required this.sourceDescription});

  @override
  State<direction> createState() => _directionState();
}

class _directionState extends State<direction> {
  TextEditingController sourceCTRL = new TextEditingController();
  TextEditingController destinationCTRL = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 140,
          backgroundColor: Color.fromRGBO(62, 75, 255, 1),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Column(
            children: [
              //SOURCE
              Container(
                // alignment: Alignment.center,
                height: 40,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => pickSource()));
                  },
                  child: TextField(
                    controller: sourceCTRL,
                    enabled: false,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      hintText: widget.sourceDescription,
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: GoogleFonts.merriweatherSans(
                        fontSize: 14,
                        color: Color.fromRGBO(62, 75, 255, 1),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(62, 75, 255, 1),
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              Color.fromRGBO(255, 107, 0, 1).withOpacity(0.5),
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //DESTINATION
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 40,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => pickDestination(
                                sourceLat: widget.sourceLat,
                                sourceLong: widget.sourceLong)));
                  },
                  child: TextField(
                    // controller: sourceCTRL,
                    enabled: false,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      hintText: 'Choose destination',
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: GoogleFonts.merriweatherSans(
                        fontSize: 14,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(62, 75, 255, 1),
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              Color.fromRGBO(255, 107, 0, 1).withOpacity(0.5),
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

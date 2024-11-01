import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map/googleMap/direction/pick_destination.dart';
import 'package:google_map/googleMap/direction/pick_source.dart';

class Direction extends StatefulWidget {
  final double sourceLat;
  final double sourceLong;
  final String sourceDescription;

  const Direction(
      {super.key,
      required this.sourceLat,
      required this.sourceLong,
      required this.sourceDescription});

  @override
  State<Direction> createState() => _DirectionState();
}

class _DirectionState extends State<Direction> {
  TextEditingController sourceCTRL = TextEditingController();
  TextEditingController destinationCTRL = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 140,
          backgroundColor: const Color.fromRGBO(62, 75, 255, 1),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: Column(
            children: [
              //SOURCE
              SizedBox(
                // alignment: Alignment.center,
                height: 40,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const PickSource()));
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
                        color: const Color.fromRGBO(62, 75, 255, 1),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
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
                              const Color.fromRGBO(255, 107, 0, 1).withOpacity(0.5),
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //DESTINATION
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 40,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PickDestination(
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
                          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
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
                              const Color.fromRGBO(255, 107, 0, 1).withOpacity(0.5),
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class direction extends StatefulWidget {
  const direction({super.key});

  @override
  State<direction> createState() => _directionState();
}

class _directionState extends State<direction> {
  TextEditingController sourceCTRL = new TextEditingController();
  TextEditingController destinationCTRL = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        //SOURCE
        Container(
          margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
          alignment: Alignment.topLeft,
          child: TextField(
            controller: sourceCTRL,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 107, 0, 1),
                  width: 2.0,
                ),
              ),
              hintText: 'Choose source',
              hintStyle: GoogleFonts.merriweatherSans(fontSize: 10),
              isCollapsed: true,
              contentPadding: const EdgeInsets.all(5),
            ),
          ),
        ),

        //DESTINATION
        Container(
          margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
          alignment: Alignment.topLeft,
          child: TextField(
            controller: destinationCTRL,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 107, 0, 1),
                  width: 2.0,
                ),
              ),
              hintText: 'Choose destination',
              hintStyle: GoogleFonts.merriweatherSans(fontSize: 10),
              isCollapsed: true,
              contentPadding: const EdgeInsets.all(5),
            ),
          ),
        ),
      ],
    ));
  }
}

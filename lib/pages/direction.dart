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

            appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 77, 47, 1),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Container(
          height: 40,
          child: TextField(
            // controller: searchthisctrl,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              hintText: 'Search tour',
              filled: true,
              fillColor: Colors.white,
              hintStyle: GoogleFonts.merriweatherSans(
                fontSize: 14,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 107, 0, 1),
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(255, 107, 0, 1).withOpacity(0.5),
                  width: 0.5,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                },
              ),
            ),
          ),
        ),
      ),






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

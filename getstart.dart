import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login.dart';

class getStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F0EB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 675,
              //color: Colors.pinkAccent.shade100,
              child: Image.asset("assets/cakelogo.png"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF16A6A),
                  shape: StadiumBorder(),
                  elevation: 10,
                  minimumSize: Size(200, 50)),
              child: Text(
                "Get Start Here",
                style: GoogleFonts.titilliumWeb(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:Color(0xFFF9F0EB),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
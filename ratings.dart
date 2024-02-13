import 'package:cake_shopp/common.dart';
import 'package:cake_shopp/home.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class Ratings extends StatefulWidget {
  const Ratings({super.key});

  @override
  State<Ratings> createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  // Initial Selected Value
  int dropdownvalue = 1;

  // List of items in our dropdown menu
  var items = [1, 2, 3, 4, 5,];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F0EB),
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 56),
              child: Text(
                "Rating",
                style: GoogleFonts.titilliumWeb(
                    textStyle: TextStyle(
                        color: Color(0xFF644734),
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 67),
              child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/cakelogo_mini.png"),
                      ),
                      borderRadius: BorderRadius.circular(35))),
            )
          ],
        ),
        backgroundColor: Color(0xFFF1BDB0),
        centerTitle: true,

      ),
      drawer: MyDrawer(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                //color: Colors.pinkAccent.shade100,
                child: Image.asset("assets/cakelogo.png"),
              ),
              Padding(
                padding:  EdgeInsets.only(top: 10),
                child: DropdownButton(

                  // Initial Value
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: items.map((int items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Container(
                          height: 30,
                          width: 200,
                          color: Color(0xFFF1BDB0),
                          child: Center(child: Text("Rate $items"))),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (int? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });

                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF16A6A),
                      shape: StadiumBorder(),
                      elevation: 10,
                      minimumSize: Size(230, 40)),
                  child: Text(
                    "Submit",
                    style: GoogleFonts.titilliumWeb(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:Color(0xFFF9F0EB),
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

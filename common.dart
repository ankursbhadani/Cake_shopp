
import 'package:provider/provider.dart';

import 'aboutus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cake_shopp/cake_list.dart';
import 'package:cake_shopp/cake_menu.dart';
import 'package:cake_shopp/cart.dart';
import 'package:cake_shopp/home.dart';
import 'package:cake_shopp/login.dart';
import 'package:cake_shopp/privecy_policy.dart';
import 'package:cake_shopp/user_detail.dart';
import 'package:cake_shopp/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'checkuser.dart';
import 'connection.dart';
PreferredSizeWidget? MyAppBar(){
  return AppBar(
    title: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 100),
          child: Text(
            "Home",
            style: GoogleFonts.titilliumWeb(
                textStyle: TextStyle(
                    color: Color(0xFF644734),
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 55),
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

  );
}
void toast(message) {
  Fluttertoast.showToast(
      msg: message,
      fontSize: 20,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Color(0xff214F94),
      textColor: Color(0xffF6B818));
}
class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getProducts();
  }
MyNetworkRequest request = MyNetworkRequest();
dynamic response = [{"id":"15","title":"Rich Chocolate Photo Cake","price":"1025","photo":"assets\/chocolate.jpeg","detail":"Cake Flavour- Chocolate (Eggless), Weight- Half Kg, Type of Cake - Cream, Shape- Round"},{"id":"16","title":"Round Black Forest Photo Cake","price":"1250","photo":"assets\/Blackforest.jpg","detail":"Cake Flavour- Black Forest, Type of Cake- Cream, Weight- 1 Kg\r\nShape- Round, Serves- 10-12 People"}]as List;

getProducts() async {
  String url = 'product.php';
  response = await request.SendRequest(url,'get');
  setState(() {
    response.removeAt(0);
    response.removeAt(0);
  });
  print("This Is Comomon Response..$response");

}
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Color(0xFFF9F0EB),
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                  child: Text(
                    'Welcome To \n Sweet Cake!',
                    style: GoogleFonts.titilliumWeb(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF644734)),
                  )),
              decoration: BoxDecoration(color: Color(0xFFF1BDB0)),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
              },
            ),
            ListTile(
              title: Text('Cake Menu'),
              onTap: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CackeMenu()));
              },
            ),
            ListTile(
              title: Text('Most Populer Cake'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Cakes(category: response[11],)));
              },
            ),
            ListTile(
              title: Text('Privecy Policy'),
              onTap: () {
                Navigator.of(context).push(PageTransition(
                    child: PrivecyPolicy(),
                    type: PageTransitionType.leftToRight));
              },
            ),
            ListTile(
              title: Text('About Us'),
              onTap: () {
                Navigator.of(context).push(PageTransition(child: AboutUs(), type: PageTransitionType.leftToRight));
              },
            ),
            ListTile(
              title: Text('LogOut'),
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).logoutUser();
              },
            ),
          ],
        )
    );
  }
}

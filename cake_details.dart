import 'package:cake_shopp/cart.dart';
import 'package:cake_shopp/chakout.dart';
import 'package:cake_shopp/common.dart';
import 'package:cake_shopp/connection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'ratings.dart';
import 'wishlist.dart';
import 'botomappbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class CakeDetail extends StatefulWidget {
  int product_id=0;
   CakeDetail(productId, {super.key}){
    product_id=productId;
    print("This is Product Detail productId $productId");
  }

  @override
  State<CakeDetail> createState() => _CakeDetailState(product_id);
}

class _CakeDetailState extends State<CakeDetail> {
  MyNetworkRequest request = MyNetworkRequest();
  FlutterSecureStorage storage =FlutterSecureStorage();
  var response= [ { 'photo' : '' , 'title' : '' , 'price' : '' , 'detail' : '' } ] as List;
  int pageIndex = 0;
  Color selectedColor = Colors.red;
  Color unselectedColor = Colors.white;
  late Color currentColor;
  bool _selected = false;
  int count=1;
  int productId=0;
  _CakeDetailState(int product_id){
    productId=product_id;
  }
  getProductDetail() async {
    String url = 'product.php?productid=${productId}';
    response = await request.SendRequest(url,"get");
    setState(() {
      response.removeAt(0);
      response.removeAt(0);
    });
    print(response);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentColor = unselectedColor;
    getProductDetail();

  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getProductDetail();
  }

  void changeColor() {
    setState(() {
      currentColor =
      currentColor == selectedColor ? unselectedColor : selectedColor;
    });
  }
  addTocart() async {
    String? userid = await storage.read(key: 'userid');
    print("this is user id $userid");
    String url = 'add_to_cart.php?usersid=${userid}&productid=${productId}';
    var response_cart = await request.SendRequest(url,'get');
    setState(() {
      response_cart.removeAt(0);
    });
    toast(response_cart[0]['message'].toString());
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Cart()));
  }
  addToWishlist() async {
    String? userid = await storage.read(key: 'userid');
    print("this is userid " + userid.toString());
    String url = 'add_to_wishlist.php?usersid=${userid}&productid=${productId}';
    var response_wishlist = await request.SendRequest(url,"get");
    setState(() {
      response_wishlist.removeAt(0);
    });
    toast(response_wishlist[0]['message'].toString());
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Wishlist()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F0EB),
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 45),
              child: Text(
                "Cake Detail",
                style: GoogleFonts.titilliumWeb(
                    textStyle: TextStyle(
                        color: Color(0xFF644734),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 80),
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
      bottomNavigationBar: BottomBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  height: 300,
                  width: 300,
                  child: PageView(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(response[0]['photo'].toString()),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(20)),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: IconButton(
                                icon: Icon(Icons.favorite_border_outlined,
                                    size: 35, color: currentColor),
                                onPressed: () {
                                  changeColor();
                                  addToWishlist();
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Wishlist()));
                                },
                              ),
                            )),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(response[0]['photo'].toString()),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(20))),
                      Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(response[0]['photo'].toString()),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(20))),
                    ],
                    onPageChanged: (index) {
                      setState(() {
                        pageIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CarouselIndicator(
              color: Color(0xFFF16A6A),
              activeColor: Color(0xFFF1BDB0),
              count: 3,
              index: pageIndex,
            ),
            ListTile(
              title: Text(
                response[0]['title'].toString(),
                style: GoogleFonts.titilliumWeb(
                    textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF644734))),
              ),
              subtitle: Text(
                response[0]['detail'].toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.titilliumWeb(fontSize: 13),
              ),
              trailing: Column(
                children: [
                  SizedBox(
                    height: 30,
                    width: 150,
                    child: Container(
                      height: 30,
                      width: 150,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 30,
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Ratings()));
                      },
                      child: Text("Give your Rating",style: GoogleFonts.titilliumWeb(fontSize: 15,color: Color(0xFF644734)),)),
                ],
              ),
            ),
            ListTile(
              title: Container(
                height: 35,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Center(
                          child: InkWell(
                            onTap: (){
                              count--;
                              setState(() {
                                count;
                              });
                            },
                            child: Icon(
                              Icons.remove_circle_outline,
                              size: 30,
                            ),
                          )),
                    ),
                    Text(
                      "$count",
                      style: GoogleFonts.titilliumWeb(
                          textStyle: TextStyle(
                              fontSize: 25, color: Color(0xFF644734))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Center(
                          child: InkWell(
                            onTap: (){
                              count++;
                              print("$count");
                              setState(() {
                                count;
                              });
                            },
                            child: Icon(
                              Icons.add_circle_outline,
                              size: 30,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              trailing: Padding(
                padding: EdgeInsets.only(left: 110, top: 10),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Text(
                    "₹"+response[0]['price'].toString(),
                    style: GoogleFonts.titilliumWeb(
                        textStyle: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                "About Cake",
                style: GoogleFonts.titilliumWeb(
                    textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF644734))),
              ),
              subtitle: Text(
                  response[0]['detail'].toString()),
            ),
            Container(
              height: 100,
              width: 400,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        addTocart();
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Cart()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF16A6A),
                          shape: StadiumBorder(),
                          elevation: 5,
                          minimumSize: Size(180, 40)),
                      child: Text(
                        "Add To Cart",
                        style: GoogleFonts.titilliumWeb(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF9F0EB),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Checkout(totalAmount:response[0]['price'],)));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF16A6A),
                        shape: StadiumBorder(),
                        elevation: 5,
                        minimumSize: Size(180, 40)),
                    child: Text(
                      "Buy Now",
                      style: GoogleFonts.titilliumWeb(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF9F0EB),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

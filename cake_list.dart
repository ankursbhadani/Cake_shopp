import 'package:cake_shopp/cake_details.dart';
import 'package:cake_shopp/cart.dart';
import 'package:cake_shopp/common.dart';
import 'package:cake_shopp/connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'botomappbar.dart';

class Cakes extends StatefulWidget {
  int response_id = 0;
  final Map<String, dynamic> category;

  Cakes({Key? key, required this.category}) {
    response_id = int.parse(category['id'].toString());
    print(response_id);
  }

  @override
  State<Cakes> createState() => _CakesState(response_id);
}

class _CakesState extends State<Cakes> {
  var response = [
    {'title': '', 'photo': '', 'price': '', 'detail': ''}
  ] as List;
  int responseId = 0;

  _CakesState(int response_id) {
    responseId = response_id;
  }

  MyNetworkRequest request = MyNetworkRequest();
  FlutterSecureStorage storage = FlutterSecureStorage();

  getProduct() async {
    String url = 'product.php?categoryid=${responseId}';
    response = await request.SendRequest(url, 'get');
    setState(() {
      response.removeAt(0);
      response.removeAt(0);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getProduct();
  }
  addTocart(dynamic product) async {
    int productId = int.parse(product['id'].toString());
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

  @override
  Widget build(BuildContext context) {
    print("this is selected category detail ");
    return Scaffold(
      backgroundColor: Color(0xFFF9F0EB),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 70),
              child: Text(
                "Cakes",
                style: GoogleFonts.titilliumWeb(
                    textStyle: TextStyle(
                        color: Color(0xFF644734),
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 90),
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
      body: Container(
        height: 700,
        child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: ListView.builder(
              itemCount: response.length,
              itemBuilder: (context, index) {
                return PopularCake(response[index]);
              }),
        ),
      ),
    );
  }

  Widget PopularCake(response) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                CakeDetail(int.parse(response['id'].toString()))));
      },
      child: ListTile(
        title: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFFFFFFFF),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: AssetImage(response['photo'].toString()),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 6.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        response['title'].toString(),
                        style: GoogleFonts.titilliumWeb(
                            textStyle: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF644734)),
                            height: 1),
                      ),
                      Text(
                        response['detail'].toString(),
                        style: GoogleFonts.titilliumWeb(
                            textStyle: TextStyle(
                                height: 1.0,
                                fontSize: 15,
                                color: Colors.black38)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        "\u{20B9}" + response['price'].toString(),
                        style: GoogleFonts.titilliumWeb(
                            textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 40, right: 10),
                child: InkWell(
                    onTap: () {
                      addTocart(response);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Cart()));
                    },
                    child: Image.asset(
                      "assets/addtocart.png",
                      height: 35,
                      width: 35,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

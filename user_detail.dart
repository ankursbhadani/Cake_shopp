import 'package:cake_shopp/edit_user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'common.dart';
import 'connection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserDetail extends StatefulWidget {
  UserDetail({super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  MyNetworkRequest request = MyNetworkRequest();

  FlutterSecureStorage storage = FlutterSecureStorage();

  var response = [
    {'title': ' '}
  ] as List;
  var response_order = [
    {'title': ' '}
  ] as List;
  List<Map<String, dynamic>> response_product = [];

  getUserdetail() async {
    String? userId = await storage.read(key: 'userid');
    String url = "users.php?usersid=${userId}";
    response = await request.SendRequest(url, "get");
    print("this is user response ${response}");
    setState(() {
      response.removeAt(0);
      response.removeAt(0);
    });
  }

  getOrderdetail() async {
    String? userId = await storage.read(key: 'userid');
    String url = "orders.php?usersid=${userId}";
    response_order = await request.SendRequest(url, "get");

    setState(() {
      response_order.removeAt(0);
      response_order.removeAt(0);
    });
    print("this is order response ${response_order}");
  }

  getItem() async {
    print("get item order value ${response_order}");
    for (var order in response_order) {
      if (order.containsKey('product_id') && order.containsKey('cart_id')) {
        String productId = order['product_id'].toString();
        String? userId = await storage.read(key: 'userid');
        String url = "product.php?productid=${productId}";
        dynamic productResponse = await request.SendRequest(url, "get");

        print("Product Response for product ID $productId: $productResponse");

        if (productResponse is List && productResponse.isNotEmpty) {
          List<Map<String, dynamic>> productDetailsList =
          List<Map<String, dynamic>>.from(productResponse);

          setState(() {
            response_product.addAll(productDetailsList);
          });
        } else if (productResponse is Map<String, dynamic>) {
          setState(() {
            response_product.add(productResponse);
          });
        } else {
          print(
              "Product response is not in the expected format for product ID $productId.");
        }
      } else {
        print("Product ID or cart ID not found in the order details.");
      }
    }

    // Remove elements with '{error: no}' or '{total: 1}' from the response_product list
    response_product.removeWhere((element) =>
    element.containsKey('error') && element['error'] == 'no' ||
        element.containsKey('total') && element['total'] == 1);

    setState(() {
      // response_product.removeAt(0); // Remove if you still need to remove the first element
    });
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserdetail();
    getOrderdetailAndItem();
  }
  getOrderdetailAndItem() async {
    await getOrderdetail();
    getItem();
  }

  @override
  Widget build(BuildContext context) {

    print("this is final response of product ${response_product}");
    //print("this photo url "+response_product[2]['photo'].toString());

    return Scaffold(
      backgroundColor: Color(0xFFF9F0EB),
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Text(
                "User Account",
                style: GoogleFonts.titilliumWeb(
                    textStyle: TextStyle(
                        color: Color(0xFF644734),
                        fontSize: 25,
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 300, top: 20),
                child: CircleAvatar(
                  backgroundColor: Color(0xFFF1BDB0),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditUser(data: response)));
                      },
                      child: Icon(
                        Icons.edit,
                        color: Color(0xFFF16A6A),
                      )),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Container(
                    height: 200,
                    //color: Colors.pinkAccent.shade100,
                    child: Image(image: AssetImage("assets/man.png")),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 10),
                child: Align(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFF1BDB0),
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(response[0]['name'].toString(),
                          style: GoogleFonts.titilliumWeb(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF644734)))),
                    ),
                    width: 350,
                    height: 35,
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 10),
                child: Align(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFF1BDB0),
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(response[0]['mobile'].toString(),
                          style: GoogleFonts.titilliumWeb(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF644734)))),
                    ),
                    width: 350,
                    height: 35,
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 10),
                child: Align(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFF1BDB0),
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(response[0]['email'].toString(),
                          style: GoogleFonts.titilliumWeb(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF644734)))),
                    ),
                    width: 350,
                    height: 35,
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 12.0, bottom: 12, right: 220),
                child: Text(
                  "Privious Orders",
                  style: GoogleFonts.titilliumWeb(
                    textStyle: TextStyle(fontSize: 20),
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF644734),
                  ),
                ),
              ),
              Container(
                height: 260,
                child: ListView.builder(
                    itemCount: response_order.length,
                    itemBuilder: (context, index) {
                      return PopularCake(response_order, index);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget PopularCake(dynamic response_order, int index) {
    if (index < response_product.length) {
      return ListTile(
        title: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFFFFFFFF),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Center(
                  child: Image.asset(
                    response_product[index]['photo'].toString(),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 17.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 180,
                      child: Text(
                        response_product[index]['title'].toString(),
                        style: GoogleFonts.titilliumWeb(textStyle: TextStyle(fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF644734),height: 1.0),
                        ),
                        maxLines: 2,
                      ),
                    ),
                    Text(
                      "Order Date: " +
                          response_order[index]['billdate'].toString(),
                      style: GoogleFonts.titilliumWeb(
                        textStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "₹" + response_order[index]['amount'].toString(),
                        style: GoogleFonts.titilliumWeb(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(); // If the response_product doesn't have enough data to match the index, return an empty SizedBox
    }
  }

}

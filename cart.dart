import 'package:cake_shopp/chakout.dart';
import 'package:cake_shopp/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'botomappbar.dart';
import 'connection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int count=0;
  bool Empty = true;
  double total =0;
  MyNetworkRequest request = MyNetworkRequest();
  FlutterSecureStorage storage = FlutterSecureStorage();
  var response = [{'title': ' '}] as List;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItem();
  }
  getItem() async {
    String? userId = await storage.read(key: 'userid');
    String url = 'cart.php?usersid=${userId}';
    print(url);
    response= await request.SendRequest(url,'get');
    print("this is cart response ${response} ");
    setState(() {
      response.removeAt(0);
    });
    if(response[0]['total']==0){
      toast("your cart is Empty");
      Empty = true;
      total=0;
    }else{
      Empty=false;
      setState(() {
        response.removeAt(0);
      });
      print(response);
      dynamic value =0;
      for(value in response){
        print(value);
        total=total+(int.parse(value['price'].toString()) *
            int.parse(value['quantity'].toString()));
        print("this is total ${total}");
      }
    }
  }
  addQuantity(cartid) async {
    // Increment the quantity before making the API call
    String url = 'add_quantity.php?cartid=${cartid}';
    var remove_resopnse = await request.SendRequest(url,"get");
    print("this is remove to cart response $remove_resopnse");
    setState(() {

    });

  }


  removeQuantity(cartid) async {
    String url = 'remove_quantity.php?cartid=${cartid}';
    var remove_resopnse = await request.SendRequest(url,"get");
    print("this is remove to cart response $remove_resopnse");
    setState(() {

    });
  }

  removeFromCart(cartid) async {
    String url = 'delete_from_cart.php?cartid=${cartid}';
    var removecart_response = await request.SendRequest(url,"get");
    print("this is delete from cart response $removecart_response");
    setState(() {
      response.removeWhere((item) => item['cartid'] == cartid);
      if(response.isEmpty){
        Empty=true;
        total=0;
      }

    });
  }

  Widget EmptyCartView() {
    return Container(
      child: Center(
        child: Text(
          "You Cart is Empty ",
          style: GoogleFonts.titilliumWeb(
            textStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
  Widget cartView(response){
    return SingleChildScrollView(
      child: Container(
        height: 900,
        child: ListView.builder(itemBuilder: (context, index){
          return CartCake(response[index]);
        },itemCount: response.length,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFF9F0EB),
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 90),
              child: Text(
                "Cart",
                style: GoogleFonts.titilliumWeb(
                    textStyle: TextStyle(
                        color: Color(0xFF644734),
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 85),
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
      bottomSheet: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0,bottom: 8,right: 8,left: 20),
            child: Text("Total  ₹${total}",style: GoogleFonts.titilliumWeb(textStyle: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.red)),),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0,right: 6),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Checkout(totalAmount:total)));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF16A6A),
                  shape:BeveledRectangleBorder(),
                  elevation: 10,
                  minimumSize: Size(180, 40)),
              child: Text(
                "Place Order",
                style: GoogleFonts.titilliumWeb(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:Color(0xFFF9F0EB),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body:Empty == false ? cartView(response) : EmptyCartView(),
    );
  }
  Widget CartCake(response){
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Center(
                  child: Image.asset(
                    response['photo'].toString(),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 5.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width:120,
                    child: Text(
                      response['title'],
                      style: GoogleFonts.titilliumWeb(textStyle: TextStyle(fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF644734),
                          overflow:TextOverflow.ellipsis,
                        height: 1.0,
                      ),
                      ),
                        maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 120,
                    child: Text(
                      response['detail'],
                      style: GoogleFonts.titilliumWeb(
                          textStyle: TextStyle(
                              fontSize: 15, color: Colors.black38,
                            height: 1.0,
                          ),
                      ),
                        overflow:TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                  Text("₹"+response['price'].toString(),style: GoogleFonts.titilliumWeb(textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red)),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70.0,),
              child: Container(
                height: 30,
                width: 95,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Center(
                          child: InkWell(
                            onTap: (){
                                  if((int.parse(response['quantity'].toString()))<=1){

                                    setState(() {
                                      removeFromCart(response['cartid'].toString());
                                      total=0;

                                    });
                                  }else{
                                    removeQuantity(response['cartid']);
                                    setState(() {
                                      response['quantity']= (int.parse(response['quantity'])-1).toString();
                                      total = double.parse(total.toString()) -
                                          double.parse(response['price'].toString());
                                    });
                                  }

                            },
                            child: Icon(
                              Icons.remove_circle_outline,
                              size: 27,
                            ),
                          )),
                    ),
                    Text(
                      response['quantity'].toString(),
                      style: GoogleFonts.titilliumWeb(
                          textStyle: TextStyle(
                              fontSize: 20, color: Color(0xFF644734))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Center(
                          child: InkWell(
                            onTap: (){
                              addQuantity(response["cartid"]);
                              setState(() {
                                response['quantity']= (int.parse(response['quantity'])+1).toString();
                                total = double.parse(total.toString()) +
                                    double.parse(response['price'].toString());
                              });
                            },
                            child: Icon(
                              Icons.add_circle_outline,
                              size: 27,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

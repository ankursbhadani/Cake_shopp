import 'package:cake_shopp/common.dart';
import 'package:cake_shopp/connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'botomappbar.dart';
class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItem();
  }
  MyNetworkRequest request = MyNetworkRequest();
  FlutterSecureStorage storage = FlutterSecureStorage();
  var response = [{'title': ' '}] as List;
  bool Empty = true;
  double total =0;

  getItem() async {
    String? userId = await storage.read(key: 'userid');
    String url = 'wishlist.php?usersid=${userId}';
    print(url);
    response= await request.SendRequest(url,'get');
    print("this is response of initial state ${response}");
    setState(() {
      response.removeAt(0);
    });
    if(response[0]['total']==0){
      toast("your Wishlist is Empty");
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

  Widget wishlistView(response){
    return SingleChildScrollView(
      child: Container(
        height: 900,
        child: ListView.builder(itemBuilder: (context, index){
          return CartCake(response[index]);
        },itemCount: response.length,),
      ),
    );
  }
Widget EmptyWishlistView() {
  return Container(
    child: Center(
      child: Text(
        " Wishlist is Empty ",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F0EB),
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 66),
              child: Text(
                "Wishlist",
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
      bottomNavigationBar: BottomBar(),

      body:Empty == false ? wishlistView(response) : EmptyWishlistView(),
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
                top: 17.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width:150,
                    child: Text(
                      response['title'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.titilliumWeb(textStyle: TextStyle( fontSize: 17,
                          height: 1.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF644734)),),

                    ),
                  ),
                  Container(
                    width:140,
                    child: Text(
                      response['detail'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.titilliumWeb(
                          textStyle: TextStyle(
                            height: 1.0,
                              fontSize: 15, color: Colors.black38)),
                    ),
                  ),
                  Text("₹"+ response['price'].toString(),style: GoogleFonts.titilliumWeb(textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red)),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Center(
                        child: InkWell(
                          onTap: (){
                            print("this is wishlist response id   "+ response['id'] );
                            setState(() {
                              removeFromwishlist(response);
                            });
                          },
                          child: Icon(
                            Icons.remove_circle_outline,
                            size: 27,color: Colors.redAccent,
                          ),
                        )),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  removeFromwishlist(dynamic responseItem) async {
      print("this is responde of wishlist  ${responseItem}");
     String url = "delete_from_wishlist.php?wishlistid=${responseItem['id'].toString()}";
     var remove_from_wishlist = await request.SendRequest(url,'get');
     if(remove_from_wishlist != null){
       setState(() {
         // Remove the item from the local response list
         response.removeWhere((item) => item['id'] == responseItem['id']);
         // Check if the wishlist is empty after removal
         Empty = response.isEmpty;
       });
     }

  }
}

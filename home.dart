import 'package:cake_shopp/cake_details.dart';
import 'package:cake_shopp/cake_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'cake_menu.dart';
import 'package:cake_shopp/cart.dart';
import 'package:cake_shopp/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'privecy_policy.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'botomappbar.dart';
import 'connection.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  MyNetworkRequest request = MyNetworkRequest();
  dynamic response = [{"id":"11","title":"BIRTHDAY","photo":"assets\/Birthdaycake_category.jpeg","islive":"1","isdeleted":"0"},{"id":"12","title":"ANNIVERSERY","photo":"assets\/Anniverserycake_category.jpeg","islive":"1","isdeleted":"0"},{"id":"13","title":"COOKIE","photo":"assets\/cookiecake_category.jpeg","islive":"1","isdeleted":"0"},{"id":"14","title":"PHOTO","photo":"assets\/photocake_category.jpg","islive":"1","isdeleted":"0"},{"id":"15","title":"CUPCAKE","photo":"assets\/cupcake_category.jpeg","islive":"1","isdeleted":"0"},{"id":"16","title":"Festival","photo":"assets\/festivalcake_category.jpeg","islive":"1","isdeleted":"0"},{"id":"17","title":"FRESH_FRIUTS","photo":"assets\/fruitcake_category.jpg","islive":"1","isdeleted":"0"},{"id":"18","title":"KIDS","photo":"assets\/kidscake_category.jpg","islive":"1","isdeleted":"0"}];
  dynamic response_product = [{"id":"15","title":"Rich Chocolate Photo Cake","price":"1025","photo":"assets\/chocolate.jpeg","detail":"Cake Flavour- Chocolate (Eggless), Weight- Half Kg, Type of Cake - Cream, Shape- Round"},{"id":"16","title":"Round Black Forest Photo Cake","price":"1250","photo":"assets\/Blackforest.jpg","detail":"Cake Flavour- Black Forest, Type of Cake- Cream, Weight- 1 Kg\r\nShape- Round, Serves- 10-12 People"}] as List;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getCategory();
    getProducts();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
    getProducts();
  }
getCategory() async {
    String url = 'category.php';
    response = await request.SendRequest(url,'get');
    setState(() {
      response.removeAt(0);
      response.removeAt(0);
    });
    print("This Is category Response..$response");

  }
  getProducts()async{
    String url ='product.php';
    response_product = await request.SendRequest(url,'get');
    setState(() {
      response_product.removeAt(0);
      response_product.removeAt(0);
    });
    print("This is Product Response...$response_product");
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
    return Scaffold(
      backgroundColor: Color(0xFFF9F0EB),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: ListTile(
                title: Text(
                  "Welcome!",
                  style: GoogleFonts.titilliumWeb(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF644734)),
                ),
                subtitle: Text("Most delisius cakes are here"),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 320.0,
                autoPlay: true,
                autoPlayAnimationDuration: Duration(milliseconds: 600),
                autoPlayInterval: Duration(seconds: 3),
                autoPlayCurve: Curves.easeOut,
              ),
              items: response.map<Widget>(
                    (item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return InkWell(
                        onTap: (){

                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Cakes(category:item),),);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 500,
                            width: 500,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: AssetImage(item['photo'].toString()),
                                    fit: BoxFit.cover),),
                            child: Align(
                              child: Text(
                                item['title'],
                                style: GoogleFonts.titilliumWeb(
                                    textStyle: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF644734))),
                              ),
                              alignment: Alignment.bottomCenter,
                            ),

                          ),
                        ),
                      );

                    },
                  );

                },

              ).toList(),
            ),
            Container(
              height: 320,
              width: double.infinity,
              //color: Colors.lime,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                    child: Text(
                      "Most Populler Cakes",
                      style: GoogleFonts.titilliumWeb(
                          textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF644734))),
                    ),
                  ),
                  Container(
                    height: 260,

                    child: ListView.builder(itemCount: response_product.length,itemBuilder: (context,index){
                      return PopularCake(response_product[index]);
                    }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
  Widget PopularCake(response_product){
    return ListTile(
      title: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CakeDetail(int.parse(response_product['id'].toString()))));
        },
        child: Container(
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
                            image: AssetImage(response_product['photo'].toString()),
                            fit: BoxFit.cover),),
                    )),
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
                        response_product['title'].toString(),
                        style: GoogleFonts.titilliumWeb(textStyle: TextStyle(
                          height: 1,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF644734)),),

                      ),
                      Text(
                        response_product['detail'].toString(),
                        style: GoogleFonts.titilliumWeb(
                            textStyle: TextStyle(
                              height: 1,
                                fontSize: 15, color: Colors.black38)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text("\u{20B9}"+response_product['price'].toString(),style: GoogleFonts.titilliumWeb(textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red)),),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,top: 40,right: 10),
                child: InkWell(
                    onTap: (){
                      addTocart(response_product);
                      print("this is popular cake id" +response_product['id'].toString());
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Cart()));
                    },
                    child: Image.asset("assets/addtocart.png",height: 35,width: 35,)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cake_shopp/cake_list.dart';
import 'package:cake_shopp/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'botomappbar.dart';
import 'connection.dart';
class CackeMenu extends StatefulWidget {
  const CackeMenu({super.key});

  @override
  State<CackeMenu> createState() => _CackeMenuState();
}

class _CackeMenuState extends State<CackeMenu> {

  dynamic response =[{"id":"11","title":"BIRTHDAY","photo":"assets\/Birthdaycake_category.jpeg","islive":"1","isdeleted":"0"},{"id":"12","title":"ANNIVERSERY","photo":"assets\/Anniverserycake_category.jpeg","islive":"1","isdeleted":"0"},{"id":"13","title":"COOKIE","photo":"assets\/cookiecake_category.jpeg","islive":"1","isdeleted":"0"},{"id":"14","title":"PHOTO","photo":"assets\/photocake_category.jpg","islive":"1","isdeleted":"0"},{"id":"15","title":"CUPCAKE","photo":"assets\/cupcake_category.jpeg","islive":"1","isdeleted":"0"},{"id":"16","title":"Festival","photo":"assets\/festivalcake_category.jpeg","islive":"1","isdeleted":"0"},{"id":"17","title":"FRESH_FRIUTS","photo":"assets\/fruitcake_category.jpg","islive":"1","isdeleted":"0"},{"id":"18","title":"KIDS","photo":"assets\/kidscake_category.jpg","islive":"1","isdeleted":"0"}] as List;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getCategory();
  }

  MyNetworkRequest request = MyNetworkRequest();

  getCategory() async {
    String url = 'category.php';
    response = await request.SendRequest(url,'get');
    setState(() {
      response.removeAt(0);
      response.removeAt(0);
    });
    print("This Is category Response..$response");

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F0EB),
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 70),
              child: Text(
                "Menu",
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
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 0, mainAxisSpacing: 0),
          itemBuilder: (context, index) {
            return Category(response[index]);
          },
          itemCount: 8),
    );
  }

  Widget Category(response) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 4, left: 4),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Cakes(category: response,)));
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 10,
          child: Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: AssetImage(response['photo'].toString()), fit: BoxFit.cover)),
            child: Align(
              child: Text(
                response['title'].toString(),
                style: GoogleFonts.titilliumWeb(
                    textStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              alignment: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }
}

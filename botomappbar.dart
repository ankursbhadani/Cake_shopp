import 'package:cake_shopp/cart.dart';
import 'package:cake_shopp/home.dart';
import 'package:cake_shopp/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'user_detail.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: EdgeInsets.only(bottom: 0),
      color: Color(0xFFF1BDB0),
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:0),
            child: Center(
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Home(),
                          type: PageTransitionType.leftToRightWithFade,
                          duration: Duration(milliseconds: 400)));
                },
                icon: Icon(Icons.home_outlined),
                iconSize: 35,
                color: Color(0xFFF16A6A),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: Wishlist(),
                        type: PageTransitionType.leftToRightWithFade,
                        duration: Duration(milliseconds: 400)));
              },
              icon: Icon(Icons.favorite_border),
              iconSize: 35,
              color: Color(0xFFF16A6A)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: Cart(),
                        type: PageTransitionType.leftToRightWithFade,
                        duration: Duration(milliseconds: 400)));
              },
              icon: Icon(Icons.shopping_cart_outlined),
              iconSize: 35,
              color: Color(0xFFF16A6A)),
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: UserDetail(),
                          type: PageTransitionType.leftToRightWithFade,
                          duration: Duration(milliseconds: 400)));
                },
                icon: Icon(Icons.account_box_outlined),
                iconSize: 35,
                color: Color(0xFFF16A6A)),
          ),
        ],
      ),
    );
  }
}

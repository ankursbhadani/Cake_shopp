import 'package:cake_shopp/cake_details.dart';
import 'package:cake_shopp/cake_menu.dart';
import 'package:cake_shopp/common.dart';
import 'package:cake_shopp/getstart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';
import 'cake_list.dart';
import 'cart.dart';
import 'wishlist.dart';
import 'chakout.dart';
import 'user_detail.dart';
import 'edit_user.dart';
import 'checkuser.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'home.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider()..checkLoginStatus(),
      child: MaterialApp(
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return authProvider.isLoggedIn ? Home() : getStart();
          },
        ),
      ),
    );
  }
}


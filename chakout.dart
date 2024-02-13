import 'package:cake_shopp/common.dart';
import 'package:cake_shopp/user_detail.dart';
import 'package:flutter/material.dart';
import 'connection.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:async';

class Checkout extends StatefulWidget {
  final double totalAmount;

  const Checkout({Key? key, required this.totalAmount}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState(totalAmount);
}

class _CheckoutState extends State<Checkout> {
  late Razorpay _razorpay;
  bool _value = false;
  int val = -1;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  String name = '', email = '', contact = '';
  MyNetworkRequest request = MyNetworkRequest();
  FlutterSecureStorage storage = FlutterSecureStorage();
  var response = [
    {'title': ' '}
  ] as List;
  var response_checkout = [
    {'title': ' '}
  ] as List;
  String? userId = "1";

  _CheckoutState(double totalAmount){
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

  }

  getUserdetail() async {
    userId = await storage.read(key: 'userid');
    String url = "users.php?usersid=${userId}";
    response = await request.SendRequest(url, "get");
    print("this is user response ${response}");
    setState(() {
      response.removeAt(0);
      response.removeAt(0);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserdetail();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Payment success logic
    print("Payment Successful: ${response.paymentId}");
    // Proceed with order confirmation
    // Assuming 2 is the value for online payment
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment error logic
    print("Payment Error: ${response.code} - ${response.message}");
    // Show error message to the user
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Payment failed: ${response.message}"),
    ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet logic
    print("External Wallet: ${response.walletName}");
  }

  Future<bool>_confirmOrder(int paymentMode) async {
    // Proceed with order confirmation logic
    String url = 'checkout.php';
    var form = {};
    form['address1'] = addressController.text.trim().toString();
    form['usersid'] = userId?.trim().toString();
    form['fullname'] = nameController.text.trim().toString();
    form['mobile'] = contactController.text.trim().toString();
    form['paymentmode'] = paymentMode.toString();
    response_checkout = await request.SendRequest(url, 'post', form);
    print("this is form $form");
    print(response_checkout);
    if (response_checkout[0]['error'] != 'no') {
      toast("Oops Something went wrong");
    } else {
      if (response_checkout[1]['success'] == 'no') {
        toast(response_checkout[2]['message'].toString());
      } else {
        toast("Order Placed Successfully ");
      }
    }
    return true;
  }
  
  Future<bool> _startPayment() async {
    Completer<bool> completer = Completer<bool>();
    _razorpay.clear();
    var options = {
      'key': 'rzp_test_51NRMl2SGhMZHC', // Replace with your Razorpay API key
      'amount':widget.totalAmount.toDouble()*100 , // Example: 100 for ₹1
      'name': 'Cake Shop',
      'description': 'Payment for order',
      'prefill': {'contact': contactController.text.trim(), 'email': ''},
      'external': {
        'wallets': ['paytm'] // Optional: Enable wallets like Paytm
      }
    };

    try {
      _razorpay.open(options);
      // Listen for payment success event
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
        completer.complete(true); // Payment successful
      });
      // Listen for payment error event
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
        completer.complete(false); // Payment failed
      });
      // Listen for external wallet event
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response) {
        completer.complete(false); // Payment failed
      });
    } catch (e) {
      print("Error: $e");
      completer.complete(false); // Payment failed
    }

    return completer.future; // Return a Future<bool>
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F0EB),
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 56),
              child: Text(
                "Checkout",
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 250,
                //color: Colors.pinkAccent.shade100,
                child: Image.asset("assets/cakelogo.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 10, top: 0),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: "Enter Your Name",
                      labelStyle: GoogleFonts.titilliumWeb(
                          textStyle: TextStyle(color: Color(0xFF644734))),
                      floatingLabelStyle: TextStyle(color: Color(0xFFF16A6A)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Color(0xFFF16A6A), width: 2),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 15, left: 15, top: 8, bottom: 10),
                child: TextFormField(
                  controller: contactController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText: "Contact Nuber",
                      labelStyle: GoogleFonts.titilliumWeb(
                          textStyle: TextStyle(color: Color(0xFF644734))),
                      floatingLabelStyle: TextStyle(color: Color(0xFFF16A6A)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Color(0xFFF16A6A), width: 2),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 15, left: 15, top: 8, bottom: 10),
                child: TextFormField(
                  controller: addressController,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                      labelText: "Address To Deliver",
                      labelStyle: GoogleFonts.titilliumWeb(
                          textStyle: TextStyle(color: Color(0xFF644734))),
                      floatingLabelStyle: TextStyle(color: Color(0xFFF16A6A)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Color(0xFFF16A6A), width: 2),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 238, left: 0, top: 8, bottom: 25),
                child: Text(
                  "Payment Otions",
                  style: GoogleFonts.titilliumWeb(
                      textStyle:
                          TextStyle(color: Color(0xFF644734), fontSize: 18)),
                ),
              ),
              ListTile(
                title: Text("Online",
                    style: GoogleFonts.titilliumWeb(
                        textStyle: TextStyle(
                            color: Color(0xFF644734),
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                leading: Radio(
                  value: 2,
                  groupValue: val,
                  onChanged: (value) {
                    setState(() {
                      val = value!;
                    });
                  },
                  activeColor: Color(0xFFF16A6A),
                ),
              ),
              ListTile(
                title: Text("Cash On Delivery (COD)",
                    style: GoogleFonts.titilliumWeb(
                        textStyle: TextStyle(
                            color: Color(0xFF644734),
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                leading: Radio(
                  value: 1,
                  groupValue: val,
                  onChanged: (value) {
                    setState(() {
                      val = value!;
                    });
                  },
                  activeColor: Color(0xFFF16A6A),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    _startPayment().then((paymentStatus) {
                      if (paymentStatus) {
                        _confirmOrder(val).then((orderStatus) {
                          if (orderStatus) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserDetail(),
                            ));
                          } else {
                            // Handle order confirmation failure
                            // For example, show an error message to the user
                            toast("Failed to confirm order");
                          }
                        });
                      } else {
                        // Handle payment failure
                        // For example, show an error message to the user
                        toast("Payment failed");
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF16A6A),
                      shape: StadiumBorder(),
                      elevation: 10,
                      minimumSize: Size(160, 40)),
                  child: Text(
                    "Order Confirm",
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
            ],
          ),
        ),
      ),
    );
  }

}

// TODO Implement this library.
import 'package:cake_shopp/login.dart';
import 'package:cake_shopp/user_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'common.dart';
import 'package:get/get.dart';
import 'connection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditUser extends StatefulWidget {
  final List<dynamic> data;

  const EditUser({Key? key, required this.data}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  String name = '', email = '', password = '', contact = '';
  MyNetworkRequest request = MyNetworkRequest();
  FlutterSecureStorage storage = FlutterSecureStorage();
  var response = [
    {'title': ' '}
  ] as List;
  var response_detai = [
    {'title': ' '}
  ] as List;
  var response_order = [
    {'title': ' '}
  ] as List;

  String? userId = "1";




  getUserdetail() async {
    userId = await storage.read(key: 'userid');
    String url = "users.php?usersid=${userId}";
    response = await request.SendRequest(url, "get");
    print("this is user response ${response}");
    setState(() {
      response.removeAt(0);
      response.removeAt(0);
      nameController.text = response[0]['name'].toString();
      emailController.text = response[0]['email'].toString();
      contactController.text = response[0]['mobile'].toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserdetail();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F0EB),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 360,
                color: Colors.pinkAccent.shade100,
                child: Image.asset("assets/cakelogo.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30, left: 90),
                child: Container(
                  height: 50,
                  width: 300,
                  child: Text(
                    "Edit Your Profile",
                    style: GoogleFonts.titilliumWeb(
                      textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF644734),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 0, top: 0),
                child: TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
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
                    right: 15, left: 15, top: 0, bottom: 0),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Enter Your Email",
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
                    right: 15, left: 15, top: 0, bottom: 70),
                child: TextFormField(
                  controller: contactController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Enter Your Contact Number",
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
              ElevatedButton(
                onPressed: () {
                  if (checkInput() == true) {
                    sendRegisterRequest().then((value) {
                      if (response_detai.isNotEmpty &&
                          response_detai.length > 1 &&
                          response_detai[1]['success'] == 'yes') {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => UserDetail()));
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF16A6A),
                    shape: StadiumBorder(),
                    elevation: 10,
                    minimumSize: Size(230, 40)),
                child: Text(
                  "Save Changes",
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
        ),
      ),
    );
  }

  bool checkInput() {
    bool result = false;
    int nameLength = nameController.text.trim().length;
    int emailLength = emailController.text.trim().length;
    int passwordlLength = passwordController.text.trim().length;
    int contactLength = contactController.text.trim().length;
    if (nameLength == 0 || emailLength == 0 || contactLength == 0) {
      toast("Please Fill all Field");
    } else {
      if (contactLength != 10) {
        toast("Enter Valid Mobile Number");
      } else {
        result = true;
      }
    }
    return result;
  }

  Future<void> sendRegisterRequest() async {
    String url = 'update_user.php';
    var form = {};
    form['email'] = emailController.text.trim().toString();
    form['userId'] = userId?.trim().toString();
    form['name'] = nameController.text.trim().toString();
    form['mobile'] = contactController.text.trim().toString();
   response_detai = await request.SendRequest(url, 'post', form);
    print("this is form $form");
    print(response_detai);
    if (response_detai[0]['error'] != 'no') {
      toast("Oops Something went wrong");
    } else {
      if (response_detai[1]['success'] == 'no') {
        toast("Oops Something went wrong");
      } else {
        toast("Detail Changed Successfully ");
      }
    }
  }
}

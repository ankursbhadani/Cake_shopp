import 'package:cake_shopp/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'common.dart';
import 'package:get/get.dart';
import 'connection.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  String name='',email='',password='',contact='';
  MyNetworkRequest request = MyNetworkRequest();
  var response = [{'name': ' '}] as List;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F0EB),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 380,
                //color: Colors.pinkAccent.shade100,
                child: Image.asset("assets/cakelogo.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15,bottom: 10,top: 0),
                child: TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      labelText: "Enter Your Name",
                      labelStyle: GoogleFonts.titilliumWeb(textStyle: TextStyle(color: Color(0xFF644734))),
                      floatingLabelStyle: TextStyle(color: Color(0xFFF16A6A)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Color(0xFFF16A6A),
                            width: 2
                        ),
                      )
                  ),

                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 15,left: 15,top: 8,bottom: 10),
                child: TextFormField(
                  controller: emailController,
                  keyboardType:TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Enter Your Email",
                      labelStyle: GoogleFonts.titilliumWeb(textStyle: TextStyle(color: Color(0xFF644734))),
                      floatingLabelStyle: TextStyle(color: Color(0xFFF16A6A)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Color(0xFFF16A6A),
                            width: 2
                        ),
                      )
                  ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15,left: 15,top: 8,bottom: 10),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: "Enter Your Password",
                      labelStyle: GoogleFonts.titilliumWeb(textStyle: TextStyle(color: Color(0xFF644734))),
                      floatingLabelStyle: TextStyle(color: Color(0xFFF16A6A)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Color(0xFFF16A6A),
                            width: 2
                        ),
                      )
                  ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15,left: 15,top: 8,bottom: 25),
                child: TextFormField(
                  controller: contactController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Enter Your Contact Number",
                      labelStyle: GoogleFonts.titilliumWeb(textStyle: TextStyle(color: Color(0xFF644734))),
                      floatingLabelStyle: TextStyle(color: Color(0xFFF16A6A)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Color(0xFFF16A6A),
                            width: 2
                        ),
                      )
                  ),

                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if(checkInput()==true){
                    sendRegisterRequest().then((value) {
                      if (response.isNotEmpty &&
                          response.length > 1 &&
                          response[1]['success'] == 'yes') {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
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
                  "Register",
                  style: GoogleFonts.titilliumWeb(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:Color(0xFFF9F0EB),
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
   if(nameLength==0||emailLength==0||passwordlLength==0||contactLength==0){
     toast("Please Fill all Field");
   }else{
     if(contactLength!=10){
       toast("Enter Valid Mobile Number");
     }
     else{
       result=true;
     }
   }
   return result;
 }

  Future<void> sendRegisterRequest() async {
    String url = 'register.php';
    var form = {};
    form['email'] = emailController.text.trim().toString();
    form['password'] = passwordController.text.trim().toString();
    form['name'] = nameController.text.trim().toString();
    form['mobile'] = contactController.text.trim().toString();
    response = await request.SendRequest(url,'post',form);
    print("this is form $form");
    print(response);
    if (response[0]['error'] != 'no') {
      toast("Oops Something went wrong");
    } else {
      if (response[1]['success'] == 'no') {
        toast("Oops Something went wrong");
      } else {
        toast("Register Successfully ");

      }
    }
  }
}


import 'package:cake_shopp/home.dart';
import 'package:cake_shopp/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'checkuser.dart';
import 'connection.dart';
import 'common.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email ='',password ='';
  MyNetworkRequest request = MyNetworkRequest();
  FlutterSecureStorage storage = FlutterSecureStorage();
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
                height: 450,
                //color: Colors.pinkAccent.shade100,
                child: Image.asset("assets/cakelogo.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15,bottom: 10,top: 0),
                child: TextFormField(
                  controller: emailidController,
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
                padding: const EdgeInsets.only(right: 15,left: 15,top: 8,bottom: 40),
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
              ElevatedButton(
                onPressed: () async {
                  if(checkInput()==true){
                   // print("velue of ${checkInput()}");
                     if(await sendLoginRequest()==true){
                     //  print("sendLoginRequest value is ${sendLoginRequest()}");
                       Provider.of<AuthProvider>(context, listen: false).loginUser();
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                     }

                  }

                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF16A6A),
                    shape: StadiumBorder(),
                    elevation: 10,
                    minimumSize: Size(230, 40)),
                child: Text(
                  "Login",
                  style: GoogleFonts.titilliumWeb(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:Color(0xFFF9F0EB),
                    ),
                  ),
                ),
              ),
              Container(height: 18,
                child: Text("OR",style:GoogleFonts.titilliumWeb(
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF644734),
                  ),
                ) ,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Register()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF16A6A),
                    shape: StadiumBorder(),
                    elevation: 10,
                    minimumSize: Size(230, 40)),
                child: Text(
                  "Register Here",
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
    );;
  }
  bool checkInput(){
    bool result = false;
    email = emailidController.text;
    password = passwordController.text;
    if(email.trim().length==0 || password.trim().length == 0){
      print("Please fill all the field");
      toast("Please fill all field");
    }
else{
      result =true;
    }
return result;
  }
  Future<bool> sendLoginRequest()async {
    bool result =false;
    String url = 'login.php';
    var form ={};
    form['email'] = email;
    form['password']=password;
    var response = await request.SendRequest(url,'post',form);
    print("this is response"+ response.toString());
    if(response[0]['error'] == 'no'){
      if(response[1]['success'] == 'yes'){
        storage.write(key: 'userid', value: response[3]['id']);
        result=true;
        //print("Result is $result");
      }
      toast(response[2]['message'].toUpperCase());
    }
    return result;

  }
}

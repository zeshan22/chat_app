
import 'package:chat_app/Widget/widget.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';

import 'chat_room_screen.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  bool isLoading = false;

  AuthMethods uthMet = new AuthMethods();

  DatabaseMethods databaseMethods  = new DatabaseMethods();

  HelperFunctions helperFunctions  = new HelperFunctions();


  final formkey = GlobalKey<FormState>();
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController userEmailEditingController = TextEditingController();
  TextEditingController userPassEditingController = TextEditingController();

  signMeUp(){

    if(formkey.currentState.validate()){
      Map<String,String> userInfoMap ={
        "name": userNameEditingController.text,
        "email":userEmailEditingController.text,
      };

      HelperFunctions.saveUserEmailSharedPreference(userEmailEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameEditingController.text);





      setState(() {
        isLoading = true;
      });



      uthMet.signUpEmailandPassword(userEmailEditingController.text,
      userPassEditingController.text).then((val){
        databaseMethods.getUserMap(userInfoMap);

        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()
        ));

      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) :SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        validator: (val){
                          return val.isEmpty || val.length < 2 ? 'Please provide username':null;
                        },
                      controller: userNameEditingController,
                        style: simpleTextFieldStyle(),
                        decoration:textFieldInputDecoration('username'),
                      ),
                      TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Enter correct email";
                        },
                        controller: userEmailEditingController,
                        style: simpleTextFieldStyle(),
                        decoration:textFieldInputDecoration('email'),
                      ),
                      TextFormField(
                        validator: (val){
                          return val.length>6 ? null: "Please provide valid password";
                        },
                        controller: userPassEditingController,
                        style: simpleTextFieldStyle(),
                        decoration:textFieldInputDecoration('password'),
                      ),
                      SizedBox(height: 8,),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                        child: Text("Forgot Password",style: simpleTextFieldStyle(),),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: (){
                          signMeUp();

                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors:[
                                  const Color(0xff007EF4),
                                  const Color(0xff2A75BC)
                                ]
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "Sign Up",style: TextStyle(color: Colors.white,fontSize: 17),
                          ),
                        ),
                      ),
                      SizedBox(height: 16,),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(

                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "Sign Up with Google",style: TextStyle(color: Colors.black87,fontSize: 17),
                        ),
                      ),

                      SizedBox(height: 16,),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Already have account?",style: mediumTextFieldStyle(),),
                            GestureDetector(
                              onTap: (){
                                  // ignore: unnecessary_statements
                                  widget.toggle();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text("SignIn now",style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  decoration: TextDecoration.underline,
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 50,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

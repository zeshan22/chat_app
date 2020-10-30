import 'package:chat_app/Widget/widget.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chat_room_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  HelperFunctions helperFunctions = new HelperFunctions();
  final formKey = GlobalKey<FormState>();

  AuthMethods uthMet = new AuthMethods();

  QuerySnapshot querySnapshot;

  TextEditingController userEmailEditingController = TextEditingController();
  TextEditingController userPassEditingController = TextEditingController();

  bool isLoading = false;
  signIn() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          userEmailEditingController.text);

      setState(() {
        isLoading = true;
      });


      databaseMethods.getUserByEmail(userEmailEditingController.text)
      .then((val) =>{

        querySnapshot = val,
        HelperFunctions.saveUserNameSharedPreference(querySnapshot.docs[0].data()['name'])

      });

          uthMet
          .signInEmailandPassword(
              userEmailEditingController.text, userPassEditingController.text)
          .then((val) => {if (val != null) {

            HelperFunctions.saveUserLoggedInSharedPreference(true),
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context)  => ChatRoom()
        ))

      }});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : "Enter correct email";
                        },
                        controller: userEmailEditingController,
                        style: simpleTextFieldStyle(),
                        decoration: textFieldInputDecoration('email'),
                      ),
                      TextFormField(
                        validator: (val) {
                          return val.isEmpty || val.length < 2
                              ? 'Please provide username'
                              : null;
                        },
                        controller: userPassEditingController,
                        style: simpleTextFieldStyle(),
                        decoration: textFieldInputDecoration('password'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Forgot Password",
                    style: simpleTextFieldStyle(),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        const Color(0xff007EF4),
                        const Color(0xff2A75BC)
                      ]),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Sign In with Google",
                    style: TextStyle(color: Colors.black87, fontSize: 17),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have account?",
                      style: mediumTextFieldStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        // ignore: unnecessary_statements
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Register now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              decoration: TextDecoration.underline,
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

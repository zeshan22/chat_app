import 'package:flutter/material.dart';

Widget appbarmain(BuildContext context){
  return AppBar(
    title: Image.asset("assets/Images/logo.png",height: 50,),
  );
}

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white54,
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          )),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          )));
}

TextStyle simpleTextFieldStyle() {
  return TextStyle(
         color: Colors.white,
    fontSize: 16
  );
}

TextStyle mediumTextFieldStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 17
  );
}
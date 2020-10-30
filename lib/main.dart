import 'package:chat_app/helper/authenthicate.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/views/chat_room_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    getUserLoggedInState();
    super.initState();
  }



  getUserLoggedInState() async {

    await HelperFunctions.getUserLoggedInSharedPreference().then((value){

      setState(() {
        userIsLoggedIn = value;
      });

    });

  }




  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: "Flutter HomePage",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:userIsLoggedIn ? ChatRoom() :Authenticate(),
    );
  }
}


import 'package:chat_app/Widget/widget.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String _myName;

class _SearchScreenState extends State<SearchScreen> {

  QuerySnapshot snapshot;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = TextEditingController();

  initiateSearch(){
    databaseMethods.getUserByName(searchEditingController.text)
        .then((val){
          setState(() {

            snapshot = val;

          });
    });
    
  }

  createChatRoomAndStartConversation({String userName}){
    if(userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      print("chatRoomId"+chatRoomId);
      List<String> users = [userName, Constants.myName];
      Map<String,dynamic> charRoomMap = {
        "users":users,
        "chatroomid":chatRoomId,
      };
      databaseMethods.createUserMap(chatRoomId,charRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context)  => ConversationScreen(chatRoomId)
      ));
    }else{print('You cannot send message');}


  }

  Widget searchList() {

    return snapshot != null ? ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.docs.length,
      itemBuilder: (context,index){
        return searchTile(
          userName: snapshot.docs[index].data()["name"],
          userEmail: snapshot.docs[index].data()["email"],
        );
      }):Container();
  }

  Widget searchTile({String userName,String userEmail}){

    return Container(

      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(userName,style: mediumTextFieldStyle(),),
              Text(userEmail,style:  mediumTextFieldStyle(),),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){

              createChatRoomAndStartConversation(
                userName:userName
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
              child: Text("Message"),
            ),
          )
        ],
      ),
    );

  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{

    _myName = await HelperFunctions.getNameLoggedInSharedPreference();
    setState(() {
      
    });
    print("${_myName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(child: TextField(
                      controller: searchEditingController,
                      decoration: InputDecoration(
                        hintText: "Search username....",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                          border: InputBorder.none,
                      ),

                    ),

                    ),
                      GestureDetector(
                        onTap: (){
                            initiateSearch();
                        },
                        child: Container(
                          height: 40,
                            width: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0x36FFFFFF),
                                const Color(0x0FFFFFFF),
                              ]
                            ),
                              borderRadius: BorderRadius.circular(40),
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset('assets/Images/search_white.png'),
                        ),
                      ),
                   ],
                ),
              ),
              searchList(),
            ],
          ),
        ),
    );
  }
}

getChatRoomId(String a,String b){
  if(a.substring(0,1).codeUnitAt(0)> b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }
  else{
    return "$a\_$b";
  }

}

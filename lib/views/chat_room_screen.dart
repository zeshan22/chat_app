import 'package:chat_app/Widget/widget.dart';
import 'package:chat_app/helper/authenthicate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/views/search.dart';
import 'package:flutter/material.dart';


class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
DatabaseMethods databaseMethods= new DatabaseMethods();

Stream chatRoomStream;

Widget chatRoomList(){

  return StreamBuilder(
    stream: chatRoomStream,
    builder: (context,snapshot){
      return snapshot.hasData ? ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (context,index){
          return ChatRoomTile(
               snapshot.data.docs[index].data()['chatroomid']
                   .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
              snapshot.data.docs[index].data()['chatroomid']
          );
        }
      ): Container();
    },
  );

}

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();

    databaseMethods.getChatRooms(Constants.myName).then((val){

      chatRoomStream  =  val;

    });
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await HelperFunctions.getNameLoggedInSharedPreference();
  }


  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/Images/logo.png',height: 50,),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Authenticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName,this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) =>ConversationScreen(chatRoomId),
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Row(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              alignment:  Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                  borderRadius:  BorderRadius.circular(40),
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}",
              style: mediumTextFieldStyle(),),

            ),
            SizedBox(width: 8,),
            Text(userName,style: mediumTextFieldStyle(),),
          ],
        ),
      ),
    );
  }
}

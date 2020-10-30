import 'package:chat_app/Widget/widget.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Stream chatMsgStream;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController msgEditingController = new TextEditingController();

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatMsgStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    snapshot.data.documents[index].data()["message"],
                    snapshot.data.documents[index].data()["sendby"] ==
                        Constants.myName,
                  );
                })
            : Center(
                child: Text(
                  "Here will appear your conversations",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              );
      },
    );
  }

  sendMessage() {
    if (msgEditingController.text.isNotEmpty) {
      Map<String, String> messageMap = {
        "message": msgEditingController.text,
        "sendby": Constants.myName,
      };

      databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
      print(widget.chatRoomId);
      msgEditingController.text = "";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseMethods.getConversationMessage(widget.chatRoomId).then((val) {
      setState(() {
        chatMsgStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarmain(context),
      body: Container(
        child: Stack(
          children: [
            chatRoomsList(),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: msgEditingController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendbyMe;
  MessageTile(this.message, this.isSendbyMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendbyMe? 0:24,right: isSendbyMe? 24:0),
      margin: EdgeInsets.symmetric(vertical: 8),

      width: MediaQuery.of(context).size.width,
      alignment: isSendbyMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: isSendbyMe
                      ? [
                    const Color(0xff007EF4),
                    const Color(0xff2A75BC),
                  ]
                      : [
                    const Color(0x1AFFFFFF),
                    const Color(0x1AFFFFFF),
                  ]),
              borderRadius: isSendbyMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23),
              ): BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23),
              )

          ),
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
          child: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
      )),
    );
  }
}

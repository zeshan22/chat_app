

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{


  getUserByName(String username) async {
    return await FirebaseFirestore.instance.collection('Users')
        .where('name',isEqualTo: username).get();
  }


  getUserByEmail(String userEmail) async {
    return await FirebaseFirestore.instance.collection('Users')
        .where('name',isEqualTo: userEmail).get();
  }


  getUserMap(userMap){

    FirebaseFirestore.instance.collection('Users').add(userMap).catchError((e){
      print(e.toString());
    });
  }

  createUserMap(String chatRoomId,chatRoomMap){
    
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId).set(chatRoomMap).catchError((e){
          print(e.toString());
    });
    
  }

  addConversationMessage(String chatRoomId,messageMap){

    FirebaseFirestore.instance.collection('ChatRoom')
        .doc(chatRoomId).collection("chats")
        .add(messageMap);
  }


  getConversationMessage(String chatRoomId)  async {

   return await FirebaseFirestore.instance.collection('ChatRoom')
        .doc(chatRoomId).collection("chats").orderBy('time',descending: false).snapshots();
  }

  getChatRooms(String username) async{
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .where("users",arrayContains: username)
        .snapshots();
  }

}


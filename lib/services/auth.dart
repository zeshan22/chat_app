import 'package:chat_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UUser _userFromFirebaseApp(User user) {
    return user != null ? UUser(userId: user.uid) : null;
  }

  Future signInEmailandPassword(String email, String pass) async {
    try {
      UserCredential authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User firebaseUser = authResult.user;
      return _userFromFirebaseApp(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpEmailandPassword(String email, String pass) async {
    try {
      UserCredential results = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      User firebaseUser = results.user;
      return _userFromFirebaseApp(firebaseUser);
    } catch (e) {
      print(e.toString());
      print('I am catch');
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}

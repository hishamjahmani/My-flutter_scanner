import 'package:flutter_scanner/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_scanner/services/database.dart';
//import 'package:toast/toast.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String error = "Great";

  

  //create user obj based on FirebaseUser
  AppUser _userFromFirebaseUser(User user){
    return user != null ? AppUser(uid: user.uid) : null;
    // if(user != null){
    //   for(int i = 0; i< users.length; i++){
    //     if (users[i].uid == user.uid){
    //       return AppUser(uid: user.uid, userName: users[i].userName, userSection: users[i].userSection);
    //     }
    //   }
    // } else{
    //   return null;
    // }
  }

  // auth change user stream
  Stream<AppUser> get user{
    return _auth.authStateChanges()
        //.map((User user) => _userFromFirebaseUser(user));
          .map(_userFromFirebaseUser);   // the same as above.
  }

  // sign in anon
  // Future signInAnon() async {
  //   try {
  //     var result = await _auth.signInAnonymously();
  //     var user = result.user;
  //     return _userFromFirebaseUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      var result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      var user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      error = e.toString();
      print(e.toString());
    }
  }

  String currentError() {
    return error;
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password, String userName, String userSection) async{
    try{
      var result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      var user = result.user;
      await DatabaseService(uid: user.uid).updateUsersList(user.uid,email, userName, userSection);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
    }
  }

  //sign out

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
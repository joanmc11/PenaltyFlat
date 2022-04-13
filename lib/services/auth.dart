import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:penalty_flat_app/models/user.dart';
import 'package:penalty_flat_app/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //creao un user object basat en la FirebaseUser
  MyUser? _userFromFirebaseUser(User user) {
    return MyUser(uid: user.uid);
  }

//auth changes user stream
  Stream<MyUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  //Sign in anonymus
  Future signInAnon() async {
    //faig un try, provo algo, i si això no funciona agafo l'error amb un catch i faig que actuii diferent
    try {
      //faig una request a través de _auth, amb l'await per esperar a completar la request
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      return _userFromFirebaseUser(user);
    } catch (e) {
      //agafo l'error
      debugPrint(e.toString());
      return null;
    }
  }

//SignIn with email and passowrd
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

//register with email and password
  Future registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      //crear document per l'usuari a la database amb el seu uid
      await DatabaseService(uid: user!.uid).updateUserdata(name);

      return _userFromFirebaseUser(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //sign in with email and pasword

  //sign in with email and password

  //sign out
}

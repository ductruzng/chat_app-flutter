import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, password) async {
    try {
      // sign in user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // save user info if it doesn't exist
      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email, password) async {
    try {
      // create user
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // save user info in a separate doc
      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "email": email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

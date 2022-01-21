import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService{
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Stream<User?> get authStateChanges => _auth.idTokenChanges();
  
  //sign-in email & password
  Future<String?> signIn(
    {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email, password: password
      );
      return "Signed in";
    } on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

  //register email & password
  Future<String?> signUp(
    {required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email, password: password
      );
      //store name & email in local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("myName", email.split('@')[0]);
      prefs.setString("myEmail", email);
      return "Signed up";
    } on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

  //current user
  String? getMyId(){
    return _auth.currentUser?.uid;
  }

  //sign-out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
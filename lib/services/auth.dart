import 'package:firebase_auth/firebase_auth.dart';

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
      return "Signed up";
    } on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

  //get logged-in user
  User? getMe() {
    try {
      return _auth.currentUser;
    } on FirebaseAuthException {
      return null;
    }
  }

  //sign-out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
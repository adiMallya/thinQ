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
      UserCredential res = await _auth.createUserWithEmailAndPassword(
        email: email, password: password
      );
      User? user = res.user;
      if (user != null) {
        user.updateDisplayName(user.email?.split("@")[0]);
      }
      return "Signed up";
    } on FirebaseAuthException catch(e) {
      return e.message;
    }
  }

  //current user
  User? getMe(){
    return _auth.currentUser;
  }

  //sign-out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  AuthController._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static getUserId() {
    return _auth.currentUser!.uid;
  }

  static signOut() async {
    await _auth.signOut();
  }

  static login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (error) {
      return false;
    }
  }

  static createuser(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {

      return e.message;
    }
  }
}

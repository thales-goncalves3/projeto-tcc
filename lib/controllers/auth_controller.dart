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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true; // Autenticação bem-sucedida
    } catch (error) {
      return false; // Autenticação falhou, retorna false e a mensagem de erro
    }
  }

  static register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "The password provided is too weak.";
      } else if (e.code == "email-already-in-use") {
        return "The account already exist for that email.";
      }
    }
  }
}

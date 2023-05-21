import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';

class DatabaseController {
  DatabaseController._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  

  static Future<QuerySnapshot<Map<String, dynamic>>> getUser() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(AuthController.getUserId())
        .collection("infos")
        .get();
  }

  static createUser(String username, String email, bool partner) {
    _db
        .collection("users")
        .doc(AuthController.getUserId())
        .collection("infos")
        .add({
      'username': username,
      'email': email,
      'partner': partner,
    });
  }

  
}

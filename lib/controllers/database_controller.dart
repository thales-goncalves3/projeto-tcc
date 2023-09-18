import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';

class DatabaseController {
  DatabaseController._();

  static Future<QuerySnapshot<Map<String, dynamic>>> getUser() async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(AuthController.getUserId())
        .collection("infos")
        .get();
  }

  static createUser(String username, String email, bool partner) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(AuthController.getUserId())
        .collection("infos")
        .doc(AuthController.getUserId())
        .set({
      'username': username,
      'email': email,
      'partner': partner,
    });
  }
}

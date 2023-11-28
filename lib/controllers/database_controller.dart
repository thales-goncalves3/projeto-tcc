import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_tcc/controllers/auth_controller.dart';

class DatabaseController {
  DatabaseController._();

  static Future<bool> isPartner() async {
    final userId = AuthController.getUserId();

    if (userId != null) {
      final userDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (userDocument.exists) {
        final userData = userDocument.data();

        final partner = userData!['partner'];

        return partner;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static getScore() async {
    var infos = await getUserInfos();

    return infos['score'] ?? 0;
  }

  static moneySaved() async {
    var infos = await getUserInfos();
    return infos['savedMoney'] ?? 0.0;
  }

  static countQuiz() async {
    var infos = await getUserInfos();
    return infos['countQuiz'] ?? 0;
  }

  static getUserInfos() async {
    var uuid = await AuthController.getUserId();

    var infos =
        await FirebaseFirestore.instance.collection("users").doc(uuid).get();

    var data = infos.data() as Map<String, dynamic>;

    return data;
  }

  static getUsername(uuid) async {
    var infos = await getUserInfos();

    return infos['username'];
  }

  static Future<List<QueryDocumentSnapshot>> getAllUsers() async {
    try {
      final usersQuerySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("partner", isEqualTo: false)
          .get();

      if (usersQuerySnapshot.docs.isNotEmpty) {
        return usersQuerySnapshot.docs;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  static Stream<List<QueryDocumentSnapshot>> getUsersStream() {
    return FirebaseFirestore.instance
        .collection("users")
        .where('partner', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  static createUser(String username, String email, bool partner) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(AuthController.getUserId())
        .set({
      'username': username,
      'email': email,
      'partner': partner,
      'urlPhoto': "https://cdn-icons-png.flaticon.com/512/17/17004.png",
      'description': 'ainda não tem uma descrição',
      'uuid': AuthController.getUserId(),
      'score': 0
    });
  }
}

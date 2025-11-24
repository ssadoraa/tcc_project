import 'package:cloud_firestore/cloud_firestore.dart';

class QrService {
  final FirebaseFirestore firestore;

  QrService({FirebaseFirestore? firestore}) : firestore = firestore ?? FirebaseFirestore.instance;

  Future<Map<String, dynamic>> unlockMission(String userId, String codeLido) async {
    try {
      final query = await firestore
          .collection("missions")
          .where("qr_code", isEqualTo: codeLido)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return {"msg": "QR inválido. Tente novamente.", "isNew": false};
      }

      final missionDoc = query.docs.first;
      final missionId = missionDoc.id;

      final unlockedDoc = await firestore
          .collection("users")
          .doc(userId)
          .collection("unlockedMissions")
          .doc(missionId)
          .get();

      if (unlockedDoc.exists) {
        return {"msg": "Missão já desbloqueada.", "isNew": false};
      }

      await firestore
          .collection("users")
          .doc(userId)
          .collection("unlockedMissions")
          .doc(missionId)
          .set({"unlockedAt": FieldValue.serverTimestamp()});

      return {
        "msg": "${missionDoc["titulo"]}",
        "isNew": true
      };
    } catch (e) {
      return {"msg": "Erro ao processar QR: $e", "isNew": false};
    }
  }
}

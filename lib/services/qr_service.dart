import 'package:cloud_firestore/cloud_firestore.dart';

class QrService {
  final FirebaseFirestore firestore;

  QrService({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  Future<Map<String, dynamic>> unlockAttraction(
    String userId,
    String codeLido,
  ) async {
    try {
      final query = await firestore
          .collection("attractions")
          .where("qr_code", isEqualTo: codeLido)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return {"msg": "QR inválido. Tente novamente.", "isNew": false};
      }

      final attractionDoc = query.docs.first;
      final attractionId = attractionDoc.id;

      final unlockedDoc = await firestore
          .collection("users")
          .doc(userId)
          .collection("unlockedAttractions")
          .doc(attractionId)
          .get();

      if (unlockedDoc.exists) {
        return {"msg": "Ponto já desbloqueado.", "isNew": false};
      }

      await firestore
          .collection("users")
          .doc(userId)
          .collection("unlockedAttractions")
          .doc(attractionId)
          .set({"unlockedAt": FieldValue.serverTimestamp()});

      return {"msg": "${attractionDoc["titulo"]}", "isNew": true};
    } catch (e) {
      return {"msg": "Erro ao processar QR: $e", "isNew": false};
    }
  }
}

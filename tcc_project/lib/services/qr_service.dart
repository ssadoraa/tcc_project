import 'package:cloud_firestore/cloud_firestore.dart';

class QrService {
  final FirebaseFirestore firestore;

  QrService({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> unlockMission(String userId, String codeLido) async {
    try {
      final query = await firestore
          .collection("missions")
          .where("qr_code", isEqualTo: codeLido)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return "QR inválido. Tente novamente.";
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
        return "Missão já desbloqueada.";
      }

      await firestore
          .collection("users")
          .doc(userId)
          .collection("unlockedMissions")
          .doc(missionId)
          .set({"unlockedAt": FieldValue.serverTimestamp()});

      return "Missão desbloqueada: ${missionDoc["titulo"]}";
    } catch (e) {
      return "Erro ao processar QR: $e";
    }
  }
}

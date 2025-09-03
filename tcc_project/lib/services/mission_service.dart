import 'package:cloud_firestore/cloud_firestore.dart';

class MissionService {
  final FirebaseFirestore _firestore;

  MissionService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMissions() {
    return _firestore.collection('missions').orderBy('titulo').snapshots();
  }

  Stream<Set<String>> getUnlockedMissions(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('unlockedMissions')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((d) => d.id).toSet());
  }
}

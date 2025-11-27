import 'package:cloud_firestore/cloud_firestore.dart';

class AttractionService {
  final FirebaseFirestore _firestore;

  AttractionService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAttractions() {
    return _firestore.collection('attractions').orderBy('titulo').snapshots();
  }

  Stream<Set<String>> getUnlockedAttractions(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('unlockedAttractions')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.id).toSet());
  }

  Future<DocumentSnapshot> getAttractionById(String id) {
    return _firestore.collection('attractions').doc(id).get();
  }
}

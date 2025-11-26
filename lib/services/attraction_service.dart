import 'package:cloud_firestore/cloud_firestore.dart';

class AttractionService {
  final FirebaseFirestore _firestore;

  AttractionService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> getattractions() {
    return _firestore.collection('attractions').orderBy('titulo').snapshots();
  }

  Stream<Set<String>> getUnlockedattractions(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('unlockedattractions')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((d) => d.id).toSet());
  }
}

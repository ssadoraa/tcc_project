import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/guide.dart';

class GuideService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Guide>> getGuides() {
    return _firestore.collection('guides').orderBy('nome').snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => Guide.fromMap(doc.id, doc.data()))
            .toList();
      },
    );
  }
}

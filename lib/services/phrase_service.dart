import 'package:cloud_firestore/cloud_firestore.dart';

class PhraseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchPhrases() async {
    final snapshot = await _firestore.collection("infos").get();
    return snapshot.docs.map((doc) => doc['text'] as String).toList();
  }
}
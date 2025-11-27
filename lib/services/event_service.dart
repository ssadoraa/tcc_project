import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc_project/model/event.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Event>> getEvents() {
    return _firestore
        .collection('events')
        .orderBy('data')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList());
  }
}

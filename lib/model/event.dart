import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String titulo;
  final String imageUrl;
  final DateTime? data;

  Event({
    required this.id,
    required this.titulo,
    required this.imageUrl,
    this.data,
  });

  bool get isPast => data != null ? data!.isBefore(DateTime.now()) : false;

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      titulo: data['titulo'] ?? 'Evento sem título',
      imageUrl: data['imagemUrl'] ??
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=60',
      data: data['data'] != null ? (data['data'] as Timestamp).toDate() : null,
    );
  }
}

class Attraction {
  final String id;
  final String titulo;
  final String imageUrl;

  Attraction({required this.id, required this.titulo, required this.imageUrl});

  factory Attraction.fromFirestore(String id, Map<String, dynamic> data) {
    return Attraction(
      id: id,
      titulo: data['titulo'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}

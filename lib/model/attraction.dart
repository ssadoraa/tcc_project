class Attraction {
  final String id;
  final String titulo;
  final String image;

  Attraction({required this.id, required this.titulo, required this.image});

  factory Attraction.fromFirestore(String id, Map<String, dynamic> data) {
    return Attraction(
      id: id,
      titulo: data['titulo'] ?? '',
      image: data['image'] ?? '',
    );
  }
}

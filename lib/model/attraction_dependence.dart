class AttractionDependence {
  final String id;
  final String qrCode;
  final String titulo;
  final String image;
  final String localizacao;
  final String municipio;
  final String tempoEstimado;
  final String dificuldade;
  final String descricao;
  final double distanciaKm;
  final int altitudeInicial;
  final int altitudeMaxima;
  final int altitudeFinal;
  final int ganhoAltitude;
  final List<dynamic> floraRelevante;
  final List<dynamic> atrativos;
  final List<dynamic> infraestrutura;
  final bool agua;
  final String condicaoTrilha;
  final String recomendacao;
  final String historico;
  final double latitude;
  final double longitude;

  AttractionDependence({
    required this.id,
    required this.qrCode,
    required this.titulo,
    required this.image,
    required this.localizacao,
    required this.municipio,
    required this.tempoEstimado,
    required this.dificuldade,
    required this.descricao,
    required this.distanciaKm,
    required this.altitudeInicial,
    required this.altitudeMaxima,
    required this.altitudeFinal,
    required this.ganhoAltitude,
    required this.floraRelevante,
    required this.atrativos,
    required this.infraestrutura,
    required this.agua,
    required this.condicaoTrilha,
    required this.recomendacao,
    required this.historico,
    required this.latitude,
    required this.longitude,
  });

  factory AttractionDependence.fromFirestore(String id, Map<String, dynamic> data) {
    return AttractionDependence(
      id: id,
      qrCode: data['qr_code'] ?? '',
      titulo: data['titulo'] ?? '',
      image: data['image'] ?? '',
      localizacao: data['localizacao'] ?? '',
      municipio: data['municipio'] ?? '',
      tempoEstimado: data['tempo_estimado'] ?? '',
      dificuldade: data['dificuldade'] ?? '',
      descricao: data['descricao'] ?? '',
      distanciaKm: (data['distancia_km'] ?? 0).toDouble(),
      altitudeInicial: data['altitude_inicial'] ?? 0,
      altitudeMaxima: data['altitude_maxima'] ?? 0,
      altitudeFinal: data['altitude_final'] ?? 0,
      ganhoAltitude: data['ganho_altitude'] ?? 0,
      floraRelevante: data['flora_relevante'] ?? [],
      atrativos: data['atrativos'] ?? [],
      infraestrutura: data['infraestrutura'] ?? [],
      agua: data['agua'] ?? false,
      condicaoTrilha: data['condicao_trilha'] ?? '',
      recomendacao: data['recomendacao'] ?? '',
      historico: data['historico'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
    );
  }
}

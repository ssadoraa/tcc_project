class Usuario {
  final String id;
  final String nome;
  final String dataNascimento;
  final String pais;
  final String estado;
  final String cidade;

  Usuario({
    required this.id,
    required this.nome,
    required this.dataNascimento,
    required this.pais,
    required this.estado,
    required this.cidade,
  });

  factory Usuario.fromMap(Map<String, dynamic> data) {
    return Usuario(
      id: data['id'] ?? '',
      nome: data['nome'] ?? '',
      dataNascimento: data['dataNascimento'] ?? '2000-01-01',
      pais: data['pais'] ?? '',
      estado: data['estado'] ?? '',
      cidade: data['cidade'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'dataNascimento': dataNascimento,
      'pais': pais,
      'estado': estado,
      'cidade': cidade,
    };
  }
}
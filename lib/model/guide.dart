class Guide {
  final String id;
  final String nome;
  final String cad;
  final String cidade;
  final String estado;
  final String email;
  final String telefone;

  Guide({
    required this.id,
    required this.nome,
    required this.cad,
    required this.cidade,
    required this.estado,
    required this.email,
    required this.telefone,
  });

  factory Guide.fromMap(String id, Map<String, dynamic> data) {
    return Guide(
      id: id,
      nome: data['nome'] ?? '',
      cad: data['cad'] ?? '',
      cidade: data['cidade'] ?? '',
      estado: data['estado'] ?? '',
      email: data['email'] ?? '',
      telefone: data['telefone'] ?? '',
    );
  }
}

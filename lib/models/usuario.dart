class Usuario {
  final String id;
  final String nome;
  final String email;
  final DateTime dataCriacao;
  final DateTime ultimaAtualizacao;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.dataCriacao,
    required this.ultimaAtualizacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'dataCriacao': dataCriacao.millisecondsSinceEpoch,
      'ultimaAtualizacao': ultimaAtualizacao.millisecondsSinceEpoch,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      dataCriacao: DateTime.fromMillisecondsSinceEpoch(map['dataCriacao'] ?? 0),
      ultimaAtualizacao: DateTime.fromMillisecondsSinceEpoch(map['ultimaAtualizacao'] ?? 0),
    );
  }

  Usuario copyWith({
    String? id,
    String? nome,
    String? email,
    DateTime? dataCriacao,
    DateTime? ultimaAtualizacao,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      ultimaAtualizacao: ultimaAtualizacao ?? this.ultimaAtualizacao,
    );
  }
}

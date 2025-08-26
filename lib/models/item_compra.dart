class ItemCompra {
  final String id;
  final String nome;
  final int quantidade;
  final double preco; // Novo campo para preço
  final bool comprado;
  final DateTime dataCriacao;
  final String? observacao;
  final String? imagemUrl; // Nova propriedade para URL da imagem

  ItemCompra({
    required this.id,
    required this.nome,
    required this.quantidade,
    this.preco = 0.0, // Preço padrão é 0.0
    this.comprado = false,
    required this.dataCriacao,
    this.observacao,
    this.imagemUrl, // Nova propriedade opcional
  });

  // Getter para calcular o subtotal do item
  double get subtotal => quantidade * preco;

  // Converter para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'quantidade': quantidade,
      'preco': preco, // Incluir preço no Map
      'comprado': comprado,
      'dataCriacao': dataCriacao.millisecondsSinceEpoch,
      'observacao': observacao,
      'imagemUrl': imagemUrl, // Incluir imagem no Map
    };
  }

  // Criar a partir de Map (do Firestore)
  factory ItemCompra.fromMap(Map<String, dynamic> map) {
    return ItemCompra(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      quantidade: map['quantidade'] ?? 1,
      preco: (map['preco'] ?? 0.0).toDouble(), // Carregar preço do Map
      comprado: map['comprado'] ?? false,
      dataCriacao: DateTime.fromMillisecondsSinceEpoch(map['dataCriacao'] ?? 0),
      observacao: map['observacao'],
      imagemUrl: map['imagemUrl'], // Carregar imagem do Map
    );
  }

  // Criar cópia com alterações
  ItemCompra copyWith({
    String? id,
    String? nome,
    int? quantidade,
    double? preco, // Incluir preço no copyWith
    bool? comprado,
    DateTime? dataCriacao,
    String? observacao,
    String? imagemUrl, // Incluir imagem no copyWith
  }) {
    return ItemCompra(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      quantidade: quantidade ?? this.quantidade,
      preco: preco ?? this.preco, // Manter ou atualizar preço
      comprado: comprado ?? this.comprado,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      observacao: observacao ?? this.observacao,
      imagemUrl: imagemUrl ?? this.imagemUrl, // Manter ou atualizar imagem
    );
  }
}

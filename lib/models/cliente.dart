class Cliente {
  final int? id;
  final String nome;
  final String cnpj;
  final String segmento; // 'construcao' ou 'agro'
  final String? telefone;
  final String? email;
  final String? endereco;
  final String? cidade;
  final String? estado;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cliente({
    this.id,
    required this.nome,
    required this.cnpj,
    required this.segmento,
    this.telefone,
    this.email,
    this.endereco,
    this.cidade,
    this.estado,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cnpj': cnpj,
      'segmento': segmento,
      'telefone': telefone,
      'email': email,
      'endereco': endereco,
      'cidade': cidade,
      'estado': estado,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nome: map['nome'],
      cnpj: map['cnpj'],
      segmento: map['segmento'],
      telefone: map['telefone'],
      email: map['email'],
      endereco: map['endereco'],
      cidade: map['cidade'],
      estado: map['estado'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Cliente copyWith({
    int? id,
    String? nome,
    String? cnpj,
    String? segmento,
    String? telefone,
    String? email,
    String? endereco,
    String? cidade,
    String? estado,
  }) {
    return Cliente(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cnpj: cnpj ?? this.cnpj,
      segmento: segmento ?? this.segmento,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      endereco: endereco ?? this.endereco,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

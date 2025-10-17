class Lead {
  final int? id;
  final String nome;
  final String empresa;
  final String? telefone;
  final String? email;
  final String segmento;
  final String status; // 'novo', 'contato', 'proposta', 'negociacao', 'ganho', 'perdido'
  final String? origem; // 'site', 'indicacao', 'evento', 'outbound'
  final double? valorEstimado;
  final String? observacoes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Lead({
    this.id,
    required this.nome,
    required this.empresa,
    this.telefone,
    this.email,
    required this.segmento,
    this.status = 'novo',
    this.origem,
    this.valorEstimado,
    this.observacoes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'empresa': empresa,
      'telefone': telefone,
      'email': email,
      'segmento': segmento,
      'status': status,
      'origem': origem,
      'valor_estimado': valorEstimado,
      'observacoes': observacoes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Lead.fromMap(Map<String, dynamic> map) {
    return Lead(
      id: map['id'],
      nome: map['nome'],
      empresa: map['empresa'],
      telefone: map['telefone'],
      email: map['email'],
      segmento: map['segmento'],
      status: map['status'],
      origem: map['origem'],
      valorEstimado: map['valor_estimado'],
      observacoes: map['observacoes'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Lead copyWith({
    String? nome,
    String? empresa,
    String? telefone,
    String? email,
    String? segmento,
    String? status,
    String? origem,
    double? valorEstimado,
    String? observacoes,
  }) {
    return Lead(
      id: id,
      nome: nome ?? this.nome,
      empresa: empresa ?? this.empresa,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      segmento: segmento ?? this.segmento,
      status: status ?? this.status,
      origem: origem ?? this.origem,
      valorEstimado: valorEstimado ?? this.valorEstimado,
      observacoes: observacoes ?? this.observacoes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  String get statusLabel {
    switch (status) {
      case 'novo':
        return 'Novo';
      case 'contato':
        return 'Em Contato';
      case 'proposta':
        return 'Proposta Enviada';
      case 'negociacao':
        return 'Em Negociação';
      case 'ganho':
        return 'Ganho';
      case 'perdido':
        return 'Perdido';
      default:
        return status;
    }
  }
}

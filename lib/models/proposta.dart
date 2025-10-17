class Proposta {
  final int? id;
  final int clienteId;
  final String titulo;
  final String descricao;
  final double valor;
  final String? condicoesPagamento;
  final String? prazoEntrega;
  final String status; // 'rascunho', 'enviada', 'aprovada', 'rejeitada'
  final DateTime? dataEnvio;
  final DateTime? dataValidade;
  final String? observacoes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Proposta({
    this.id,
    required this.clienteId,
    required this.titulo,
    required this.descricao,
    required this.valor,
    this.condicoesPagamento,
    this.prazoEntrega,
    this.status = 'rascunho',
    this.dataEnvio,
    this.dataValidade,
    this.observacoes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cliente_id': clienteId,
      'titulo': titulo,
      'descricao': descricao,
      'valor': valor,
      'condicoes_pagamento': condicoesPagamento,
      'prazo_entrega': prazoEntrega,
      'status': status,
      'data_envio': dataEnvio?.toIso8601String(),
      'data_validade': dataValidade?.toIso8601String(),
      'observacoes': observacoes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Proposta.fromMap(Map<String, dynamic> map) {
    return Proposta(
      id: map['id'],
      clienteId: map['cliente_id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      valor: map['valor'],
      condicoesPagamento: map['condicoes_pagamento'],
      prazoEntrega: map['prazo_entrega'],
      status: map['status'],
      dataEnvio: map['data_envio'] != null ? DateTime.parse(map['data_envio']) : null,
      dataValidade: map['data_validade'] != null ? DateTime.parse(map['data_validade']) : null,
      observacoes: map['observacoes'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  String get statusLabel {
    switch (status) {
      case 'rascunho':
        return 'Rascunho';
      case 'enviada':
        return 'Enviada';
      case 'aprovada':
        return 'Aprovada';
      case 'rejeitada':
        return 'Rejeitada';
      default:
        return status;
    }
  }
}

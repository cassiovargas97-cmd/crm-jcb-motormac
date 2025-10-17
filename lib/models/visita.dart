class Visita {
  final int? id;
  final int clienteId;
  final DateTime data;
  final String? horaInicio;
  final String? horaFim;
  final double? latitude;
  final double? longitude;
  final String? observacoes;
  final DateTime createdAt;

  Visita({
    this.id,
    required this.clienteId,
    required this.data,
    this.horaInicio,
    this.horaFim,
    this.latitude,
    this.longitude,
    this.observacoes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cliente_id': clienteId,
      'data': data.toIso8601String(),
      'hora_inicio': horaInicio,
      'hora_fim': horaFim,
      'latitude': latitude,
      'longitude': longitude,
      'observacoes': observacoes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Visita.fromMap(Map<String, dynamic> map) {
    return Visita(
      id: map['id'],
      clienteId: map['cliente_id'],
      data: DateTime.parse(map['data']),
      horaInicio: map['hora_inicio'],
      horaFim: map['hora_fim'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      observacoes: map['observacoes'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}

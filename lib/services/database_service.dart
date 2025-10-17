import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cliente.dart';
import '../models/visita.dart';
import '../models/lead.dart';
import '../models/proposta.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('crm_jcb.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    // Tabela Clientes
    await db.execute('''
      CREATE TABLE clientes (
        id $idType,
        nome $textType,
        cnpj $textType,
        segmento $textType,
        telefone TEXT,
        email TEXT,
        endereco TEXT,
        cidade TEXT,
        estado TEXT,
        created_at $textType,
        updated_at $textType
      )
    ''');

    // Tabela Leads
    await db.execute('''
      CREATE TABLE leads (
        id $idType,
        nome $textType,
        empresa $textType,
        telefone TEXT,
        email TEXT,
        segmento $textType,
        status $textType,
        origem TEXT,
        valor_estimado REAL,
        observacoes TEXT,
        created_at $textType,
        updated_at $textType
      )
    ''');

    // Tabela Visitas
    await db.execute('''
      CREATE TABLE visitas (
        id $idType,
        cliente_id $intType,
        data $textType,
        hora_inicio TEXT,
        hora_fim TEXT,
        latitude REAL,
        longitude REAL,
        observacoes TEXT,
        created_at $textType,
        FOREIGN KEY (cliente_id) REFERENCES clientes (id) ON DELETE CASCADE
      )
    ''');

    // Tabela Propostas
    await db.execute('''
      CREATE TABLE propostas (
        id $idType,
        cliente_id $intType,
        titulo $textType,
        descricao $textType,
        valor $realType,
        condicoes_pagamento TEXT,
        prazo_entrega TEXT,
        status $textType,
        data_envio TEXT,
        data_validade TEXT,
        observacoes TEXT,
        created_at $textType,
        updated_at $textType,
        FOREIGN KEY (cliente_id) REFERENCES clientes (id) ON DELETE CASCADE
      )
    ''');
  }

  // ==================== CRUD CLIENTES ====================
  Future<int> createCliente(Cliente cliente) async {
    final db = await database;
    return await db.insert('clientes', cliente.toMap());
  }

  Future<List<Cliente>> getAllClientes() async {
    final db = await database;
    final result = await db.query('clientes', orderBy: 'nome ASC');
    return result.map((map) => Cliente.fromMap(map)).toList();
  }

  Future<Cliente?> getCliente(int id) async {
    final db = await database;
    final maps = await db.query('clientes', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Cliente.fromMap(maps.first);
    return null;
  }

  Future<List<Cliente>> getClientesBySegmento(String segmento) async {
    final db = await database;
    final result = await db.query(
      'clientes',
      where: 'segmento = ?',
      whereArgs: [segmento],
      orderBy: 'nome ASC',
    );
    return result.map((map) => Cliente.fromMap(map)).toList();
  }

  Future<int> updateCliente(Cliente cliente) async {
    final db = await database;
    return await db.update(
      'clientes',
      cliente.toMap(),
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  Future<int> deleteCliente(int id) async {
    final db = await database;
    return await db.delete('clientes', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== CRUD LEADS ====================
  Future<int> createLead(Lead lead) async {
    final db = await database;
    return await db.insert('leads', lead.toMap());
  }

  Future<List<Lead>> getAllLeads() async {
    final db = await database;
    final result = await db.query('leads', orderBy: 'created_at DESC');
    return result.map((map) => Lead.fromMap(map)).toList();
  }

  Future<List<Lead>> getLeadsByStatus(String status) async {
    final db = await database;
    final result = await db.query(
      'leads',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => Lead.fromMap(map)).toList();
  }

  Future<int> updateLead(Lead lead) async {
    final db = await database;
    return await db.update('leads', lead.toMap(), where: 'id = ?', whereArgs: [lead.id]);
  }

  Future<int> deleteLead(int id) async {
    final db = await database;
    return await db.delete('leads', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== CRUD VISITAS ====================
  Future<int> createVisita(Visita visita) async {
    final db = await database;
    return await db.insert('visitas', visita.toMap());
  }

  Future<List<Visita>> getAllVisitas() async {
    final db = await database;
    final result = await db.query('visitas', orderBy: 'data DESC');
    return result.map((map) => Visita.fromMap(map)).toList();
  }

  Future<List<Visita>> getVisitasByCliente(int clienteId) async {
    final db = await database;
    final result = await db.query(
      'visitas',
      where: 'cliente_id = ?',
      whereArgs: [clienteId],
      orderBy: 'data DESC',
    );
    return result.map((map) => Visita.fromMap(map)).toList();
  }

  Future<int> deleteVisita(int id) async {
    final db = await database;
    return await db.delete('visitas', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== CRUD PROPOSTAS ====================
  Future<int> createProposta(Proposta proposta) async {
    final db = await database;
    return await db.insert('propostas', proposta.toMap());
  }

  Future<List<Proposta>> getAllPropostas() async {
    final db = await database;
    final result = await db.query('propostas', orderBy: 'created_at DESC');
    return result.map((map) => Proposta.fromMap(map)).toList();
  }

  Future<List<Proposta>> getPropostasByCliente(int clienteId) async {
    final db = await database;
    final result = await db.query(
      'propostas',
      where: 'cliente_id = ?',
      whereArgs: [clienteId],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => Proposta.fromMap(map)).toList();
  }

  Future<int> updateProposta(Proposta proposta) async {
    final db = await database;
    return await db.update(
      'propostas',
      proposta.toMap(),
      where: 'id = ?',
      whereArgs: [proposta.id],
    );
  }

  Future<int> deleteProposta(int id) async {
    final db = await database;
    return await db.delete('propostas', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== ESTATÍSTICAS ====================
  Future<Map<String, int>> getClientesStats() async {
    final db = await database;
    final total = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM clientes'),
    ) ?? 0;
    final construcao = Sqflite.firstIntValue(
      await db.rawQuery("SELECT COUNT(*) FROM clientes WHERE segmento = 'construcao'"),
    ) ?? 0;
    final agro = Sqflite.firstIntValue(
      await db.rawQuery("SELECT COUNT(*) FROM clientes WHERE segmento = 'agro'"),
    ) ?? 0;
    
    return {'total': total, 'construcao': construcao, 'agro': agro};
  }

  Future<Map<String, int>> getLeadsStats() async {
    final db = await database;
    final total = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM leads'),
    ) ?? 0;
    final novos = Sqflite.firstIntValue(
      await db.rawQuery("SELECT COUNT(*) FROM leads WHERE status = 'novo'"),
    ) ?? 0;
    final ganhos = Sqflite.firstIntValue(
      await db.rawQuery("SELECT COUNT(*) FROM leads WHERE status = 'ganho'"),
    ) ?? 0;
    
    return {'total': total, 'novos': novos, 'ganhos': ganhos};
  }

  Future<int> getVisitasCount() async {
    final db = await database;
    return Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM visitas'),
    ) ?? 0;
  }

  Future<int> getPropostasCount() async {
    final db = await database;
    return Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM propostas'),
    ) ?? 0;
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}

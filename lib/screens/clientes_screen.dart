import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../services/database_service.dart';
import 'cliente_form_screen.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  List<Cliente> _clientes = [];
  bool _isLoading = true;
  String _filtroSegmento = 'todos';

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  Future<void> _loadClientes() async {
    setState(() => _isLoading = true);
    
    final clientes = _filtroSegmento == 'todos'
        ? await DatabaseService.instance.getAllClientes()
        : await DatabaseService.instance.getClientesBySegmento(_filtroSegmento);
    
    setState(() {
      _clientes = clientes;
      _isLoading = false;
    });
  }

  Future<void> _deleteCliente(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Deseja realmente excluir este cliente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseService.instance.deleteCliente(id);
      _loadClientes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente excluído')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _filtroSegmento = value);
              _loadClientes();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'todos', child: Text('Todos')),
              const PopupMenuItem(value: 'construcao', child: Text('Construção')),
              const PopupMenuItem(value: 'agro', child: Text('Agro')),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Icon(Icons.filter_list),
                  SizedBox(width: 4),
                  Text('Filtrar'),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _clientes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum cliente cadastrado',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadClientes,
                  child: ListView.builder(
                    itemCount: _clientes.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final cliente = _clientes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: cliente.segmento == 'construcao'
                                ? const Color(0xFFFF6B35)
                                : const Color(0xFF4CAF50),
                            child: Text(
                              cliente.nome[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            cliente.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CNPJ: ${cliente.cnpj}'),
                              if (cliente.telefone != null)
                                Text('Tel: ${cliente.telefone}'),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 'edit', child: Text('Editar')),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Excluir', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ClienteFormScreen(cliente: cliente),
                                  ),
                                ).then((_) => _loadClientes());
                              } else if (value == 'delete') {
                                _deleteCliente(cliente.id!);
                              }
                            },
                          ),
                          onTap: () {
                            // Pode abrir tela de detalhes aqui
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ClienteFormScreen()),
          ).then((_) => _loadClientes());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

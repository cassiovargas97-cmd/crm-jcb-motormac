import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/proposta.dart';
import '../models/cliente.dart';
import '../services/database_service.dart';

class PropostasScreen extends StatefulWidget {
  const PropostasScreen({super.key});

  @override
  State<PropostasScreen> createState() => _PropostasScreenState();
}

class _PropostasScreenState extends State<PropostasScreen> {
  List<Proposta> _propostas = [];
  Map<int, Cliente?> _clientes = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPropostas();
  }

  Future<void> _loadPropostas() async {
    setState(() => _isLoading = true);
    final propostas = await DatabaseService.instance.getAllPropostas();
    for (var proposta in propostas) {
      final cliente = await DatabaseService.instance.getCliente(proposta.clienteId);
      _clientes[proposta.clienteId] = cliente;
    }
    setState(() {
      _propostas = propostas;
      _isLoading = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'rascunho': return Colors.grey;
      case 'enviada': return Colors.blue;
      case 'aprovada': return Colors.green;
      case 'rejeitada': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Propostas')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _propostas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.description_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text('Nenhuma proposta cadastrada',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadPropostas,
                  child: ListView.builder(
                    itemCount: _propostas.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final proposta = _propostas[index];
                      final cliente = _clientes[proposta.clienteId];
                      final valorFormatado = NumberFormat.currency(
                        locale: 'pt_BR',
                        symbol: 'R\$',
                      ).format(proposta.valor);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getStatusColor(proposta.status),
                            child: const Icon(Icons.description, color: Colors.white),
                          ),
                          title: Text(proposta.titulo,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cliente: ${cliente?.nome ?? "Desconhecido"}'),
                              Text('Valor: $valorFormatado',
                                  style: const TextStyle(fontWeight: FontWeight.w500)),
                              Text('Status: ${proposta.statusLabel}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await DatabaseService.instance.deleteProposta(proposta.id!);
                              _loadPropostas();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Proposta excluída')),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Formulário de proposta - Em breve!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/visita.dart';
import '../models/cliente.dart';
import '../services/database_service.dart';

class VisitasScreen extends StatefulWidget {
  const VisitasScreen({super.key});

  @override
  State<VisitasScreen> createState() => _VisitasScreenState();
}

class _VisitasScreenState extends State<VisitasScreen> {
  List<Visita> _visitas = [];
  Map<int, Cliente?> _clientes = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVisitas();
  }

  Future<void> _loadVisitas() async {
    setState(() => _isLoading = true);
    final visitas = await DatabaseService.instance.getAllVisitas();
    for (var visita in visitas) {
      final cliente = await DatabaseService.instance.getCliente(visita.clienteId);
      _clientes[visita.clienteId] = cliente;
    }
    setState(() {
      _visitas = visitas;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visitas')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _visitas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text('Nenhuma visita registrada',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadVisitas,
                  child: ListView.builder(
                    itemCount: _visitas.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final visita = _visitas[index];
                      final cliente = _clientes[visita.clienteId];
                      final dataFormatada = DateFormat('dd/MM/yyyy').format(visita.data);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(Icons.location_on, color: Colors.white),
                          ),
                          title: Text(cliente?.nome ?? 'Cliente Desconhecido',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Data: $dataFormatada'),
                              if (visita.horaInicio != null)
                                Text('Início: ${visita.horaInicio}'),
                              if (visita.observacoes != null)
                                Text(visita.observacoes!, maxLines: 2, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await DatabaseService.instance.deleteVisita(visita.id!);
                              _loadVisitas();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Visita excluída')),
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
            const SnackBar(content: Text('Registro de visita - Em breve!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

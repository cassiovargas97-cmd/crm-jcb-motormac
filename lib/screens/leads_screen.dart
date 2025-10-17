import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/lead.dart';
import '../services/database_service.dart';
import 'lead_form_screen.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  List<Lead> _leads = [];
  bool _isLoading = true;
  String _filtroStatus = 'todos';

  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  Future<void> _loadLeads() async {
    setState(() => _isLoading = true);
    
    final leads = _filtroStatus == 'todos'
        ? await DatabaseService.instance.getAllLeads()
        : await DatabaseService.instance.getLeadsByStatus(_filtroStatus);
    
    setState(() {
      _leads = leads;
      _isLoading = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'novo':
        return Colors.blue;
      case 'contato':
        return Colors.orange;
      case 'proposta':
        return Colors.purple;
      case 'negociacao':
        return Colors.amber;
      case 'ganho':
        return Colors.green;
      case 'perdido':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _filtroStatus = value);
              _loadLeads();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'todos', child: Text('Todos')),
              const PopupMenuItem(value: 'novo', child: Text('Novos')),
              const PopupMenuItem(value: 'contato', child: Text('Em Contato')),
              const PopupMenuItem(value: 'proposta', child: Text('Proposta Enviada')),
              const PopupMenuItem(value: 'negociacao', child: Text('Negociação')),
              const PopupMenuItem(value: 'ganho', child: Text('Ganhos')),
              const PopupMenuItem(value: 'perdido', child: Text('Perdidos')),
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
          : _leads.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_outline, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum lead cadastrado',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadLeads,
                  child: ListView.builder(
                    itemCount: _leads.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final lead = _leads[index];
                      final valorFormatado = lead.valorEstimado != null
                          ? NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                              .format(lead.valorEstimado)
                          : 'Não informado';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getStatusColor(lead.status),
                            child: const Icon(Icons.star, color: Colors.white),
                          ),
                          title: Text(
                            lead.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${lead.empresa} - ${lead.statusLabel}'),
                              Text('Valor: $valorFormatado',
                                  style: const TextStyle(fontWeight: FontWeight.w500)),
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
                                    builder: (_) => LeadFormScreen(lead: lead),
                                  ),
                                ).then((_) => _loadLeads());
                              } else if (value == 'delete') {
                                _deleteLead(lead.id!);
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LeadFormScreen()),
          ).then((_) => _loadLeads());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteLead(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Deseja realmente excluir este lead?'),
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
      await DatabaseService.instance.deleteLead(id);
      _loadLeads();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lead excluído')),
        );
      }
    }
  }
}

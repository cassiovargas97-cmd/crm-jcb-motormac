import 'package:flutter/material.dart';
import '../models/lead.dart';
import '../services/database_service.dart';

class LeadFormScreen extends StatefulWidget {
  final Lead? lead;
  const LeadFormScreen({super.key, this.lead});

  @override
  State<LeadFormScreen> createState() => _LeadFormScreenState();
}

class _LeadFormScreenState extends State<LeadFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _empresaController;
  late TextEditingController _telefoneController;
  late TextEditingController _emailController;
  late TextEditingController _valorController;
  late TextEditingController _observacoesController;
  String _segmento = 'construcao';
  String _status = 'novo';
  String _origem = 'site';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.lead?.nome);
    _empresaController = TextEditingController(text: widget.lead?.empresa);
    _telefoneController = TextEditingController(text: widget.lead?.telefone);
    _emailController = TextEditingController(text: widget.lead?.email);
    _valorController = TextEditingController(
        text: widget.lead?.valorEstimado?.toString() ?? '');
    _observacoesController = TextEditingController(text: widget.lead?.observacoes);
    if (widget.lead != null) {
      _segmento = widget.lead!.segmento;
      _status = widget.lead!.status;
      _origem = widget.lead!.origem ?? 'site';
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _empresaController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _valorController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final lead = Lead(
      id: widget.lead?.id,
      nome: _nomeController.text,
      empresa: _empresaController.text,
      telefone: _telefoneController.text.isEmpty ? null : _telefoneController.text,
      email: _emailController.text.isEmpty ? null : _emailController.text,
      segmento: _segmento,
      status: _status,
      origem: _origem,
      valorEstimado: _valorController.text.isEmpty
          ? null
          : double.tryParse(_valorController.text.replaceAll(',', '.')),
      observacoes:
          _observacoesController.text.isEmpty ? null : _observacoesController.text,
    );

    try {
      if (widget.lead == null) {
        await DatabaseService.instance.createLead(lead);
      } else {
        await DatabaseService.instance.updateLead(lead);
      }

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(widget.lead == null ? 'Lead criado!' : 'Lead atualizado!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lead == null ? 'Novo Lead' : 'Editar Lead'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Contato *',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _empresaController,
                decoration: const InputDecoration(
                  labelText: 'Empresa *',
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _segmento,
                decoration: const InputDecoration(
                  labelText: 'Segmento',
                  prefixIcon: Icon(Icons.category),
                ),
                items: const [
                  DropdownMenuItem(value: 'construcao', child: Text('Construção')),
                  DropdownMenuItem(value: 'agro', child: Text('Agro')),
                ],
                onChanged: (v) => setState(() => _segmento = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  prefixIcon: Icon(Icons.flag),
                ),
                items: const [
                  DropdownMenuItem(value: 'novo', child: Text('Novo')),
                  DropdownMenuItem(value: 'contato', child: Text('Em Contato')),
                  DropdownMenuItem(value: 'proposta', child: Text('Proposta Enviada')),
                  DropdownMenuItem(value: 'negociacao', child: Text('Em Negociação')),
                  DropdownMenuItem(value: 'ganho', child: Text('Ganho')),
                  DropdownMenuItem(value: 'perdido', child: Text('Perdido')),
                ],
                onChanged: (v) => setState(() => _status = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _origem,
                decoration: const InputDecoration(
                  labelText: 'Origem',
                  prefixIcon: Icon(Icons.source),
                ),
                items: const [
                  DropdownMenuItem(value: 'site', child: Text('Site')),
                  DropdownMenuItem(value: 'indicacao', child: Text('Indicação')),
                  DropdownMenuItem(value: 'evento', child: Text('Evento')),
                  DropdownMenuItem(value: 'outbound', child: Text('Prospecção')),
                ],
                onChanged: (v) => setState(() => _origem = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(
                  labelText: 'Valor Estimado (R\$)',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _observacoesController,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.lead == null ? 'CRIAR LEAD' : 'ATUALIZAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

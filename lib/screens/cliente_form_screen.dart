import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../services/database_service.dart';

class ClienteFormScreen extends StatefulWidget {
  final Cliente? cliente;

  const ClienteFormScreen({super.key, this.cliente});

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _cnpjController;
  late TextEditingController _telefoneController;
  late TextEditingController _emailController;
  late TextEditingController _enderecoController;
  late TextEditingController _cidadeController;
  late TextEditingController _estadoController;
  String _segmento = 'construcao';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.cliente?.nome);
    _cnpjController = TextEditingController(text: widget.cliente?.cnpj);
    _telefoneController = TextEditingController(text: widget.cliente?.telefone);
    _emailController = TextEditingController(text: widget.cliente?.email);
    _enderecoController = TextEditingController(text: widget.cliente?.endereco);
    _cidadeController = TextEditingController(text: widget.cliente?.cidade);
    _estadoController = TextEditingController(text: widget.cliente?.estado);
    if (widget.cliente != null) {
      _segmento = widget.cliente!.segmento;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cnpjController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _enderecoController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final cliente = Cliente(
      id: widget.cliente?.id,
      nome: _nomeController.text,
      cnpj: _cnpjController.text,
      segmento: _segmento,
      telefone: _telefoneController.text.isEmpty ? null : _telefoneController.text,
      email: _emailController.text.isEmpty ? null : _emailController.text,
      endereco: _enderecoController.text.isEmpty ? null : _enderecoController.text,
      cidade: _cidadeController.text.isEmpty ? null : _cidadeController.text,
      estado: _estadoController.text.isEmpty ? null : _estadoController.text,
    );

    try {
      if (widget.cliente == null) {
        await DatabaseService.instance.createCliente(cliente);
      } else {
        await DatabaseService.instance.updateCliente(cliente);
      }

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.cliente == null
              ? 'Cliente cadastrado!'
              : 'Cliente atualizado!'),
        ),
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
        title: Text(widget.cliente == null ? 'Novo Cliente' : 'Editar Cliente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome/Razão Social *',
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cnpjController,
                decoration: const InputDecoration(
                  labelText: 'CNPJ *',
                  prefixIcon: Icon(Icons.badge),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Segmento *',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Construção'),
                              value: 'construcao',
                              groupValue: _segmento,
                              onChanged: (value) => setState(() => _segmento = value!),
                              activeColor: const Color(0xFFFF6B35),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Agro'),
                              value: 'agro',
                              groupValue: _segmento,
                              onChanged: (value) => setState(() => _segmento = value!),
                              activeColor: const Color(0xFF4CAF50),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(
                  labelText: 'Endereço',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _cidadeController,
                      decoration: const InputDecoration(
                        labelText: 'Cidade',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _estadoController,
                      decoration: const InputDecoration(
                        labelText: 'UF',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.cliente == null ? 'CADASTRAR' : 'ATUALIZAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/plano.dart';
import '../services/plano_service.dart';

class CadastroPlanoScreen extends StatefulWidget {
  final Plano? plano;

  const CadastroPlanoScreen({super.key, this.plano});

  @override
  State<CadastroPlanoScreen> createState() => _CadastroPlanoScreenState();
}

class _CadastroPlanoScreenState extends State<CadastroPlanoScreen> {
  final _formKey = GlobalKey<FormState>();
  final PlanoService _planoService = PlanoService();

  final _idController = TextEditingController();
  final _nomeController = TextEditingController();
  final _valorController = TextEditingController();

  bool _isLoading = false;
  bool _isEdicao = false;

  @override
  void initState() {
    super.initState();
    if (widget.plano != null) {
      _isEdicao = true;
      _idController.text = widget.plano!.id;
      _nomeController.text = widget.plano!.nome;
      _valorController.text = widget.plano!.valor.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nomeController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _salvarPlano() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final plano = Plano(
        id: _idController.text.toUpperCase(),
        nome: _nomeController.text,
        valor: double.parse(_valorController.text.replaceAll(',', '.')),
      );

      if (_isEdicao) {
        await _planoService.updatePlano(widget.plano!.id, plano);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Plano atualizado com sucesso!')),
          );
        }
      } else {
        await _planoService.createPlano(plano);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Plano cadastrado com sucesso!')),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdicao ? 'Editar Plano' : 'Novo Plano'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card com ícone
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.card_membership,
                        size: 64,
                        color: Colors.teal,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isEdicao ? 'Editar Plano' : 'Cadastrar Novo Plano',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ID do Plano
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'ID do Plano *',
                  hintText: 'Ex: BASICO, INTER, PREMIUM',
                  prefixIcon: const Icon(Icons.badge),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: _isEdicao ? Colors.grey[200] : null,
                ),
                enabled: !_isEdicao,
                textCapitalization: TextCapitalization.characters,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ID é obrigatório';
                  }
                  if (value.length > 10) {
                    return 'ID deve ter no máximo 10 caracteres';
                  }
                  if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value.toUpperCase())) {
                    return 'Use apenas letras maiúsculas e números';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Nome do Plano
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Plano *',
                  hintText: 'Ex: Plano Básico',
                  prefixIcon: Icon(Icons.card_membership),
                  border: OutlineInputBorder(),
                ),
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  if (value.length < 3) {
                    return 'Nome deve ter no mínimo 3 caracteres';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Valor
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(
                  labelText: 'Valor Mensal (R\$) *',
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                  helperText: 'Use ponto ou vírgula para decimais',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+[.,]?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Valor é obrigatório';
                  }
                  final valor = double.tryParse(value.replaceAll(',', '.'));
                  if (valor == null || valor <= 0) {
                    return 'Valor deve ser maior que zero';
                  }
                  if (valor > 999999.99) {
                    return 'Valor muito alto';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Botão Salvar
              ElevatedButton(
                onPressed: _isLoading ? null : _salvarPlano,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        _isEdicao ? 'ATUALIZAR PLANO' : 'CADASTRAR PLANO',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              if (!_isEdicao) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
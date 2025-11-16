import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/medico.dart';
import '../services/medico_service.dart';

class CadastroMedicoScreen extends StatefulWidget {
  final Medico? medico;

  const CadastroMedicoScreen({super.key, this.medico});

  @override
  State<CadastroMedicoScreen> createState() => _CadastroMedicoScreenState();
}

class _CadastroMedicoScreenState extends State<CadastroMedicoScreen> {
  final _formKey = GlobalKey<FormState>();
  final MedicoService _medicoService = MedicoService();

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _crmController = TextEditingController();
  final _dataNascimentoController = TextEditingController();

  int _planoSelecionado = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.medico != null) {
      _nomeController.text = widget.medico!.nome;
      _cpfController.text = widget.medico!.cpf;
      _crmController.text = widget.medico!.crm;
      _dataNascimentoController.text = widget.medico!.dataNascimento;
      _planoSelecionado = widget.medico!.plano;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _crmController.dispose();
    _dataNascimentoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dataNascimentoController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _salvarMedico() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final medico = Medico(
      id: widget.medico?.id,
      nome: _nomeController.text,
      cpf: _cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      crm: _crmController.text,
      dataNascimento: _dataNascimentoController.text,
      plano: _planoSelecionado,
    );

    try {
      if (widget.medico == null) {
        await _medicoService.createMedico(medico);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Médico cadastrado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        await _medicoService.updateMedico(widget.medico!.id!, medico);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Médico atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medico == null ? 'Cadastrar Médico' : 'Editar Médico'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Nome
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome Completo',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o nome';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // CPF
            TextFormField(
              controller: _cpfController,
              decoration: const InputDecoration(
                labelText: 'CPF',
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(),
                hintText: '000.000.000-00',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
                _CpfInputFormatter(),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o CPF';
                }
                final cpfNumeros = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (cpfNumeros.length != 11) {
                  return 'CPF deve ter 11 dígitos';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // CRM
            TextFormField(
              controller: _crmController,
              decoration: const InputDecoration(
                labelText: 'CRM',
                prefixIcon: Icon(Icons.medical_services),
                border: OutlineInputBorder(),
                hintText: '123456-SP',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o CRM';
                }
                return null;
              },
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 16),

            // Data de Nascimento
            TextFormField(
              controller: _dataNascimentoController,
              decoration: const InputDecoration(
                labelText: 'Data de Nascimento',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
                hintText: 'AAAA-MM-DD',
              ),
              readOnly: true,
              onTap: _selecionarData,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, selecione a data de nascimento';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Plano
            const Text(
              'Selecione o Plano',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            _buildPlanoOption(1, 'Plano 1 - Básico', Colors.blue),
            _buildPlanoOption(2, 'Plano 2 - Intermediário', Colors.orange),
            _buildPlanoOption(3, 'Plano 3 - Premium', Colors.purple),

            const SizedBox(height: 32),

            // Botão Salvar
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _salvarMedico,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        widget.medico == null ? 'CADASTRAR' : 'ATUALIZAR',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanoOption(int plano, String titulo, Color cor) {
    final isSelected = _planoSelecionado == plano;
    return GestureDetector(
      onTap: () {
        setState(() {
          _planoSelecionado = plano;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? cor.withOpacity(0.1) : Colors.grey[100],
          border: Border.all(
            color: isSelected ? cor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? cor : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              titulo,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? cor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Formatador de CPF
class _CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 2 || i == 5) {
        buffer.write('.');
      } else if (i == 8) {
        buffer.write('-');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

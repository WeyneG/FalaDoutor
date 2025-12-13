import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/medico.dart';
import '../models/plano.dart';
import '../services/medico_service.dart';
import '../services/plano_service.dart';

class CadastroMedicoScreen extends StatefulWidget {
  final Medico? medico;

  const CadastroMedicoScreen({super.key, this.medico});

  @override
  State<CadastroMedicoScreen> createState() => _CadastroMedicoScreenState();
}

class _CadastroMedicoScreenState extends State<CadastroMedicoScreen> {
  final _formKey = GlobalKey<FormState>();
  final MedicoService _medicoService = MedicoService();
  final PlanoService _planoService = PlanoService();

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _crmController = TextEditingController();
  final _dataNascimentoController = TextEditingController();

  List<String> _planosSelecionados = [];
  List<Plano> _planos = [];
  bool _isLoading = false;
  bool _isLoadingPlanos = true;

  @override
  void initState() {
    super.initState();
    _carregarPlanos();
    if (widget.medico != null) {
      _nomeController.text = widget.medico!.nome;
      _cpfController.text = widget.medico!.cpf;
      _crmController.text = widget.medico!.crm;
      _dataNascimentoController.text = widget.medico!.dataNascimento;
      _planosSelecionados = List<String>.from(widget.medico!.planoIds);
    }
  }

  Future<void> _carregarPlanos() async {
    try {
      final planos = await _planoService.getPlanos();
      setState(() {
        // Ordena planos do mais barato para o mais caro
        _planos = planos..sort((a, b) => a.valor.compareTo(b.valor));
        _isLoadingPlanos = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPlanos = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar planos: $e')),
        );
      }
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
      planoIds: _planosSelecionados,
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

            // Planos (multi-seleção)
            const Text(
              'Planos *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _isLoadingPlanos
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _planos.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Nenhum plano disponível'),
                          )
                        : Column(
                            children: _planos.map((plano) {
                              final isSelected = _planosSelecionados.contains(plano.id);
                              return CheckboxListTile(
                                title: Text(plano.nome),
                                subtitle: Text(plano.valorFormatado),
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      _planosSelecionados.add(plano.id);
                                    } else {
                                      _planosSelecionados.remove(plano.id);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                  ),

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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/paciente.dart';
import '../models/plano.dart';
import '../services/paciente_service.dart';
import '../services/plano_service.dart';

class CadastroPacienteScreen extends StatefulWidget {
  final Paciente? paciente;

  const CadastroPacienteScreen({super.key, this.paciente});

  @override
  State<CadastroPacienteScreen> createState() => _CadastroPacienteScreenState();
}

class _CadastroPacienteScreenState extends State<CadastroPacienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final PacienteService _pacienteService = PacienteService();
  final PlanoService _planoService = PlanoService();

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dataNascimentoController = TextEditingController();

  String? _planoSelecionado;
  List<Plano> _planos = [];
  bool _isLoading = false;
  bool _isLoadingPlanos = true;

  @override
  void initState() {
    super.initState();
    _carregarPlanos();
    if (widget.paciente != null) {
      _nomeController.text = widget.paciente!.nome;
      _cpfController.text = widget.paciente!.cpf;
      _dataNascimentoController.text = widget.paciente!.dataNascimento;
      _planoSelecionado = widget.paciente!.planoId;
    }
  }

  Future<void> _carregarPlanos() async {
    try {
      final planos = await _planoService.getPlanos();
      setState(() {
        // Ordena planos do mais barato para o mais caro
        _planos = planos..sort((a, b) => a.valor.compareTo(b.valor));
        _isLoadingPlanos = false;
        if (_planoSelecionado == null && planos.isNotEmpty) {
          _planoSelecionado = planos.first.id;
        }
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
    _dataNascimentoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dataNascimentoController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _salvarPaciente() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final paciente = Paciente(
      id: widget.paciente?.id,
      nome: _nomeController.text,
      cpf: _cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      dataNascimento: _dataNascimentoController.text,
      planoId: _planoSelecionado!,
    );

    try {
      if (widget.paciente == null) {
        await _pacienteService.createPaciente(paciente);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Paciente cadastrado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        await _pacienteService.updatePaciente(widget.paciente!.id!, paciente);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Paciente atualizado com sucesso!'),
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
        title: Text(widget.paciente == null ? 'Cadastrar Paciente' : 'Editar Paciente'),
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
            if (_isLoadingPlanos)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              DropdownButtonFormField<String>(
                value: _planoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Plano',
                  prefixIcon: Icon(Icons.medical_services),
                  border: OutlineInputBorder(),
                ),
                items: _planos.map((Plano plano) {
                  return DropdownMenuItem<String>(
                    value: plano.id,
                    child: Text('${plano.nome} - ${plano.valorFormatado}'),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _planoSelecionado = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione um plano';
                  }
                  return null;
                },
              ),

            const SizedBox(height: 32),

            // Botão Salvar
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _salvarPaciente,
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
                        widget.paciente == null ? 'CADASTRAR' : 'ATUALIZAR',
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/consulta.dart';
import '../models/paciente.dart';
import '../models/medico.dart';
import '../services/consulta_service.dart';
import '../services/paciente_service.dart';

class CadastroConsultaScreen extends StatefulWidget {
  final Consulta? consulta;

  const CadastroConsultaScreen({super.key, this.consulta});

  @override
  State<CadastroConsultaScreen> createState() => _CadastroConsultaScreenState();
}

class _CadastroConsultaScreenState extends State<CadastroConsultaScreen> {
  final _formKey = GlobalKey<FormState>();
  final ConsultaService _consultaService = ConsultaService();
  final PacienteService _pacienteService = PacienteService();

  final _dataController = TextEditingController();
  final _horaController = TextEditingController();
  final _observacoesController = TextEditingController();

  int? _pacienteSelecionado;
  int? _medicoSelecionado;
  String _statusSelecionado = 'agendada';
  
  List<Paciente> _pacientes = [];
  List<Medico> _medicosDisponiveis = [];
  
  bool _isLoading = false;
  bool _isLoadingPacientes = true;
  bool _isLoadingMedicos = false;
  
  double? _valorConsulta;
  String? _planoNome;

  @override
  void initState() {
    super.initState();
    _carregarPacientes();
    
    if (widget.consulta != null) {
      _pacienteSelecionado = widget.consulta!.pacienteId;
      _medicoSelecionado = widget.consulta!.medicoId;
      _statusSelecionado = widget.consulta!.status;
      
      final data = widget.consulta!.dataConsultaDateTime;
      if (data != null) {
        _dataController.text = DateFormat('yyyy-MM-dd').format(data);
        _horaController.text = DateFormat('HH:mm').format(data);
      }
      
      _observacoesController.text = widget.consulta!.observacoes ?? '';
      _valorConsulta = widget.consulta!.valor;
    }
  }

  @override
  void dispose() {
    _dataController.dispose();
    _horaController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _carregarPacientes() async {
    try {
      final pacientes = await _pacienteService.getPacientes();
      setState(() {
        _pacientes = pacientes;
        _isLoadingPacientes = false;
      });
      
      // Se estiver editando, carregar médicos
      if (widget.consulta != null && _pacienteSelecionado != null) {
        _carregarMedicosDisponiveis(_pacienteSelecionado!);
      }
    } catch (e) {
      setState(() {
        _isLoadingPacientes = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar pacientes: $e')),
        );
      }
    }
  }

  Future<void> _carregarMedicosDisponiveis(int pacienteId) async {
    setState(() {
      _isLoadingMedicos = true;
      _medicoSelecionado = null;
      _medicosDisponiveis = [];
      _valorConsulta = null;
      _planoNome = null;
    });

    try {
      final medicos = await _consultaService.getMedicosDisponiveis(pacienteId);
      
      // Buscar valor do plano do paciente
      final paciente = _pacientes.firstWhere((p) => p.id == pacienteId);
      
      setState(() {
        _medicosDisponiveis = medicos;
        _isLoadingMedicos = false;
        _valorConsulta = paciente.planoValor;
        _planoNome = paciente.planoNome;
      });
    } catch (e) {
      setState(() {
        _isLoadingMedicos = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar médicos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _dataController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selecionarHora() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _horaController.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _salvarConsulta() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_pacienteSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um paciente'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_medicoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione um médico'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dataConsulta = '${_dataController.text}T${_horaController.text}:00';
      
      final consulta = Consulta(
        id: widget.consulta?.id,
        pacienteId: _pacienteSelecionado!,
        medicoId: _medicoSelecionado!,
        dataConsulta: dataConsulta,
        valor: _valorConsulta ?? 0,
        status: _statusSelecionado,
        observacoes: _observacoesController.text.isEmpty 
            ? null 
            : _observacoesController.text,
      );

      if (widget.consulta == null) {
        await _consultaService.createConsulta(consulta);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Consulta agendada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        await _consultaService.updateConsulta(widget.consulta!.id!, consulta);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Consulta atualizada com sucesso!'),
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
        title: Text(widget.consulta == null ? 'Agendar Consulta' : 'Editar Consulta'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Paciente
            _isLoadingPacientes
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<int>(
                    value: _pacienteSelecionado,
                    decoration: const InputDecoration(
                      labelText: 'Paciente *',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    items: _pacientes.map((paciente) {
                      return DropdownMenuItem<int>(
                        value: paciente.id,
                        child: Text('${paciente.nome} - ${paciente.planoNome}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _pacienteSelecionado = value;
                      });
                      if (value != null) {
                        _carregarMedicosDisponiveis(value);
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione um paciente';
                      }
                      return null;
                    },
                  ),
            const SizedBox(height: 16),

            // Informações do Plano
            if (_planoNome != null && _valorConsulta != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Plano: $_planoNome',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Valor da consulta: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(_valorConsulta)}',
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (_planoNome != null) const SizedBox(height: 16),

            // Médico
            _isLoadingMedicos
                ? const Center(child: CircularProgressIndicator())
                : _medicosDisponiveis.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Nenhum médico atende este plano',
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                          ],
                        ),
                      )
                    : DropdownButtonFormField<int>(
                        value: _medicoSelecionado,
                        decoration: const InputDecoration(
                          labelText: 'Médico *',
                          prefixIcon: Icon(Icons.medical_services),
                          border: OutlineInputBorder(),
                        ),
                        items: _medicosDisponiveis.map((medico) {
                          return DropdownMenuItem<int>(
                            value: medico.id,
                            child: Text('${medico.nome} - CRM: ${medico.crm}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _medicoSelecionado = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione um médico';
                          }
                          return null;
                        },
                      ),
            const SizedBox(height: 16),

            // Data
            TextFormField(
              controller: _dataController,
              decoration: const InputDecoration(
                labelText: 'Data da Consulta *',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
                hintText: 'AAAA-MM-DD',
              ),
              readOnly: true,
              onTap: _selecionarData,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecione a data da consulta';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Hora
            TextFormField(
              controller: _horaController,
              decoration: const InputDecoration(
                labelText: 'Hora da Consulta *',
                prefixIcon: Icon(Icons.access_time),
                border: OutlineInputBorder(),
                hintText: 'HH:MM',
              ),
              readOnly: true,
              onTap: _selecionarHora,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecione a hora da consulta';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Status
            DropdownButtonFormField<String>(
              value: _statusSelecionado,
              decoration: const InputDecoration(
                labelText: 'Status',
                prefixIcon: Icon(Icons.info),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'agendada', child: Text('Agendada')),
                DropdownMenuItem(value: 'realizada', child: Text('Realizada')),
                DropdownMenuItem(value: 'cancelada', child: Text('Cancelada')),
              ],
              onChanged: (value) {
                setState(() {
                  _statusSelecionado = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Observações
            TextFormField(
              controller: _observacoesController,
              decoration: const InputDecoration(
                labelText: 'Observações',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // Botão Salvar
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _salvarConsulta,
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
                        widget.consulta == null ? 'AGENDAR' : 'ATUALIZAR',
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

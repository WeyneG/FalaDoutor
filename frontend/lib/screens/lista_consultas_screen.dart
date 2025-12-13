import 'package:flutter/material.dart';
import '../models/consulta.dart';
import '../services/consulta_service.dart';
import 'cadastro_consulta_screen.dart';
import 'detalhes_consulta_screen.dart';

class ListaConsultasScreen extends StatefulWidget {
  const ListaConsultasScreen({super.key});

  @override
  State<ListaConsultasScreen> createState() => _ListaConsultasScreenState();
}

class _ListaConsultasScreenState extends State<ListaConsultasScreen> {
  final ConsultaService _consultaService = ConsultaService();
  List<Consulta> _consultas = [];
  List<Consulta> _consultasFiltradas = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _filtroStatus = 'todas';

  @override
  void initState() {
    super.initState();
    _carregarConsultas();
  }

  Future<void> _carregarConsultas() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final consultas = await _consultaService.getConsultas();
      setState(() {
        _consultas = consultas;
        _aplicarFiltro();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _aplicarFiltro() {
    if (_filtroStatus == 'todas') {
      _consultasFiltradas = _consultas;
    } else {
      _consultasFiltradas = _consultas
          .where((c) => c.status == _filtroStatus)
          .toList();
    }
  }

  Future<void> _deletarConsulta(int id, String pacienteNome) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir a consulta de $pacienteNome?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await _consultaService.deleteConsulta(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Consulta excluída com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          _carregarConsultas();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Color _getCorStatus(String status) {
    switch (status) {
      case 'agendada':
        return Colors.blue;
      case 'realizada':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultas'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filtroStatus = value;
                _aplicarFiltro();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'todas',
                child: Text('Todas'),
              ),
              const PopupMenuItem(
                value: 'agendada',
                child: Text('Agendadas'),
              ),
              const PopupMenuItem(
                value: 'realizada',
                child: Text('Realizadas'),
              ),
              const PopupMenuItem(
                value: 'cancelada',
                child: Text('Canceladas'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarConsultas,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CadastroConsultaScreen(),
            ),
          );
          if (resultado == true) {
            _carregarConsultas();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Consulta'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando consultas...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Erro ao carregar consultas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _carregarConsultas,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_consultasFiltradas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              _filtroStatus == 'todas'
                  ? 'Nenhuma consulta cadastrada'
                  : 'Nenhuma consulta ${_filtroStatus}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Clique no botão abaixo para adicionar',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarConsultas,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _consultasFiltradas.length,
        itemBuilder: (context, index) {
          final consulta = _consultasFiltradas[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: _getCorStatus(consulta.status),
                child: Icon(
                  consulta.status == 'agendada'
                      ? Icons.schedule
                      : consulta.status == 'realizada'
                          ? Icons.check_circle
                          : Icons.cancel,
                  color: Colors.white,
                ),
              ),
              title: Text(
                consulta.pacienteNome ?? 'Paciente',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.medical_services, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          consulta.medicoNome ?? 'Médico',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(consulta.dataHoraFormatada),
                      const SizedBox(width: 16),
                      const Icon(Icons.attach_money, size: 14, color: Colors.grey),
                      Text(consulta.valorFormatado),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getCorStatus(consulta.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      consulta.statusTexto,
                      style: TextStyle(
                        fontSize: 11,
                        color: _getCorStatus(consulta.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.blue),
                    onPressed: () async {
                      final resultado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesConsultaScreen(
                            consulta: consulta,
                            onUpdate: _carregarConsultas,
                          ),
                        ),
                      );
                      if (resultado == true) {
                        _carregarConsultas();
                      }
                    },
                    tooltip: 'Ver detalhes',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletarConsulta(
                      consulta.id!,
                      consulta.pacienteNome ?? 'Paciente',
                    ),
                    tooltip: 'Excluir',
                  ),
                ],
              ),
              onTap: () async {
                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalhesConsultaScreen(
                      consulta: consulta,
                      onUpdate: _carregarConsultas,
                    ),
                  ),
                );
                if (resultado == true) {
                  _carregarConsultas();
                }
              },
            ),
          );
        },
      ),
    );
  }
}

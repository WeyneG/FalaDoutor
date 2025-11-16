import 'package:flutter/material.dart';
import '../models/medico.dart';
import '../services/medico_service.dart';
import 'cadastro_medico_screen.dart';
import 'detalhes_medico_screen.dart';

class ListaMedicosScreen extends StatefulWidget {
  const ListaMedicosScreen({super.key});

  @override
  State<ListaMedicosScreen> createState() => _ListaMedicosScreenState();
}

class _ListaMedicosScreenState extends State<ListaMedicosScreen> {
  final MedicoService _medicoService = MedicoService();
  List<Medico> _medicos = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarMedicos();
  }

  Future<void> _carregarMedicos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final medicos = await _medicoService.getMedicos();
      setState(() {
        _medicos = medicos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deletarMedico(int id, String nome) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir o médico $nome?'),
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
        await _medicoService.deleteMedico(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Médico excluído com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        _carregarMedicos();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir: $e'),
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
        title: const Text('Médicos Cadastrados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarMedicos,
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
              builder: (context) => const CadastroMedicoScreen(),
            ),
          );
          if (resultado == true) {
            _carregarMedicos();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo Médico'),
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
            Text('Carregando médicos...'),
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
                'Erro ao carregar médicos',
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
                onPressed: _carregarMedicos,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_medicos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum médico cadastrado',
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
      onRefresh: _carregarMedicos,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _medicos.length,
        itemBuilder: (context, index) {
          final medico = _medicos[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor: _getCorPlano(medico.plano),
                child: Text(
                  medico.nome.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                medico.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('CRM: ${medico.crm}'),
                  Text('CPF: ${medico.cpfFormatado}'),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getCorPlano(medico.plano).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      medico.nomePlano,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getCorPlano(medico.plano),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesMedicoScreen(
                            medico: medico,
                            onUpdate: _carregarMedicos,
                          ),
                        ),
                      );
                    },
                    tooltip: 'Ver detalhes',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletarMedico(medico.id!, medico.nome),
                    tooltip: 'Excluir',
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalhesMedicoScreen(
                      medico: medico,
                      onUpdate: _carregarMedicos,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Color _getCorPlano(int plano) {
    switch (plano) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

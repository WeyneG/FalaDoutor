import 'package:flutter/material.dart';
import '../models/plano.dart';
import '../services/plano_service.dart';
import 'cadastro_plano_screen.dart';
import 'detalhes_plano_screen.dart';

class ListaPlanosScreen extends StatefulWidget {
  const ListaPlanosScreen({super.key});

  @override
  State<ListaPlanosScreen> createState() => _ListaPlanosScreenState();
}

class _ListaPlanosScreenState extends State<ListaPlanosScreen> {
  final PlanoService _planoService = PlanoService();
  List<Plano> _planos = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarPlanos();
  }

  Future<void> _carregarPlanos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final planos = await _planoService.getPlanos();
      setState(() {
        _planos = planos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deletarPlano(String id, String nome) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir o plano "$nome"?'),
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
        await _planoService.deletePlano(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Plano excluído com sucesso!')),
          );
          _carregarPlanos();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir: $e')),
          );
        }
      }
    }
  }

  Color _getCorPlano(String id) {
    // Gera cor dinâmica baseada no hash do ID
    // Garante que cada ID sempre tenha a mesma cor
    int hash = id.hashCode;
    
    // Usa o hash para gerar matiz (0-360 graus)
    double hue = (hash % 360).toDouble();
    
    // Converte HSL para RGB com saturação e luminosidade ajustadas
    // Saturação 0.65 = cores vibrantes mas não muito saturadas
    // Luminosidade 0.5 = cores médias (nem muito claras, nem escuras)
    return HSLColor.fromAHSL(1.0, hue, 0.65, 0.5).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planos Cadastrados'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarPlanos,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CadastroPlanoScreen(),
            ),
          );
          if (resultado == true) {
            _carregarPlanos();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo Plano'),
        backgroundColor: Colors.teal,
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
            Text('Carregando planos...'),
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
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Erro ao carregar planos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _carregarPlanos,
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_planos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.card_membership, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('Nenhum plano cadastrado'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarPlanos,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _planos.length,
        itemBuilder: (context, index) {
          final plano = _planos[index];
          final cor = _getCorPlano(plano.id);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: cor,
                child: const Icon(
                  Icons.card_membership,
                  color: Colors.white,
                ),
              ),
              title: Text(
                plano.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('ID: ${plano.id}'),
                  const SizedBox(height: 4),
                  Text(
                    plano.valorFormatado,
                    style: TextStyle(
                      color: cor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    color: Colors.blue,
                    onPressed: () async {
                      final resultado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesPlanoScreen(
                            plano: plano,
                            onUpdate: _carregarPlanos,
                          ),
                        ),
                      );
                      if (resultado == true) {
                        _carregarPlanos();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () => _deletarPlano(plano.id, plano.nome),
                  ),
                ],
              ),
              onTap: () async {
                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalhesPlanoScreen(
                      plano: plano,
                      onUpdate: _carregarPlanos,
                    ),
                  ),
                );
                if (resultado == true) {
                  _carregarPlanos();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
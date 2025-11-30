import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/paciente.dart';
import 'cadastro_paciente_screen.dart';

class DetalhesPacienteScreen extends StatelessWidget {
  final Paciente paciente;
  final VoidCallback onUpdate;

  const DetalhesPacienteScreen({
    super.key,
    required this.paciente,
    required this.onUpdate,
  });

  String _formatarData(String data) {
    try {
      final date = DateTime.parse(data);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return data;
    }
  }

  Color _getCorPlano(String planoId) {
    // Gera cor dinâmica baseada no hash do ID do plano
    int hash = planoId.hashCode;
    double hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.65, 0.5).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Paciente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final resultado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CadastroPacienteScreen(paciente: paciente),
                ),
              );
              if (resultado == true) {
                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              }
            },
            tooltip: 'Editar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header com Avatar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _getCorPlano(paciente.planoId),
                    _getCorPlano(paciente.planoId).withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      paciente.nome.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: _getCorPlano(paciente.planoId),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    paciente.nome,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      paciente.nomePlano,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Informações
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.badge,
                    titulo: 'CPF',
                    valor: paciente.cpfFormatado,
                    cor: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.cake,
                    titulo: 'Data de Nascimento',
                    valor: _formatarData(paciente.dataNascimento),
                    cor: Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.calendar_today,
                    titulo: 'Cadastrado em',
                    valor: paciente.createdAt != null
                        ? _formatarData(paciente.createdAt!)
                        : 'N/A',
                    cor: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String titulo,
    required String valor,
    required Color cor,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: cor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    valor,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

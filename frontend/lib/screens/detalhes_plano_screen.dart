import 'package:flutter/material.dart';
import '../models/plano.dart';
import 'cadastro_plano_screen.dart';

class DetalhesPlanoScreen extends StatelessWidget {
  final Plano plano;
  final VoidCallback onUpdate;

  const DetalhesPlanoScreen({
    super.key,
    required this.plano,
    required this.onUpdate,
  });

  Color _getCorPlano() {
    // Gera cor dinâmica baseada no hash do ID
    int hash = plano.id.hashCode;
    double hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.65, 0.5).toColor();
  }

  IconData _getIconePlano() {
    switch (plano.id) {
      case 'BASICO':
        return Icons.star_outline;
      case 'INTER':
        return Icons.star_half;
      case 'PREMIUM':
        return Icons.star;
      default:
        return Icons.card_membership;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cor = _getCorPlano();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Plano'),
        backgroundColor: cor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final resultado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CadastroPlanoScreen(plano: plano),
                ),
              );
              if (resultado == true) {
                onUpdate();
                Navigator.pop(context, true);
              }
            },
            tooltip: 'Editar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header com cor do plano
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    cor,
                    cor.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _getIconePlano(),
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    plano.nome,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      plano.id,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Card de Valor
                  _buildInfoCard(
                    icon: Icons.attach_money,
                    titulo: 'Valor Mensal',
                    valor: plano.valorFormatado,
                    cor: cor,
                  ),

                  const SizedBox(height: 16),

                  // Card de ID
                  _buildInfoCard(
                    icon: Icons.badge,
                    titulo: 'Identificador',
                    valor: plano.id,
                    cor: cor,
                  ),

                  const SizedBox(height: 16),

                  // Card de Nome
                  _buildInfoCard(
                    icon: Icons.card_membership,
                    titulo: 'Nome do Plano',
                    valor: plano.nome,
                    cor: cor,
                  ),

                  const SizedBox(height: 24),

                  // Informações adicionais
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: cor),
                              const SizedBox(width: 8),
                              const Text(
                                'Informações',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          _buildInfoRow('Tipo de Plano:', plano.id),
                          _buildInfoRow('Nome Completo:', plano.nome),
                          _buildInfoRow('Valor:', plano.valorFormatado),
                        ],
                      ),
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

  Widget _buildInfoCard({
    required IconData icon,
    required String titulo,
    required String valor,
    required Color cor,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    valor,
                    style: const TextStyle(
                      fontSize: 20,
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
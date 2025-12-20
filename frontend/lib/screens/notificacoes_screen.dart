import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/notificacao_service.dart';
import '../models/consulta.dart';

class NotificacoesScreen extends StatefulWidget {
  const NotificacoesScreen({super.key});

  @override
  State<NotificacoesScreen> createState() => _NotificacoesScreenState();
}

class _NotificacoesScreenState extends State<NotificacoesScreen> {
  List<Consulta> _consultas = [];
  Map<String, dynamic> _estatisticas = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final resultConsultas = await NotificacaoService.getConsultasHoje();
      final estatisticas = await NotificacaoService.getEstatisticasDia();

      setState(() {
        _consultas = resultConsultas['consultas'] as List<Consulta>;
        _estatisticas = estatisticas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Color _getUrgenciaColor(Consulta consulta) {
    final minutosRestantes = consulta.minutosRestantes ?? 999;
    
    if (minutosRestantes < 0) {
      return Colors.red; // Atrasada
    } else if (minutosRestantes <= 30) {
      return Colors.orange; // Próxima
    } else {
      return Colors.green; // Normal
    }
  }

  String _getUrgenciaTexto(Consulta consulta) {
    final minutosRestantes = consulta.minutosRestantes ?? 999;
    
    if (minutosRestantes < 0) {
      return 'ATRASADA';
    } else if (minutosRestantes <= 30) {
      return 'PRÓXIMA';
    } else {
      return 'AGENDADA';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultas de Hoje'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _carregarDados,
                        child: const Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _carregarDados,
                  child: _consultas.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 100),
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.event_available,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Nenhuma consulta agendada para hoje',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            // Card de Estatísticas
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Resumo do Dia',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildStatItem(
                                        'Total',
                                        '${_estatisticas['total'] ?? 0}',
                                        Icons.event,
                                      ),
                                      _buildStatItem(
                                        'Agendadas',
                                        '${_estatisticas['agendadas'] ?? 0}',
                                        Icons.schedule,
                                      ),
                                      _buildStatItem(
                                        'Realizadas',
                                        '${_estatisticas['realizadas'] ?? 0}',
                                        Icons.check_circle,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.attach_money,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Total: R\$ ${(_estatisticas['valor_total'] ?? 0).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Lista de Consultas
                            const Text(
                              'Consultas Agendadas',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2196F3),
                              ),
                            ),
                            const SizedBox(height: 12),

                            ..._consultas.map((consulta) => _buildConsultaCard(consulta)),
                          ],
                        ),
                ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildConsultaCard(Consulta consulta) {
    final urgenciaColor = _getUrgenciaColor(consulta);
    final urgenciaTexto = _getUrgenciaTexto(consulta);
    final dataFormatada = DateFormat('dd/MM/yyyy HH:mm')
        .format(DateTime.parse(consulta.dataConsulta));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: urgenciaColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: urgenciaColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.circle, color: urgenciaColor, size: 12),
                    const SizedBox(width: 8),
                    Text(
                      urgenciaTexto,
                      style: TextStyle(
                        color: urgenciaColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  dataFormatada,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Conteúdo
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, size: 20, color: Color(0xFF2196F3)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        consulta.pacienteNome ?? 'Paciente',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.medical_services, size: 20, color: Color(0xFF2196F3)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Dr(a). ${consulta.medicoNome ?? 'Médico'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.card_membership, size: 20, color: Color(0xFF2196F3)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        consulta.planoNome ?? 'Plano',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.attach_money,
                        size: 16,
                        color: Color(0xFF4CAF50),
                      ),
                      Text(
                        'R\$ ${consulta.valor}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

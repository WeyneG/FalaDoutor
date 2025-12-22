import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/relatorio_service.dart';

class RelatorioConsultasScreen extends StatefulWidget {
  const RelatorioConsultasScreen({super.key});

  @override
  State<RelatorioConsultasScreen> createState() => _RelatorioConsultasScreenState();
}

class _RelatorioConsultasScreenState extends State<RelatorioConsultasScreen> {
  Map<String, dynamic>? _relatorio;
  bool _isLoading = true;
  String _tipoGrafico = 'data'; // 'data', 'medico', 'plano'

  @override
  void initState() {
    super.initState();
    _carregarRelatorio();
  }

  Future<void> _carregarRelatorio() async {
    setState(() => _isLoading = true);
    try {
      final relatorio = await RelatorioService.getRelatorioConsultas();
      setState(() {
        _relatorio = relatorio;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar relatório: $e')),
        );
      }
    }
  }

  List<Color> _getColors() {
    return [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.cyan,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Consultas'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarRelatorio,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _relatorio == null
              ? const Center(child: Text('Erro ao carregar dados'))
              : RefreshIndicator(
                  onRefresh: _carregarRelatorio,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTotalCard(),
                        const SizedBox(height: 24),
                        _buildSeletorTipoGrafico(),
                        const SizedBox(height: 16),
                        _buildGraficoCard(),
                        const SizedBox(height: 24),
                        _buildLegendaCard(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildTotalCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Total de Consultas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${_relatorio!['totalConsultas']}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeletorTipoGrafico() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Visualizar por:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildBotaoTipo('data', 'Data', Icons.calendar_today),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildBotaoTipo('medico', 'Médico', Icons.medical_services),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildBotaoTipo('plano', 'Plano', Icons.card_membership),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotaoTipo(String tipo, String label, IconData icon) {
    final isSelected = _tipoGrafico == tipo;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _tipoGrafico = tipo;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF2196F3) : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildGraficoCard() {
    List dados;
    String titulo;

    switch (_tipoGrafico) {
      case 'data':
        dados = _relatorio!['porData'] as List;
        titulo = 'Consultas por Mês';
        break;
      case 'medico':
        dados = _relatorio!['porMedico'] as List;
        titulo = 'Consultas por Médico';
        break;
      case 'plano':
        dados = _relatorio!['porPlano'] as List;
        titulo = 'Consultas por Plano';
        break;
      default:
        dados = [];
        titulo = '';
    }

    final semPlano = _relatorio!['semPlano'] as int;

    if (dados.isEmpty && semPlano == 0) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text('Nenhum dado disponível para $titulo'),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                  sections: _buildPieChartSections(dados, semPlano),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(List dados, int semPlano) {
    final colors = _getColors();
    final sections = <PieChartSectionData>[];

    for (var i = 0; i < dados.length; i++) {
      final item = dados[i];
      final quantidade = item['quantidade'] as int;
      
      if (quantidade > 0) {
        sections.add(
          PieChartSectionData(
            value: quantidade.toDouble(),
            title: '$quantidade',
            color: colors[i % colors.length],
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }
    }

    if (_tipoGrafico == 'plano' && semPlano > 0) {
      sections.add(
        PieChartSectionData(
          value: semPlano.toDouble(),
          title: '$semPlano',
          color: Colors.grey,
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return sections;
  }

  Widget _buildLegendaCard() {
    List dados;
    String labelKey;

    switch (_tipoGrafico) {
      case 'data':
        dados = _relatorio!['porData'] as List;
        labelKey = 'mes';
        break;
      case 'medico':
        dados = _relatorio!['porMedico'] as List;
        labelKey = 'medico';
        break;
      case 'plano':
        dados = _relatorio!['porPlano'] as List;
        labelKey = 'plano';
        break;
      default:
        dados = [];
        labelKey = '';
    }

    final semPlano = _relatorio!['semPlano'] as int;
    final colors = _getColors();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Legenda',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...dados.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final quantidade = item['quantidade'] as int;
              
              if (quantidade == 0) return const SizedBox.shrink();
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: colors[index % colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${item[labelKey]} ($quantidade consulta${quantidade != 1 ? 's' : ''})',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }),
            if (_tipoGrafico == 'plano' && semPlano > 0) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Sem Plano ($semPlano consulta${semPlano != 1 ? 's' : ''})',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

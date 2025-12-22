import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/relatorio_service.dart';

class RelatorioPacientesScreen extends StatefulWidget {
  const RelatorioPacientesScreen({super.key});

  @override
  State<RelatorioPacientesScreen> createState() => _RelatorioPacientesScreenState();
}

class _RelatorioPacientesScreenState extends State<RelatorioPacientesScreen> {
  Map<String, dynamic>? _relatorio;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarRelatorio();
  }

  Future<void> _carregarRelatorio() async {
    setState(() => _isLoading = true);
    try {
      final relatorio = await RelatorioService.getRelatorioPacientes();
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
        title: const Text('Relatório de Pacientes'),
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
                        _buildGraficoIdadeCard(),
                        const SizedBox(height: 24),
                        _buildLegendaIdadeCard(),
                        const SizedBox(height: 24),
                        _buildGraficoPlanoCard(),
                        const SizedBox(height: 24),
                        _buildLegendaPlanoCard(),
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
            colors: [Color(0xFF4CAF50), Color(0xFF388E3C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Total de Pacientes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${_relatorio!['totalPacientes']}',
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

  Widget _buildGraficoIdadeCard() {
    final porIdade = _relatorio!['porIdade'] as List;

    if (porIdade.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: Text('Nenhum dado disponível para idade'),
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
            const Text(
              'Distribuição por Idade',
              style: TextStyle(
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
                  sections: _buildIdadePieChartSections(porIdade),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildIdadePieChartSections(List porIdade) {
    final colorsIdade = {
      'Jovem': Colors.blue,
      'Adulto': Colors.green,
      'Meia-idade': Colors.orange,
      'Idoso': Colors.red,
    };

    final sections = <PieChartSectionData>[];

    for (var item in porIdade) {
      final faixaEtaria = item['faixaEtaria'] as String;
      final quantidade = item['quantidade'] as int;
      
      if (quantidade > 0) {
        sections.add(
          PieChartSectionData(
            value: quantidade.toDouble(),
            title: '$quantidade',
            color: colorsIdade[faixaEtaria] ?? Colors.grey,
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

    return sections;
  }

  Widget _buildLegendaIdadeCard() {
    final porIdade = _relatorio!['porIdade'] as List;
    final colorsIdade = {
      'Jovem': Colors.blue,
      'Adulto': Colors.green,
      'Meia-idade': Colors.orange,
      'Idoso': Colors.red,
    };

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Legenda - Idade',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...porIdade.map((item) {
              final faixaEtaria = item['faixaEtaria'] as String;
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
                        color: colorsIdade[faixaEtaria] ?? Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '$faixaEtaria ($quantidade paciente${quantidade != 1 ? 's' : ''})',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGraficoPlanoCard() {
    final porPlano = _relatorio!['porPlano'] as List;
    final semPlano = _relatorio!['semPlano'] as int;

    if (porPlano.isEmpty && semPlano == 0) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: Text('Nenhum dado disponível para o gráfico'),
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
            const Text(
              'Distribuição por Plano',
              style: TextStyle(
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
                  sections: _buildPieChartSections(porPlano, semPlano),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
      List porPlano, int semPlano) {
    final colors = _getColors();
    final sections = <PieChartSectionData>[];

    for (var i = 0; i < porPlano.length; i++) {
      final item = porPlano[i];
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

    if (semPlano > 0) {
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

  Widget _buildLegendaPlanoCard() {
    final porPlano = _relatorio!['porPlano'] as List;
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
              'Legenda - Plano',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...porPlano.asMap().entries.map((entry) {
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
                        '${item['plano']} ($quantidade paciente${quantidade != 1 ? 's' : ''})',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }),
            if (semPlano > 0) ...[
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
                        'Sem Plano ($semPlano paciente${semPlano != 1 ? 's' : ''})',
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

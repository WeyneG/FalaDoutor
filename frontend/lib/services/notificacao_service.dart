import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/consulta.dart';

class NotificacaoService {
  static const String baseUrl = 'http://localhost:3000/api/consultas';

  // Buscar consultas de hoje
  static Future<Map<String, dynamic>> getConsultasHoje() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hoje/lista'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'total': data['total'] ?? 0,
          'consultas': (data['consultas'] as List)
              .map((json) => Consulta.fromJson(json))
              .toList(),
        };
      } else {
        throw Exception('Erro ao buscar consultas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar consultas: $e');
    }
  }

  // Buscar estatísticas do dia
  static Future<Map<String, dynamic>> getEstatisticasDia() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hoje/estatisticas'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao buscar estatísticas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar estatísticas: $e');
    }
  }

  // Buscar consultas próximas (próximas 30 minutos)
  static Future<List<Consulta>> getConsultasProximas() async {
    try {
      final result = await getConsultasHoje();
      final consultas = result['consultas'] as List<Consulta>;
      
      return consultas.where((consulta) {
        final minutosRestantes = consulta.minutosRestantes ?? 999;
        return minutosRestantes > 0 && minutosRestantes <= 30;
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar consultas próximas: $e');
    }
  }
}

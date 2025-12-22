import 'dart:convert';
import 'package:http/http.dart' as http;

class RelatorioService {
  static const String baseUrl = 'http://localhost:3000/api/relatorios';

  static Future<Map<String, dynamic>> getRelatorioMedicos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/medicos'));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao buscar relatório de médicos');
      }
    } catch (e) {
      print('Erro no serviço de relatório: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getRelatorioPacientes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pacientes'));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao buscar relatório de pacientes');
      }
    } catch (e) {
      print('Erro no serviço de relatório: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getRelatorioConsultas() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/consultas'));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao buscar relatório de consultas');
      }
    } catch (e) {
      print('Erro no serviço de relatório: $e');
      rethrow;
    }
  }
}

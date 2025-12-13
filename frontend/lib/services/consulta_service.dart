import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/consulta.dart';
import '../models/medico.dart';

class ConsultaService {
  static const String baseUrl = 'http://localhost:3000/api/consultas';

  // Buscar todas as consultas
  Future<List<Consulta>> getConsultas() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Consulta.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar consultas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }

  // Buscar consulta por ID
  Future<Consulta> getConsultaById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return Consulta.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Consulta não encontrada');
      } else {
        throw Exception('Erro ao buscar consulta: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }

  // Buscar médicos disponíveis para um paciente
  Future<List<Medico>> getMedicosDisponiveis(int pacienteId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/paciente/$pacienteId/medicos'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Medico.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Paciente não encontrado');
      } else {
        throw Exception('Erro ao buscar médicos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }

  // Criar nova consulta
  Future<Map<String, dynamic>> createConsulta(Consulta consulta) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(consulta.toJson()),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Erro ao criar consulta');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }

  // Atualizar consulta
  Future<void> updateConsulta(int id, Consulta consulta) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(consulta.toJson()),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Erro ao atualizar consulta');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }

  // Deletar consulta
  Future<void> deleteConsulta(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Erro ao deletar consulta');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }
}

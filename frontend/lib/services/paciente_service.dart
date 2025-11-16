import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/paciente.dart';

class PacienteService {
  static const String baseUrl = 'http://localhost:3000/api';

  // Listar todos os pacientes
  Future<List<Paciente>> getPacientes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pacientes'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Paciente> pacientes = body.map((dynamic item) => Paciente.fromJson(item)).toList();
        return pacientes;
      } else {
        throw Exception('Erro ao carregar pacientes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Criar novo paciente
  Future<bool> createPaciente(Paciente paciente) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pacientes'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(paciente.toJson()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Erro ao cadastrar paciente');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Buscar paciente por ID
  Future<Paciente> getPacienteById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pacientes/$id'));

      if (response.statusCode == 200) {
        return Paciente.fromJson(json.decode(response.body));
      } else {
        throw Exception('Paciente não encontrado');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Atualizar paciente
  Future<bool> updatePaciente(int id, Paciente paciente) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/pacientes/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(paciente.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Erro ao atualizar paciente');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Deletar paciente
  Future<bool> deletePaciente(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/pacientes/$id'));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Erro ao deletar paciente');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Buscar pacientes por plano
  Future<List<Paciente>> getPacientesByPlano(int plano) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pacientes/plano/$plano'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Paciente> pacientes = body.map((dynamic item) => Paciente.fromJson(item)).toList();
        return pacientes;
      } else {
        throw Exception('Erro ao buscar pacientes por plano');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
}

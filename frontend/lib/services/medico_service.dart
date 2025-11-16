import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/medico.dart';

class MedicoService {
  // ALTERE ESTE IP PARA O IP DA SUA MÁQUINA
  // Para descobrir seu IP: cmd -> ipconfig -> IPv4
  // Se estiver usando emulador Android: use 10.0.2.2
  // Se estiver usando dispositivo físico: use o IP da sua máquina (ex: 192.168.1.100)
  // Se estiver usando Chrome/Web: use localhost
  static const String baseUrl = 'http://localhost:3000/api';

  // Listar todos os médicos
  Future<List<Medico>> getMedicos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/medicos'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Medico> medicos = body.map((dynamic item) => Medico.fromJson(item)).toList();
        return medicos;
      } else {
        throw Exception('Erro ao carregar médicos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Criar novo médico
  Future<bool> createMedico(Medico medico) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/medicos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(medico.toJson()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Erro ao cadastrar médico');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Buscar médico por ID
  Future<Medico> getMedicoById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/medicos/$id'));

      if (response.statusCode == 200) {
        return Medico.fromJson(json.decode(response.body));
      } else {
        throw Exception('Médico não encontrado');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Atualizar médico
  Future<bool> updateMedico(int id, Medico medico) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/medicos/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(medico.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Erro ao atualizar médico');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Deletar médico
  Future<bool> deleteMedico(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/medicos/$id'));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Erro ao deletar médico');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Buscar médicos por plano
  Future<List<Medico>> getMedicosByPlano(int plano) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/medicos/plano/$plano'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Medico> medicos = body.map((dynamic item) => Medico.fromJson(item)).toList();
        return medicos;
      } else {
        throw Exception('Erro ao buscar médicos por plano');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
}

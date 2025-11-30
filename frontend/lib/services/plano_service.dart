import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plano.dart';

class PlanoService {
  static const String baseUrl = 'http://localhost:3000/api';

  // Buscar todos os planos
  Future<List<Plano>> getPlanos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/planos'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Plano.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar planos');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }

  // Buscar um plano específico por ID
  Future<Plano> getPlano(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/planos/$id'),
      );

      if (response.statusCode == 200) {
        return Plano.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Plano não encontrado');
      } else {
        throw Exception('Falha ao carregar plano');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }

  // Criar um novo plano
  Future<void> createPlano(Plano plano) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/planos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(plano.toJson()),
      );

      if (response.statusCode != 201) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Erro ao cadastrar plano');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }

  // Atualizar um plano existente
  Future<void> updatePlano(String id, Plano plano) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/planos/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(plano.toJson()),
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Erro ao atualizar plano');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }

  // Deletar um plano
  Future<void> deletePlano(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/planos/$id'),
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Erro ao deletar plano');
      }
    } catch (e) {
      throw Exception('Erro ao conectar com o servidor: $e');
    }
  }
}


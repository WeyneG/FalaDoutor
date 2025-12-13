import 'plano.dart';

class Medico {
  final int? id;
  final String nome;
  final String cpf;
  final String crm;
  final String dataNascimento;
  final List<String> planoIds;
  final List<Plano>? planos;
  final String? createdAt;
  final String? updatedAt;

  Medico({
    this.id,
    required this.nome,
    required this.cpf,
    required this.crm,
    required this.dataNascimento,
    required this.planoIds,
    this.planos,
    this.createdAt,
    this.updatedAt,
  });

  // Converter de JSON para objeto
  factory Medico.fromJson(Map<String, dynamic> json) {
    // Parse plano_ids (pode vir como string separada por vírgula ou como array)
    List<String> planoIdsList = [];
    if (json['planos_ids'] != null) {
      if (json['planos_ids'] is String) {
        // Se vier como string "P1,P2,P3"
        final String idsString = json['planos_ids'];
        planoIdsList = idsString.isNotEmpty ? idsString.split(',') : [];
      } else if (json['planos_ids'] is List) {
        // Se vier como array
        planoIdsList = List<String>.from(json['planos_ids']);
      }
    }

    // Parse planos (array de objetos Plano)
    List<Plano>? planosList;
    if (json['planos'] != null && json['planos'] is List) {
      planosList = (json['planos'] as List)
          .map((planoJson) => Plano.fromJson(planoJson))
          .toList();
    }

    return Medico(
      id: json['id'],
      nome: json['nome'],
      cpf: json['cpf'],
      crm: json['crm'],
      dataNascimento: json['data_nascimento'],
      planoIds: planoIdsList,
      planos: planosList,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Converter de objeto para JSON
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cpf': cpf,
      'crm': crm,
      'data_nascimento': dataNascimento,
      'plano_ids': planoIds,
    };
  }

  // Formatar CPF para exibição
  String get cpfFormatado {
    if (cpf.length == 11) {
      return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
    }
    return cpf;
  }

  // Nome dos planos
  String get nomePlanos {
    if (planos != null && planos!.isNotEmpty) {
      return planos!.map((p) => p.nome).join(', ');
    }
    if (planoIds.isNotEmpty) {
      return planoIds.map((id) => 'Plano $id').join(', ');
    }
    return 'Sem planos';
  }
}

class Medico {
  final int? id;
  final String nome;
  final String cpf;
  final String crm;
  final String dataNascimento;
  final String planoId;
  final String? planoNome;
  final double? planoValor;
  final String? createdAt;
  final String? updatedAt;

  Medico({
    this.id,
    required this.nome,
    required this.cpf,
    required this.crm,
    required this.dataNascimento,
    required this.planoId,
    this.planoNome,
    this.planoValor,
    this.createdAt,
    this.updatedAt,
  });

  // Converter de JSON para objeto
  factory Medico.fromJson(Map<String, dynamic> json) {
    return Medico(
      id: json['id'],
      nome: json['nome'],
      cpf: json['cpf'],
      crm: json['crm'],
      dataNascimento: json['data_nascimento'],
      planoId: json['plano_id'] ?? '',
      planoNome: json['plano_nome'],
      planoValor: json['plano_valor'] != null 
          ? (json['plano_valor'] is String 
              ? double.parse(json['plano_valor']) 
              : (json['plano_valor'] is int 
                  ? (json['plano_valor'] as int).toDouble() 
                  : json['plano_valor'] as double))
          : null,
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
      'plano_id': planoId,
    };
  }

  // Formatar CPF para exibição
  String get cpfFormatado {
    if (cpf.length == 11) {
      return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
    }
    return cpf;
  }

  // Nome do plano
  String get nomePlano {
    return planoNome ?? 'Plano $planoId';
  }
}

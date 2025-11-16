class Paciente {
  final int? id;
  final String nome;
  final String cpf;
  final String dataNascimento;
  final int plano;
  final String? createdAt;
  final String? updatedAt;

  Paciente({
    this.id,
    required this.nome,
    required this.cpf,
    required this.dataNascimento,
    required this.plano,
    this.createdAt,
    this.updatedAt,
  });

  // Converter de JSON para objeto
  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      id: json['id'],
      nome: json['nome'],
      cpf: json['cpf'],
      dataNascimento: json['data_nascimento'],
      plano: json['plano'] is String ? int.parse(json['plano']) : json['plano'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Converter de objeto para JSON
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cpf': cpf,
      'data_nascimento': dataNascimento,
      'plano': plano,
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
    switch (plano) {
      case 1:
        return 'Plano 1 - Básico';
      case 2:
        return 'Plano 2 - Intermediário';
      case 3:
        return 'Plano 3 - Premium';
      default:
        return 'Plano $plano';
    }
  }
}

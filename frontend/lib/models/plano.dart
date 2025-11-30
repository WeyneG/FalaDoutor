import 'package:intl/intl.dart';

class Plano {
  final String id;
  final String nome;
  final double valor;

  Plano({
    required this.id,
    required this.nome,
    required this.valor,
  });

  // Getter para formatar o valor em Real
  String get valorFormatado {
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatador.format(valor);
  }

  // Criar um Plano a partir de um JSON
  factory Plano.fromJson(Map<String, dynamic> json) {
    return Plano(
      id: json['id'],
      nome: json['nome'],
      valor: json['valor'] is String
          ? double.parse(json['valor'])
          : (json['valor'] is int
              ? (json['valor'] as int).toDouble()
              : json['valor'] as double),
    );
  }

  // Converter o Plano para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'valor': valor,
    };
  }
}

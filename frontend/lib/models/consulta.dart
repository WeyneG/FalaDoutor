import 'medico.dart';
import 'paciente.dart';
import 'plano.dart';
import 'package:intl/intl.dart';

class Consulta {
  final int? id;
  final int pacienteId;
  final int medicoId;
  final String dataConsulta;
  final double valor;
  final String status;
  final String? observacoes;
  final String? createdAt;
  final String? updatedAt;
  
  // Dados relacionados
  final String? pacienteNome;
  final String? pacienteCpf;
  final String? medicoNome;
  final String? medicoCrm;
  final String? planoNome;

  Consulta({
    this.id,
    required this.pacienteId,
    required this.medicoId,
    required this.dataConsulta,
    required this.valor,
    required this.status,
    this.observacoes,
    this.createdAt,
    this.updatedAt,
    this.pacienteNome,
    this.pacienteCpf,
    this.medicoNome,
    this.medicoCrm,
    this.planoNome,
  });

  // Converter de JSON para objeto
  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(
      id: json['id'],
      pacienteId: json['paciente_id'],
      medicoId: json['medico_id'],
      dataConsulta: json['data_consulta'],
      valor: json['valor'] is String
          ? double.parse(json['valor'])
          : (json['valor'] is int
              ? (json['valor'] as int).toDouble()
              : json['valor'] as double),
      status: json['status'] ?? 'agendada',
      observacoes: json['observacoes'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      pacienteNome: json['paciente_nome'],
      pacienteCpf: json['paciente_cpf'],
      medicoNome: json['medico_nome'],
      medicoCrm: json['medico_crm'],
      planoNome: json['plano_nome'],
    );
  }

  // Converter de objeto para JSON
  Map<String, dynamic> toJson() {
    return {
      'paciente_id': pacienteId,
      'medico_id': medicoId,
      'data_consulta': dataConsulta,
      'status': status,
      if (observacoes != null) 'observacoes': observacoes,
    };
  }

  // Formatar valor em Real
  String get valorFormatado {
    final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatador.format(valor);
  }

  // Formatar data para exibição
  String get dataFormatada {
    try {
      final date = DateTime.parse(dataConsulta);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dataConsulta;
    }
  }

  // Formatar data e hora para exibição
  String get dataHoraFormatada {
    try {
      final date = DateTime.parse(dataConsulta);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dataConsulta;
    }
  }

  // Formatar hora
  String get horaFormatada {
    try {
      final date = DateTime.parse(dataConsulta);
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return '';
    }
  }

  // Cor do status
  String get statusTexto {
    switch (status) {
      case 'agendada':
        return 'Agendada';
      case 'realizada':
        return 'Realizada';
      case 'cancelada':
        return 'Cancelada';
      default:
        return status;
    }
  }

  // DateTime object
  DateTime? get dataConsultaDateTime {
    try {
      return DateTime.parse(dataConsulta);
    } catch (e) {
      return null;
    }
  }
}

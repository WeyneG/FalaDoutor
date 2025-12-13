const ConsultaModel = require('../models/consultaModel');
const PacienteModel = require('../models/pacienteModel');
const MedicoModel = require('../models/medicoModel');
const PlanoModel = require('../models/planoModel');

class ConsultaController {
  // Listar todas as consultas
  static async getAll(req, res) {
    try {
      const consultas = await ConsultaModel.findAll();
      res.json(consultas);
    } catch (error) {
      console.error('Erro ao buscar consultas:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar consultas',
        details: error.message 
      });
    }
  }

  // Buscar consulta por ID
  static async getById(req, res) {
    try {
      const { id } = req.params;
      const consulta = await ConsultaModel.findById(id);

      if (!consulta) {
        return res.status(404).json({ error: 'Consulta não encontrada' });
      }

      res.json(consulta);
    } catch (error) {
      console.error('Erro ao buscar consulta:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar consulta',
        details: error.message 
      });
    }
  }

  // Buscar médicos disponíveis para um paciente (baseado no plano)
  static async getMedicosByPaciente(req, res) {
    try {
      const { pacienteId } = req.params;

      // Verificar se paciente existe
      const paciente = await PacienteModel.findById(pacienteId);
      if (!paciente) {
        return res.status(404).json({ error: 'Paciente não encontrado' });
      }

      // Buscar médicos que atendem o plano do paciente
      const medicos = await ConsultaModel.findMedicosByPacientePlano(pacienteId);

      res.json(medicos);
    } catch (error) {
      console.error('Erro ao buscar médicos:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar médicos',
        details: error.message 
      });
    }
  }

  // Criar consulta
  static async create(req, res) {
    try {
      const { paciente_id, medico_id, data_consulta, observacoes } = req.body;

      // Validações
      if (!paciente_id || !medico_id || !data_consulta) {
        return res.status(400).json({ 
          error: 'Campos obrigatórios: paciente_id, medico_id, data_consulta' 
        });
      }

      // Verificar se paciente existe
      const paciente = await PacienteModel.findById(paciente_id);
      if (!paciente) {
        return res.status(404).json({ error: 'Paciente não encontrado' });
      }

      // Verificar se médico existe
      const medico = await MedicoModel.findById(medico_id);
      if (!medico) {
        return res.status(404).json({ error: 'Médico não encontrado' });
      }

      // Buscar valor do plano do paciente
      const plano = await PlanoModel.findById(paciente.plano_id);
      if (!plano) {
        return res.status(404).json({ error: 'Plano do paciente não encontrado' });
      }

      // Verificar se médico atende o plano do paciente
      const medicosDisponiveis = await ConsultaModel.findMedicosByPacientePlano(paciente_id);
      const medicoAtendePlano = medicosDisponiveis.some(m => m.id === parseInt(medico_id));
      
      if (!medicoAtendePlano) {
        return res.status(400).json({ 
          error: `O médico ${medico.nome} não atende o plano ${plano.nome}` 
        });
      }

      // Verificar conflito de horário
      const temConflito = await ConsultaModel.checkConflito(medico_id, data_consulta);
      if (temConflito) {
        return res.status(400).json({ 
          error: 'Já existe uma consulta agendada para este médico neste horário' 
        });
      }

      // Criar consulta com valor do plano
      const consultaId = await ConsultaModel.create({
        paciente_id,
        medico_id,
        data_consulta,
        valor: plano.valor,
        status: 'agendada',
        observacoes
      });

      res.status(201).json({ 
        message: 'Consulta agendada com sucesso',
        id: consultaId,
        valor: plano.valor
      });

    } catch (error) {
      console.error('Erro ao criar consulta:', error);
      res.status(500).json({ 
        error: 'Erro ao agendar consulta',
        details: error.message 
      });
    }
  }

  // Atualizar consulta
  static async update(req, res) {
    try {
      const { id } = req.params;
      const { medico_id, data_consulta, status, observacoes } = req.body;

      const consulta = await ConsultaModel.findById(id);
      if (!consulta) {
        return res.status(404).json({ error: 'Consulta não encontrada' });
      }

      // Se mudar médico, verificar se atende o plano
      if (medico_id && medico_id !== consulta.medico_id) {
        const medicosDisponiveis = await ConsultaModel.findMedicosByPacientePlano(consulta.paciente_id);
        const medicoAtendePlano = medicosDisponiveis.some(m => m.id === parseInt(medico_id));
        
        if (!medicoAtendePlano) {
          const medico = await MedicoModel.findById(medico_id);
          return res.status(400).json({ 
            error: `O médico ${medico.nome} não atende este plano` 
          });
        }
      }

      // Verificar conflito de horário (se mudar data ou médico)
      if (data_consulta || medico_id) {
        const novoMedicoId = medico_id || consulta.medico_id;
        const novaData = data_consulta || consulta.data_consulta;
        
        const temConflito = await ConsultaModel.checkConflito(novoMedicoId, novaData, id);
        if (temConflito) {
          return res.status(400).json({ 
            error: 'Já existe uma consulta agendada para este médico neste horário' 
          });
        }
      }

      // Buscar valor do plano (pode ter mudado)
      const paciente = await PacienteModel.findById(consulta.paciente_id);
      const plano = await PlanoModel.findById(paciente.plano_id);

      await ConsultaModel.update(id, {
        medico_id: medico_id || consulta.medico_id,
        data_consulta: data_consulta || consulta.data_consulta,
        valor: plano.valor,
        status: status || consulta.status,
        observacoes: observacoes !== undefined ? observacoes : consulta.observacoes
      });

      res.json({ message: 'Consulta atualizada com sucesso' });

    } catch (error) {
      console.error('Erro ao atualizar consulta:', error);
      res.status(500).json({ 
        error: 'Erro ao atualizar consulta',
        details: error.message 
      });
    }
  }

  // Deletar consulta
  static async delete(req, res) {
    try {
      const { id } = req.params;

      const consulta = await ConsultaModel.findById(id);
      if (!consulta) {
        return res.status(404).json({ error: 'Consulta não encontrada' });
      }

      await ConsultaModel.delete(id);
      res.json({ message: 'Consulta deletada com sucesso' });

    } catch (error) {
      console.error('Erro ao deletar consulta:', error);
      res.status(500).json({ 
        error: 'Erro ao deletar consulta',
        details: error.message 
      });
    }
  }
}

module.exports = ConsultaController;

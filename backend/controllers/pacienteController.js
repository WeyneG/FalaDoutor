const PacienteModel = require('../models/pacienteModel');

// Função helper para formatar data para MySQL (YYYY-MM-DD)
const formatarDataParaMySQL = (data) => {
  if (!data) return null;
  // Se já estiver no formato correto, retorna
  if (/^\d{4}-\d{2}-\d{2}$/.test(data)) {
    return data;
  }
  // Se estiver no formato ISO, extrai apenas a data
  if (data.includes('T')) {
    return data.split('T')[0];
  }
  // Se for um objeto Date
  if (data instanceof Date) {
    return data.toISOString().split('T')[0];
  }
  return data;
};

class PacienteController {

  static async create(req, res) {
    try {
      const { nome, cpf, data_nascimento, plano } = req.body;


      if (!nome || !cpf || !data_nascimento || !plano) {
        return res.status(400).json({ 
          error: 'Todos os campos são obrigatórios: nome, cpf, data_nascimento, plano' 
        });
      }


      if (![1, 2, 3].includes(parseInt(plano))) {
        return res.status(400).json({ 
          error: 'Plano deve ser 1, 2 ou 3' 
        });
      }


      const cpfExistente = await PacienteModel.findByCpf(cpf);
      if (cpfExistente) {
        return res.status(400).json({ 
          error: 'CPF já cadastrado' 
        });
      }

      const dadosPaciente = {
        ...req.body,
        data_nascimento: formatarDataParaMySQL(req.body.data_nascimento)
      };
      const pacienteId = await PacienteModel.create(dadosPaciente);
      
      res.status(201).json({ 
        message: 'Paciente cadastrado com sucesso',
        id: pacienteId 
      });
    } catch (error) {
      console.error('Erro ao criar paciente:', error);
      res.status(500).json({ 
        error: 'Erro ao cadastrar paciente',
        details: error.message 
      });
    }
  }


  static async getAll(req, res) {
    try {
      const pacientes = await PacienteModel.findAll();
      res.json(pacientes);
    } catch (error) {
      console.error('Erro ao buscar pacientes:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar pacientes',
        details: error.message 
      });
    }
  }


  static async getById(req, res) {
    try {
      const { id } = req.params;
      const paciente = await PacienteModel.findById(id);

      if (!paciente) {
        return res.status(404).json({ 
          error: 'Paciente não encontrado' 
        });
      }

      res.json(paciente);
    } catch (error) {
      console.error('Erro ao buscar paciente:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar paciente',
        details: error.message 
      });
    }
  }


  static async getByPlano(req, res) {
    try {
      const { plano } = req.params;

      if (![1, 2, 3].includes(parseInt(plano))) {
        return res.status(400).json({
          error: 'Plano deve ser 1, 2 ou 3'
        });
      }

      const pacientes = await PacienteModel.findByPlano(plano);
      res.json(pacientes);
    } catch (error) {
      console.error('Erro ao buscar pacientes por plano:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar pacientes por plano',
        details: error.message 
      });
    }
  }


  static async update(req, res) {
    try {
      const { id } = req.params;
      const { nome, cpf, data_nascimento, plano } = req.body;


      const pacienteExistente = await PacienteModel.findById(id);
      if (!pacienteExistente) {
        return res.status(404).json({ 
          error: 'Paciente não encontrado' 
        });
      }


      if (!nome || !cpf || !data_nascimento || !plano) {
        return res.status(400).json({ 
          error: 'Todos os campos são obrigatórios: nome, cpf, data_nascimento, plano' 
        });
      }


      if (![1, 2, 3].includes(parseInt(plano))) {
        return res.status(400).json({ 
          error: 'Plano deve ser 1, 2 ou 3' 
        });
      }


      const cpfExistente = await PacienteModel.findByCpf(cpf);
      if (cpfExistente && cpfExistente.id != id) {
        return res.status(400).json({ 
          error: 'CPF já cadastrado para outro paciente' 
        });
      }

      const dadosPaciente = {
        ...req.body,
        data_nascimento: formatarDataParaMySQL(req.body.data_nascimento)
      };
      await PacienteModel.update(id, dadosPaciente);
      
      res.json({ 
        message: 'Paciente atualizado com sucesso' 
      });
    } catch (error) {
      console.error('Erro ao atualizar paciente:', error);
      res.status(500).json({ 
        error: 'Erro ao atualizar paciente',
        details: error.message 
      });
    }
  }


  static async delete(req, res) {
    try {
      const { id } = req.params;


      const paciente = await PacienteModel.findById(id);
      if (!paciente) {
        return res.status(404).json({ 
          error: 'Paciente não encontrado' 
        });
      }

      await PacienteModel.delete(id);
      
      res.json({ 
        message: 'Paciente deletado com sucesso' 
      });
    } catch (error) {
      console.error('Erro ao deletar paciente:', error);
      res.status(500).json({ 
        error: 'Erro ao deletar paciente',
        details: error.message 
      });
    }
  }
}

module.exports = PacienteController;

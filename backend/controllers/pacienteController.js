const PacienteModel = require('../models/pacienteModel');

class PacienteController {
  // Criar novo paciente
  static async create(req, res) {
    try {
      const { nome, cpf, data_nascimento, plano } = req.body;

      // Validações básicas
      if (!nome || !cpf || !data_nascimento || !plano) {
        return res.status(400).json({ 
          error: 'Todos os campos são obrigatórios: nome, cpf, data_nascimento, plano' 
        });
      }

      // Validar plano (1, 2 ou 3)
      if (![1, 2, 3].includes(parseInt(plano))) {
        return res.status(400).json({ 
          error: 'Plano deve ser 1, 2 ou 3' 
        });
      }

      // Verificar se CPF já existe
      const cpfExistente = await PacienteModel.findByCpf(cpf);
      if (cpfExistente) {
        return res.status(400).json({ 
          error: 'CPF já cadastrado' 
        });
      }

      const pacienteId = await PacienteModel.create(req.body);
      
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

  // Listar todos os pacientes
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

  // Buscar paciente por ID
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

  // Buscar pacientes por plano
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

  // Atualizar paciente
  static async update(req, res) {
    try {
      const { id } = req.params;
      const { nome, cpf, data_nascimento, plano } = req.body;

      // Verificar se paciente existe
      const pacienteExistente = await PacienteModel.findById(id);
      if (!pacienteExistente) {
        return res.status(404).json({ 
          error: 'Paciente não encontrado' 
        });
      }

      // Validações básicas
      if (!nome || !cpf || !data_nascimento || !plano) {
        return res.status(400).json({ 
          error: 'Todos os campos são obrigatórios: nome, cpf, data_nascimento, plano' 
        });
      }

      // Validar plano (1, 2 ou 3)
      if (![1, 2, 3].includes(parseInt(plano))) {
        return res.status(400).json({ 
          error: 'Plano deve ser 1, 2 ou 3' 
        });
      }

      // Verificar se CPF já existe em outro paciente
      const cpfExistente = await PacienteModel.findByCpf(cpf);
      if (cpfExistente && cpfExistente.id != id) {
        return res.status(400).json({ 
          error: 'CPF já cadastrado para outro paciente' 
        });
      }

      await PacienteModel.update(id, req.body);
      
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

  // Deletar paciente
  static async delete(req, res) {
    try {
      const { id } = req.params;

      // Verificar se paciente existe
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

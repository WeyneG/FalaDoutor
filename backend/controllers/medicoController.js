const MedicoModel = require('../models/medicoModel');

class MedicoController {
  // Criar novo médico
  static async create(req, res) {
    try {
      const { nome, cpf, crm, data_nascimento, plano } = req.body;

      // Validações básicas
      if (!nome || !cpf || !crm || !data_nascimento || !plano) {
        return res.status(400).json({ 
          error: 'Todos os campos são obrigatórios: nome, cpf, crm, data_nascimento, plano' 
        });
      }

      // Validar plano (1, 2 ou 3)
      if (![1, 2, 3].includes(parseInt(plano))) {
        return res.status(400).json({ 
          error: 'Plano deve ser 1, 2 ou 3' 
        });
      }

      // Verificar se CPF já existe
      const cpfExistente = await MedicoModel.findByCpf(cpf);
      if (cpfExistente) {
        return res.status(400).json({ 
          error: 'CPF já cadastrado' 
        });
      }

      // Verificar se CRM já existe
      const crmExistente = await MedicoModel.findByCrm(crm);
      if (crmExistente) {
        return res.status(400).json({ 
          error: 'CRM já cadastrado' 
        });
      }

      const medicoId = await MedicoModel.create(req.body);
      
      res.status(201).json({ 
        message: 'Médico cadastrado com sucesso',
        id: medicoId 
      });
    } catch (error) {
      console.error('Erro ao criar médico:', error);
      res.status(500).json({ 
        error: 'Erro ao cadastrar médico',
        details: error.message 
      });
    }
  }

  // Listar todos os médicos
  static async getAll(req, res) {
    try {
      const medicos = await MedicoModel.findAll();
      res.json(medicos);
    } catch (error) {
      console.error('Erro ao buscar médicos:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar médicos',
        details: error.message 
      });
    }
  }

  // Buscar médico por ID
  static async getById(req, res) {
    try {
      const { id } = req.params;
      const medico = await MedicoModel.findById(id);

      if (!medico) {
        return res.status(404).json({ 
          error: 'Médico não encontrado' 
        });
      }

      res.json(medico);
    } catch (error) {
      console.error('Erro ao buscar médico:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar médico',
        details: error.message 
      });
    }
  }

  // Buscar médicos por plano
  static async getByPlano(req, res) {
    try {
      const { plano } = req.params;

      if (![1, 2, 3].includes(parseInt(plano))) {
        return res.status(400).json({ 
          error: 'Plano deve ser 1, 2 ou 3' 
        });
      }

      const medicos = await MedicoModel.findByPlano(plano);
      res.json(medicos);
    } catch (error) {
      console.error('Erro ao buscar médicos por plano:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar médicos por plano',
        details: error.message 
      });
    }
  }

  // Atualizar médico
  static async update(req, res) {
    try {
      const { id } = req.params;
      const { nome, cpf, crm, data_nascimento, plano } = req.body;

      // Verificar se médico existe
      const medicoExistente = await MedicoModel.findById(id);
      if (!medicoExistente) {
        return res.status(404).json({ 
          error: 'Médico não encontrado' 
        });
      }

      // Validações básicas
      if (!nome || !cpf || !crm || !data_nascimento || !plano) {
        return res.status(400).json({ 
          error: 'Todos os campos são obrigatórios: nome, cpf, crm, data_nascimento, plano' 
        });
      }

      // Validar plano (1, 2 ou 3)
      if (![1, 2, 3].includes(parseInt(plano))) {
        return res.status(400).json({ 
          error: 'Plano deve ser 1, 2 ou 3' 
        });
      }

      // Verificar se CPF já existe em outro médico
      const cpfExistente = await MedicoModel.findByCpf(cpf);
      if (cpfExistente && cpfExistente.id != id) {
        return res.status(400).json({ 
          error: 'CPF já cadastrado para outro médico' 
        });
      }

      // Verificar se CRM já existe em outro médico
      const crmExistente = await MedicoModel.findByCrm(crm);
      if (crmExistente && crmExistente.id != id) {
        return res.status(400).json({ 
          error: 'CRM já cadastrado para outro médico' 
        });
      }

      await MedicoModel.update(id, req.body);
      
      res.json({ 
        message: 'Médico atualizado com sucesso' 
      });
    } catch (error) {
      console.error('Erro ao atualizar médico:', error);
      res.status(500).json({ 
        error: 'Erro ao atualizar médico',
        details: error.message 
      });
    }
  }

  // Deletar médico
  static async delete(req, res) {
    try {
      const { id } = req.params;

      // Verificar se médico existe
      const medico = await MedicoModel.findById(id);
      if (!medico) {
        return res.status(404).json({ 
          error: 'Médico não encontrado' 
        });
      }

      await MedicoModel.delete(id);
      
      res.json({ 
        message: 'Médico deletado com sucesso' 
      });
    } catch (error) {
      console.error('Erro ao deletar médico:', error);
      res.status(500).json({ 
        error: 'Erro ao deletar médico',
        details: error.message 
      });
    }
  }
}

module.exports = MedicoController;

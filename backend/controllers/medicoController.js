const MedicoModel = require('../models/medicoModel');
const PlanoModel = require('../models/planoModel');
const MedicoPlanoModel = require('../models/medicoPlanoModel');

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

class MedicoController {
  
  static async create(req, res) {
    try {
      const { nome, cpf, crm, data_nascimento, plano_ids } = req.body;

      // Validar campos obrigatórios
      if (!nome || !cpf || !crm || !data_nascimento) {
        return res.status(400).json({ 
          error: 'Todos os campos são obrigatórios: nome, cpf, crm, data_nascimento' 
        });
      }

      // Validar plano_ids (opcional - médico pode não ter planos)
      if (plano_ids && !Array.isArray(plano_ids)) {
        return res.status(400).json({ 
          error: 'plano_ids deve ser um array' 
        });
      }

      // Validar que todos os planos existem
      if (plano_ids && plano_ids.length > 0) {
        for (const planoId of plano_ids) {
          const planoExiste = await PlanoModel.exists(planoId);
          if (!planoExiste) {
            return res.status(400).json({ 
              error: `Plano ${planoId} não encontrado` 
            });
          }
        }
      }

      // Verificar CPF duplicado
      const cpfExistente = await MedicoModel.findByCpf(cpf);
      if (cpfExistente) {
        return res.status(400).json({ 
          error: 'CPF já cadastrado' 
        });
      }

      // Verificar CRM duplicado
      const crmExistente = await MedicoModel.findByCrm(crm);
      if (crmExistente) {
        return res.status(400).json({ 
          error: 'CRM já cadastrado' 
        });
      }

      // Criar médico
      const dadosMedico = {
        nome,
        cpf,
        crm,
        data_nascimento: formatarDataParaMySQL(data_nascimento)
      };
      const medicoId = await MedicoModel.create(dadosMedico);
      
      // Associar planos ao médico
      if (plano_ids && plano_ids.length > 0) {
        await MedicoPlanoModel.addPlanos(medicoId, plano_ids);
      }
      
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


  static async getByPlano(req, res) {
    try {
      const { plano } = req.params;

      const planoExiste = await PlanoModel.exists(plano);
      if (!planoExiste) {
        return res.status(400).json({ 
          error: 'Plano não encontrado' 
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


  static async update(req, res) {
    try {
      const { id } = req.params;
      const { nome, cpf, crm, data_nascimento, plano_ids } = req.body;

      // Verificar se médico existe
      const medicoExistente = await MedicoModel.findById(id);
      if (!medicoExistente) {
        return res.status(404).json({ 
          error: 'Médico não encontrado' 
        });
      }

      // Validar campos obrigatórios
      if (!nome || !cpf || !crm || !data_nascimento) {
        return res.status(400).json({ 
          error: 'Todos os campos são obrigatórios: nome, cpf, crm, data_nascimento' 
        });
      }

      // Validar plano_ids (opcional)
      if (plano_ids && !Array.isArray(plano_ids)) {
        return res.status(400).json({ 
          error: 'plano_ids deve ser um array' 
        });
      }

      // Validar que todos os planos existem
      if (plano_ids && plano_ids.length > 0) {
        for (const planoId of plano_ids) {
          const planoExiste = await PlanoModel.exists(planoId);
          if (!planoExiste) {
            return res.status(400).json({ 
              error: `Plano ${planoId} não encontrado` 
            });
          }
        }
      }
  
      // Verificar CPF duplicado
      const cpfExistente = await MedicoModel.findByCpf(cpf);
      if (cpfExistente && cpfExistente.id != id) {
        return res.status(400).json({ 
          error: 'CPF já cadastrado para outro médico' 
        });
      }

      // Verificar CRM duplicado
      const crmExistente = await MedicoModel.findByCrm(crm);
      if (crmExistente && crmExistente.id != id) {
        return res.status(400).json({ 
          error: 'CRM já cadastrado para outro médico' 
        });
      }

      // Atualizar dados do médico
      const dadosMedico = {
        nome,
        cpf,
        crm,
        data_nascimento: formatarDataParaMySQL(data_nascimento)
      };
      await MedicoModel.update(id, dadosMedico);
      
      // Atualizar planos (remover todos e adicionar novos)
      await MedicoPlanoModel.removePlanosByMedico(id);
      if (plano_ids && plano_ids.length > 0) {
        await MedicoPlanoModel.addPlanos(id, plano_ids);
      }
      
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


  static async delete(req, res) {
    try {
      const { id } = req.params;


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

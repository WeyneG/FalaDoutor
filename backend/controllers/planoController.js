const PlanoModel = require('../models/planoModel');
const db = require('../config/database');

class PlanoController {

  static async getAll(req, res) {
    try {
      const planos = await PlanoModel.findAll();
      res.json(planos);
    } catch (error) {
      console.error('Erro ao buscar planos:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar planos',
        details: error.message 
      });
    }
  }

  static async getById(req, res) {
    try {
      const { id } = req.params;
      const plano = await PlanoModel.findById(id);

      if (!plano) {
        return res.status(404).json({ 
          error: 'Plano não encontrado' 
        });
      }

      res.json(plano);
    } catch (error) {
      console.error('Erro ao buscar plano:', error);
      res.status(500).json({ 
        error: 'Erro ao buscar plano',
        details: error.message 
      });
    }
  }

  static async create(req, res) {
    try {
      const { id, nome, valor } = req.body;

      if (!id || !nome || !valor) {
        return res.status(400).json({ 
          error: 'Todos os campos são obrigatórios: id, nome, valor' 
        });
      }

      // Verificar se ID já existe
      const planoExistente = await PlanoModel.findById(id);
      if (planoExistente) {
        return res.status(400).json({ 
          error: 'ID do plano já cadastrado' 
        });
      }

      await PlanoModel.create(req.body);
      
      res.status(201).json({ 
        message: 'Plano cadastrado com sucesso'
      });
    } catch (error) {
      console.error('Erro ao criar plano:', error);
      res.status(500).json({ 
        error: 'Erro ao cadastrar plano',
        details: error.message 
      });
    }
  }

  static async update(req, res) {
    try {
      const { id } = req.params;
      const { nome, valor } = req.body;

      const planoExistente = await PlanoModel.findById(id);
      if (!planoExistente) {
        return res.status(404).json({ 
          error: 'Plano não encontrado' 
        });
      }

      if (!nome || !valor) {
        return res.status(400).json({ 
          error: 'Todos os campos são obrigatórios: nome, valor' 
        });
      }

      await PlanoModel.update(id, req.body);
      
      res.json({ 
        message: 'Plano atualizado com sucesso' 
      });
    } catch (error) {
      console.error('Erro ao atualizar plano:', error);
      res.status(500).json({ 
        error: 'Erro ao atualizar plano',
        details: error.message 
      });
    }
  }

  static async delete(req, res) {
    try {
      const { id } = req.params;

      const plano = await PlanoModel.findById(id);
      if (!plano) {
        return res.status(404).json({ 
          error: 'Plano não encontrado' 
        });
      }

      // Verificar se há médicos usando este plano
      const [medicos] = await db.query(
        'SELECT COUNT(*) as total FROM medicos WHERE plano_id = ?', 
        [id]
      );
      
      // Verificar se há pacientes usando este plano
      const [pacientes] = await db.query(
        'SELECT COUNT(*) as total FROM pacientes WHERE plano_id = ?', 
        [id]
      );

      const totalMedicos = medicos[0].total;
      const totalPacientes = pacientes[0].total;

      // Se houver dependências, bloquear a deleção com mensagem clara
      if (totalMedicos > 0 || totalPacientes > 0) {
        return res.status(400).json({ 
          error: `Não é possível deletar o plano "${plano.nome}". Há ${totalMedicos} médico(s) e ${totalPacientes} paciente(s) usando este plano. Reatribua-os para outro plano antes de deletar.`,
          medicos: totalMedicos,
          pacientes: totalPacientes,
          planoNome: plano.nome
        });
      }

      // Se não houver dependências, pode deletar
      await PlanoModel.delete(id);
      
      res.json({ 
        message: 'Plano deletado com sucesso' 
      });
    } catch (error) {
      console.error('Erro ao deletar plano:', error);
      res.status(500).json({ 
        error: 'Erro ao deletar plano',
        details: error.message 
      });
    }
  }
}

module.exports = PlanoController;

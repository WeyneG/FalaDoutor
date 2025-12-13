const db = require('../config/database');

class MedicoModel {
  // Criar um novo médico
  static async create(medico) {
    const { nome, cpf, crm, data_nascimento } = medico;
    
    const query = `
      INSERT INTO medicos (nome, cpf, crm, data_nascimento)
      VALUES (?, ?, ?, ?)
    `;
    
    try {
      const [result] = await db.execute(query, [nome, cpf, crm, data_nascimento]);
      return result.insertId;
    } catch (error) {
      throw error;
    }
  }

  // Buscar todos os médicos
  static async findAll() {
    const query = `
      SELECT 
        m.*,
        GROUP_CONCAT(DISTINCT p.id ORDER BY p.valor) as planos_ids,
        GROUP_CONCAT(DISTINCT p.nome ORDER BY p.valor SEPARATOR ', ') as planos_nomes
      FROM medicos m
      LEFT JOIN medico_planos mp ON m.id = mp.medico_id
      LEFT JOIN planos p ON mp.plano_id = p.id
      GROUP BY m.id
      ORDER BY m.nome
    `;
    
    try {
      const [rows] = await db.execute(query);
      return rows;
    } catch (error) {
      throw error;
    }
  }

  // Buscar médico por ID
  static async findById(id) {
    const medicoQuery = 'SELECT * FROM medicos WHERE id = ?';
    const planosQuery = `
      SELECT p.id, p.nome, CAST(p.valor AS CHAR) as valor
      FROM medico_planos mp
      JOIN planos p ON mp.plano_id = p.id
      WHERE mp.medico_id = ?
      ORDER BY p.valor
    `;
    
    try {
      const [medicoRows] = await db.execute(medicoQuery, [id]);
      if (!medicoRows || medicoRows.length === 0) {
        return null;
      }
      
      const medico = medicoRows[0];
      const [planosRows] = await db.execute(planosQuery, [id]);
      medico.planos = planosRows;
      
      return medico;
    } catch (error) {
      throw error;
    }
  }

  // Buscar médico por CPF
  static async findByCpf(cpf) {
    const query = 'SELECT * FROM medicos WHERE cpf = ?';
    
    try {
      const [rows] = await db.execute(query, [cpf]);
      return rows[0];
    } catch (error) {
      throw error;
    }
  }

  // Buscar médico por CRM
  static async findByCrm(crm) {
    const query = 'SELECT * FROM medicos WHERE crm = ?';
    
    try {
      const [rows] = await db.execute(query, [crm]);
      return rows[0];
    } catch (error) {
      throw error;
    }
  }

  // Atualizar médico
  static async update(id, medico) {
    const { nome, cpf, crm, data_nascimento } = medico;
    
    const query = `
      UPDATE medicos 
      SET nome = ?, cpf = ?, crm = ?, data_nascimento = ?
      WHERE id = ?
    `;
    
    try {
      const [result] = await db.execute(query, [nome, cpf, crm, data_nascimento, id]);
      return result.affectedRows;
    } catch (error) {
      throw error;
    }
  }

  // Deletar médico
  static async delete(id) {
    const query = 'DELETE FROM medicos WHERE id = ?';
    
    try {
      const [result] = await db.execute(query, [id]);
      return result.affectedRows;
    } catch (error) {
      throw error;
    }
  }

  // Buscar médicos por plano
  static async findByPlano(planoId) {
    const query = `
      SELECT DISTINCT
        m.*,
        p.nome as plano_nome,
        CAST(p.valor AS CHAR) as plano_valor
      FROM medicos m
      JOIN medico_planos mp ON m.id = mp.medico_id
      JOIN planos p ON mp.plano_id = p.id
      WHERE mp.plano_id = ?
      ORDER BY m.nome
    `;
    
    try {
      const [rows] = await db.execute(query, [planoId]);
      return rows;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = MedicoModel;

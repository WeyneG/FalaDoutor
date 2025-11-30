const db = require('../config/database');

class MedicoModel {
  // Criar um novo médico
  static async create(medico) {
    const { nome, cpf, crm, data_nascimento, plano_id } = medico;
    
    const query = `
      INSERT INTO medicos (nome, cpf, crm, data_nascimento, plano_id)
      VALUES (?, ?, ?, ?, ?)
    `;
    
    try {
      const [result] = await db.execute(query, [nome, cpf, crm, data_nascimento, plano_id]);
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
        p.nome as plano_nome,
        CAST(p.valor AS CHAR) as plano_valor
      FROM medicos m
      LEFT JOIN planos p ON m.plano_id = p.id
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
    const query = `
      SELECT 
        m.*,
        p.nome as plano_nome,
        CAST(p.valor AS CHAR) as plano_valor
      FROM medicos m
      LEFT JOIN planos p ON m.plano_id = p.id
      WHERE m.id = ?
    `;
    
    try {
      const [rows] = await db.execute(query, [id]);
      return rows[0];
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
    const { nome, cpf, crm, data_nascimento, plano_id } = medico;
    
    const query = `
      UPDATE medicos 
      SET nome = ?, cpf = ?, crm = ?, data_nascimento = ?, plano_id = ?
      WHERE id = ?
    `;
    
    try {
      const [result] = await db.execute(query, [nome, cpf, crm, data_nascimento, plano_id, id]);
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
      SELECT 
        m.*,
        p.nome as plano_nome,
        p.valor as plano_valor
      FROM medicos m
      LEFT JOIN planos p ON m.plano_id = p.id
      WHERE m.plano_id = ?
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

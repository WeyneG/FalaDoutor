const db = require('../config/database');

class MedicoModel {
  // Criar um novo médico
  static async create(medico) {
    const { nome, cpf, crm, data_nascimento, plano } = medico;
    
    const query = `
      INSERT INTO medicos (nome, cpf, crm, data_nascimento, plano)
      VALUES (?, ?, ?, ?, ?)
    `;
    
    try {
      const [result] = await db.execute(query, [nome, cpf, crm, data_nascimento, plano]);
      return result.insertId;
    } catch (error) {
      throw error;
    }
  }

  // Buscar todos os médicos
  static async findAll() {
    const query = 'SELECT * FROM medicos ORDER BY nome';
    
    try {
      const [rows] = await db.execute(query);
      return rows;
    } catch (error) {
      throw error;
    }
  }

  // Buscar médico por ID
  static async findById(id) {
    const query = 'SELECT * FROM medicos WHERE id = ?';
    
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
    const { nome, cpf, crm, data_nascimento, plano } = medico;
    
    const query = `
      UPDATE medicos 
      SET nome = ?, cpf = ?, crm = ?, data_nascimento = ?, plano = ?
      WHERE id = ?
    `;
    
    try {
      const [result] = await db.execute(query, [nome, cpf, crm, data_nascimento, plano, id]);
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
  static async findByPlano(plano) {
    const query = 'SELECT * FROM medicos WHERE plano = ? ORDER BY nome';
    
    try {
      const [rows] = await db.execute(query, [plano]);
      return rows;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = MedicoModel;

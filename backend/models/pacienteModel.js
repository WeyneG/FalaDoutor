const db = require('../config/database');

class PacienteModel {
  // Criar um novo paciente
  static async create(paciente) {
    const { nome, cpf, data_nascimento, plano } = paciente;
    
    const query = `
      INSERT INTO pacientes (nome, cpf, data_nascimento, plano)
      VALUES (?, ?, ?, ?)
    `;
    
    try {
      const [result] = await db.execute(query, [nome, cpf, data_nascimento, plano]);
      return result.insertId;
    } catch (error) {
      throw error;
    }
  }

  // Buscar todos os pacientes
  static async findAll() {
    const query = 'SELECT * FROM pacientes ORDER BY nome';
    
    try {
      const [rows] = await db.execute(query);
      return rows;
    } catch (error) {
      throw error;
    }
  }

  // Buscar paciente por ID
  static async findById(id) {
    const query = 'SELECT * FROM pacientes WHERE id = ?';
    
    try {
      const [rows] = await db.execute(query, [id]);
      return rows[0];
    } catch (error) {
      throw error;
    }
  }

  // Buscar paciente por CPF
  static async findByCpf(cpf) {
    const query = 'SELECT * FROM pacientes WHERE cpf = ?';
    
    try {
      const [rows] = await db.execute(query, [cpf]);
      return rows[0];
    } catch (error) {
      throw error;
    }
  }

  // Atualizar paciente
  static async update(id, paciente) {
    const { nome, cpf, data_nascimento, plano } = paciente;
    
    const query = `
      UPDATE pacientes 
      SET nome = ?, cpf = ?, data_nascimento = ?, plano = ?
      WHERE id = ?
    `;
    
    try {
      const [result] = await db.execute(query, [nome, cpf, data_nascimento, plano, id]);
      return result.affectedRows;
    } catch (error) {
      throw error;
    }
  }

  // Deletar paciente
  static async delete(id) {
    const query = 'DELETE FROM pacientes WHERE id = ?';
    
    try {
      const [result] = await db.execute(query, [id]);
      return result.affectedRows;
    } catch (error) {
      throw error;
    }
  }

  // Buscar pacientes por plano
  static async findByPlano(plano) {
    const query = 'SELECT * FROM pacientes WHERE plano = ? ORDER BY nome';
    
    try {
      const [rows] = await db.execute(query, [plano]);
      return rows;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = PacienteModel;

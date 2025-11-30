const db = require('../config/database');

class PacienteModel {
  // Criar um novo paciente
  static async create(paciente) {
    const { nome, cpf, data_nascimento, plano_id } = paciente;
    
    const query = `
      INSERT INTO pacientes (nome, cpf, data_nascimento, plano_id)
      VALUES (?, ?, ?, ?)
    `;
    
    try {
      const [result] = await db.execute(query, [nome, cpf, data_nascimento, plano_id]);
      return result.insertId;
    } catch (error) {
      throw error;
    }
  }

  // Buscar todos os pacientes
  static async findAll() {
    const query = `
      SELECT 
        p.*,
        pl.nome as plano_nome,
        CAST(pl.valor AS CHAR) as plano_valor
      FROM pacientes p
      LEFT JOIN planos pl ON p.plano_id = pl.id
      ORDER BY p.nome
    `;
    
    try {
      const [rows] = await db.execute(query);
      return rows;
    } catch (error) {
      throw error;
    }
  }

  // Buscar paciente por ID
  static async findById(id) {
    const query = `
      SELECT 
        p.*,
        pl.nome as plano_nome,
        CAST(pl.valor AS CHAR) as plano_valor
      FROM pacientes p
      LEFT JOIN planos pl ON p.plano_id = pl.id
      WHERE p.id = ?
    `;
    
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
    const { nome, cpf, data_nascimento, plano_id } = paciente;
    
    const query = `
      UPDATE pacientes 
      SET nome = ?, cpf = ?, data_nascimento = ?, plano_id = ?
      WHERE id = ?
    `;
    
    try {
      const [result] = await db.execute(query, [nome, cpf, data_nascimento, plano_id, id]);
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
  static async findByPlano(planoId) {
    const query = `
      SELECT 
        pac.*,
        p.nome as plano_nome,
        p.valor as plano_valor
      FROM pacientes pac
      LEFT JOIN planos p ON pac.plano_id = p.id
      WHERE pac.plano_id = ?
      ORDER BY pac.nome
    `;
    
    try {
      const [rows] = await db.execute(query, [planoId]);
      return rows;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = PacienteModel;

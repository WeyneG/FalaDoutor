const db = require('../config/database');

class PlanoModel {
  
  // Buscar todos os planos
  static async findAll() {
    const query = 'SELECT id, nome, CAST(valor AS CHAR) as valor, created_at, updated_at FROM planos ORDER BY valor';
    
    try {
      const [rows] = await db.execute(query);
      return rows;
    } catch (error) {
      throw error;
    }
  }

  // Buscar plano por ID
  static async findById(id) {
    const query = 'SELECT id, nome, CAST(valor AS CHAR) as valor, created_at, updated_at FROM planos WHERE id = ?';
    
    try {
      const [rows] = await db.execute(query, [id]);
      return rows[0];
    } catch (error) {
      throw error;
    }
  }

  // Criar novo plano
  static async create(plano) {
    const { id, nome, valor } = plano;
    
    const query = `
      INSERT INTO planos (id, nome, valor)
      VALUES (?, ?, ?)
    `;
    
    try {
      const [result] = await db.execute(query, [id, nome, valor]);
      return result.insertId;
    } catch (error) {
      throw error;
    }
  }

  // Atualizar plano
  static async update(id, plano) {
    const { nome, valor } = plano;
    
    const query = `
      UPDATE planos 
      SET nome = ?, valor = ?
      WHERE id = ?
    `;
    
    try {
      const [result] = await db.execute(query, [nome, valor, id]);
      return result.affectedRows;
    } catch (error) {
      throw error;
    }
  }

  // Deletar plano
  static async delete(id) {
    const query = 'DELETE FROM planos WHERE id = ?';
    
    try {
      const [result] = await db.execute(query, [id]);
      return result.affectedRows;
    } catch (error) {
      throw error;
    }
  }

  // Verificar se plano existe
  static async exists(id) {
    const plano = await this.findById(id);
    return plano !== undefined && plano !== null;
  }
}

module.exports = PlanoModel;

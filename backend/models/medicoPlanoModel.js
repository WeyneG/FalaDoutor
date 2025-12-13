const db = require('../config/database');

class MedicoPlanoModel {
  // Adicionar múltiplos planos a um médico
  static async addPlanos(medicoId, planoIds) {
    if (!planoIds || planoIds.length === 0) return;
    
    const values = planoIds.map(planoId => [medicoId, planoId]);
    
    await db.query(
      `INSERT INTO medico_planos (medico_id, plano_id) VALUES ?
       ON DUPLICATE KEY UPDATE plano_id = plano_id`,
      [values]
    );
  }

  // Remover todos os planos de um médico
  static async removePlanosByMedico(medicoId) {
    await db.query(
      'DELETE FROM medico_planos WHERE medico_id = ?',
      [medicoId]
    );
  }

  // Remover um plano específico de um médico
  static async removePlano(medicoId, planoId) {
    await db.query(
      'DELETE FROM medico_planos WHERE medico_id = ? AND plano_id = ?',
      [medicoId, planoId]
    );
  }

  // Buscar todos os planos de um médico
  static async findByMedico(medicoId) {
    const [rows] = await db.query(
      `SELECT 
        p.id,
        p.nome,
        CAST(p.valor AS CHAR) as valor
       FROM medico_planos mp
       JOIN planos p ON mp.plano_id = p.id
       WHERE mp.medico_id = ?
       ORDER BY p.valor ASC`,
      [medicoId]
    );
    return rows;
  }

  // Buscar todos os médicos de um plano
  static async findByPlano(planoId) {
    const [rows] = await db.query(
      `SELECT 
        m.id,
        m.nome,
        m.crm,
        m.cpf
       FROM medico_planos mp
       JOIN medicos m ON mp.medico_id = m.id
       WHERE mp.plano_id = ?
       ORDER BY m.nome`,
      [planoId]
    );
    return rows;
  }

  // Verificar se um médico tem um plano específico
  static async hasPlano(medicoId, planoId) {
    const [rows] = await db.query(
      'SELECT COUNT(*) as count FROM medico_planos WHERE medico_id = ? AND plano_id = ?',
      [medicoId, planoId]
    );
    return rows[0].count > 0;
  }
}

module.exports = MedicoPlanoModel;

const db = require('../config/database');

class ConsultaModel {
  // Criar consulta
  static async create(consulta) {
    const [result] = await db.query(
      `INSERT INTO consultas (paciente_id, medico_id, data_consulta, valor, status, observacoes) 
       VALUES (?, ?, ?, ?, ?, ?)`,
      [
        consulta.paciente_id,
        consulta.medico_id,
        consulta.data_consulta,
        consulta.valor,
        consulta.status || 'agendada',
        consulta.observacoes || null
      ]
    );
    return result.insertId;
  }

  // Buscar todas as consultas com dados relacionados
  static async findAll() {
    const [rows] = await db.query(`
      SELECT 
        c.id,
        c.data_consulta,
        c.status,
        c.observacoes,
        c.created_at,
        c.updated_at,
        CAST(c.valor AS CHAR) as valor,
        pac.id as paciente_id,
        pac.nome as paciente_nome,
        pac.cpf as paciente_cpf,
        med.id as medico_id,
        med.nome as medico_nome,
        med.crm as medico_crm,
        pl.id as plano_id,
        pl.nome as plano_nome
      FROM consultas c
      JOIN pacientes pac ON c.paciente_id = pac.id
      JOIN medicos med ON c.medico_id = med.id
      JOIN planos pl ON pac.plano_id = pl.id
      ORDER BY c.data_consulta DESC
    `);
    return rows;
  }

  // Buscar consulta por ID
  static async findById(id) {
    const [rows] = await db.query(
      `SELECT 
        c.*,
        CAST(c.valor AS CHAR) as valor,
        pac.id as paciente_id,
        pac.nome as paciente_nome,
        pac.cpf as paciente_cpf,
        med.id as medico_id,
        med.nome as medico_nome,
        med.crm as medico_crm,
        pl.id as plano_id,
        pl.nome as plano_nome
      FROM consultas c
      JOIN pacientes pac ON c.paciente_id = pac.id
      JOIN medicos med ON c.medico_id = med.id
      JOIN planos pl ON pac.plano_id = pl.id
      WHERE c.id = ?`,
      [id]
    );
    return rows.length > 0 ? rows[0] : null;
  }

  // Buscar consultas por paciente
  static async findByPaciente(pacienteId) {
    const [rows] = await db.query(
      `SELECT 
        c.*,
        CAST(c.valor AS CHAR) as valor,
        med.nome as medico_nome,
        med.crm as medico_crm
      FROM consultas c
      JOIN medicos med ON c.medico_id = med.id
      WHERE c.paciente_id = ?
      ORDER BY c.data_consulta DESC`,
      [pacienteId]
    );
    return rows;
  }

  // Buscar consultas por médico
  static async findByMedico(medicoId) {
    const [rows] = await db.query(
      `SELECT 
        c.*,
        CAST(c.valor AS CHAR) as valor,
        pac.nome as paciente_nome,
        pac.cpf as paciente_cpf
      FROM consultas c
      JOIN pacientes pac ON c.paciente_id = pac.id
      WHERE c.medico_id = ?
      ORDER BY c.data_consulta DESC`,
      [medicoId]
    );
    return rows;
  }

  // Buscar médicos que atendem o plano do paciente
  static async findMedicosByPacientePlano(pacienteId) {
    const [rows] = await db.query(
      `SELECT DISTINCT
        m.id,
        m.nome,
        m.crm,
        m.cpf,
        m.data_nascimento
      FROM medicos m
      JOIN medico_planos mp ON m.id = mp.medico_id
      WHERE mp.plano_id = (
        SELECT plano_id FROM pacientes WHERE id = ?
      )
      ORDER BY m.nome`,
      [pacienteId]
    );
    return rows;
  }

  // Atualizar consulta
  static async update(id, consulta) {
    const [result] = await db.query(
      `UPDATE consultas 
       SET medico_id = ?, data_consulta = ?, valor = ?, status = ?, observacoes = ?
       WHERE id = ?`,
      [
        consulta.medico_id,
        consulta.data_consulta,
        consulta.valor,
        consulta.status,
        consulta.observacoes,
        id
      ]
    );
    return result.affectedRows;
  }

  // Deletar consulta
  static async delete(id) {
    const [result] = await db.query('DELETE FROM consultas WHERE id = ?', [id]);
    return result.affectedRows;
  }

  // Verificar conflito de horário
  static async checkConflito(medicoId, dataConsulta, consultaIdExcluir = null) {
    const query = consultaIdExcluir
      ? `SELECT COUNT(*) as count FROM consultas 
         WHERE medico_id = ? 
         AND DATE_FORMAT(data_consulta, '%Y-%m-%d %H:%i') = DATE_FORMAT(?, '%Y-%m-%d %H:%i')
         AND status != 'cancelada'
         AND id != ?`
      : `SELECT COUNT(*) as count FROM consultas 
         WHERE medico_id = ? 
         AND DATE_FORMAT(data_consulta, '%Y-%m-%d %H:%i') = DATE_FORMAT(?, '%Y-%m-%d %H:%i')
         AND status != 'cancelada'`;

    const params = consultaIdExcluir 
      ? [medicoId, dataConsulta, consultaIdExcluir]
      : [medicoId, dataConsulta];

    const [rows] = await db.query(query, params);
    return rows[0].count > 0;
  }
}

module.exports = ConsultaModel;

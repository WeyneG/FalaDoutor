const db = require('../config/database');

const RelatorioController = {
  getRelatorioMedicos: async (req, res) => {
    try {
      // Buscar total de médicos
      const [totalResult] = await db.query('SELECT COUNT(*) as total FROM medicos');
      const totalMedicos = totalResult[0].total;

      // Buscar médicos por plano
      const [medicosPorPlano] = await db.query(`
        SELECT 
          p.nome as plano,
          COUNT(DISTINCT mp.medico_id) as quantidade
        FROM planos p
        LEFT JOIN medico_planos mp ON p.id = mp.plano_id
        GROUP BY p.id, p.nome
        ORDER BY quantidade DESC
      `);

      // Buscar médicos sem plano
      const [medicosSemPlano] = await db.query(`
        SELECT COUNT(*) as quantidade
        FROM medicos m
        LEFT JOIN medico_planos mp ON m.id = mp.medico_id
        WHERE mp.medico_id IS NULL
      `);

      // Buscar médicos por idade
      const [medicosPorIdade] = await db.query(`
        SELECT 
          CASE 
            WHEN TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) < 30 THEN 'Jovem'
            WHEN TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) BETWEEN 30 AND 50 THEN 'Adulto'
            WHEN TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) BETWEEN 51 AND 65 THEN 'Meia-idade'
            ELSE 'Idoso'
          END as faixaEtaria,
          COUNT(*) as quantidade
        FROM medicos
        WHERE data_nascimento IS NOT NULL
        GROUP BY faixaEtaria
        ORDER BY 
          CASE faixaEtaria
            WHEN 'Jovem' THEN 1
            WHEN 'Adulto' THEN 2
            WHEN 'Meia-idade' THEN 3
            WHEN 'Idoso' THEN 4
          END
      `);

      res.json({
        totalMedicos,
        porPlano: medicosPorPlano,
        semPlano: medicosSemPlano[0].quantidade,
        porIdade: medicosPorIdade
      });
    } catch (error) {
      console.error('Erro ao gerar relatório:', error);
      res.status(500).json({ error: 'Erro ao gerar relatório de médicos' });
    }
  },

  getRelatorioPacientes: async (req, res) => {
    try {
      // Buscar total de pacientes
      const [totalResult] = await db.query('SELECT COUNT(*) as total FROM pacientes');
      const totalPacientes = totalResult[0].total;

      // Buscar pacientes por plano
      const [pacientesPorPlano] = await db.query(`
        SELECT 
          p.nome as plano,
          COUNT(pac.id) as quantidade
        FROM planos p
        LEFT JOIN pacientes pac ON p.id = pac.plano_id
        GROUP BY p.id, p.nome
        ORDER BY quantidade DESC
      `);

      // Buscar pacientes sem plano
      const [pacientesSemPlano] = await db.query(`
        SELECT COUNT(*) as quantidade
        FROM pacientes
        WHERE plano_id IS NULL
      `);

      // Buscar pacientes por idade
      const [pacientesPorIdade] = await db.query(`
        SELECT 
          CASE 
            WHEN TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) < 30 THEN 'Jovem'
            WHEN TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) BETWEEN 30 AND 50 THEN 'Adulto'
            WHEN TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) BETWEEN 51 AND 65 THEN 'Meia-idade'
            ELSE 'Idoso'
          END as faixaEtaria,
          COUNT(*) as quantidade
        FROM pacientes
        WHERE data_nascimento IS NOT NULL
        GROUP BY faixaEtaria
        ORDER BY 
          CASE faixaEtaria
            WHEN 'Jovem' THEN 1
            WHEN 'Adulto' THEN 2
            WHEN 'Meia-idade' THEN 3
            WHEN 'Idoso' THEN 4
          END
      `);

      res.json({
        totalPacientes,
        porPlano: pacientesPorPlano,
        semPlano: pacientesSemPlano[0].quantidade,
        porIdade: pacientesPorIdade
      });
    } catch (error) {
      console.error('Erro ao gerar relatório:', error);
      res.status(500).json({ error: 'Erro ao gerar relatório de pacientes' });
    }
  },

  getRelatorioConsultas: async (req, res) => {
    try {
      // Buscar total de consultas
      const [totalResult] = await db.query('SELECT COUNT(*) as total FROM consultas');
      const totalConsultas = totalResult[0].total;

      // Buscar consultas por data (agrupadas por mês)
      const [consultasPorData] = await db.query(`
        SELECT 
          DATE_FORMAT(data_consulta, '%Y-%m') as mes,
          COUNT(*) as quantidade
        FROM consultas
        GROUP BY DATE_FORMAT(data_consulta, '%Y-%m')
        ORDER BY mes DESC
        LIMIT 12
      `);

      // Buscar consultas por médico
      const [consultasPorMedico] = await db.query(`
        SELECT 
          m.nome as medico,
          COUNT(c.id) as quantidade
        FROM medicos m
        LEFT JOIN consultas c ON m.id = c.medico_id
        GROUP BY m.id, m.nome
        ORDER BY quantidade DESC
      `);

      // Buscar consultas por plano (através do paciente)
      const [consultasPorPlano] = await db.query(`
        SELECT 
          p.nome as plano,
          COUNT(c.id) as quantidade
        FROM planos p
        LEFT JOIN pacientes pac ON p.id = pac.plano_id
        LEFT JOIN consultas c ON pac.id = c.paciente_id
        GROUP BY p.id, p.nome
        ORDER BY quantidade DESC
      `);

      // Buscar consultas de pacientes sem plano
      const [consultasSemPlano] = await db.query(`
        SELECT COUNT(*) as quantidade
        FROM consultas c
        INNER JOIN pacientes pac ON c.paciente_id = pac.id
        WHERE pac.plano_id IS NULL
      `);

      res.json({
        totalConsultas,
        porData: consultasPorData,
        porMedico: consultasPorMedico,
        porPlano: consultasPorPlano,
        semPlano: consultasSemPlano[0].quantidade
      });
    } catch (error) {
      console.error('Erro ao gerar relatório:', error);
      res.status(500).json({ error: 'Erro ao gerar relatório de consultas' });
    }
  }
};

module.exports = RelatorioController;

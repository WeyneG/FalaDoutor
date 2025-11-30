-- ================================================================
-- DADOS DE EXEMPLO - Médicos e Pacientes
-- Execute APÓS o complete_migration_v2.sql
-- ================================================================

USE faladoutor;

-- ================================================================
-- INSERIR 5 MÉDICOS
-- ================================================================
INSERT INTO medicos (nome, cpf, crm, data_nascimento, plano_id) VALUES
('Dr. João Silva Santos', '12345678901', 'CRM/SP-123456', '1978-03-15', 'P1'),
('Dra. Maria Oliveira Costa', '23456789012', 'CRM/RJ-234567', '1985-07-22', 'P2'),
('Dr. Pedro Henrique Souza', '34567890123', 'CRM/MG-345678', '1980-11-08', 'P3'),
('Dra. Ana Carolina Lima', '45678901234', 'CRM/SP-456789', '1990-01-30', 'P2'),
('Dr. Carlos Eduardo Alves', '56789012345', 'CRM/RS-567890', '1975-09-12', 'P1');

-- ================================================================
-- INSERIR 6 PACIENTES
-- ================================================================
INSERT INTO pacientes (nome, cpf, data_nascimento, plano_id) VALUES
('Roberto Carlos Ferreira', '11122233344', '1992-04-10', 'P1'),
('Juliana Santos Pereira', '22233344455', '1988-08-25', 'P2'),
('Fernando Alves Rodrigues', '33344455566', '1995-12-03', 'P3'),
('Patricia Lima Souza', '44455566677', '1982-06-18', 'P1'),
('Marcos Paulo Silva', '55566677788', '1998-02-14', 'P2'),
('Camila Oliveira Costa', '66677788899', '1987-10-29', 'P3');

-- ================================================================
-- VERIFICAR DADOS INSERIDOS
-- ================================================================
SELECT '=== MÉDICOS CADASTRADOS ===' AS '';
SELECT 
  m.id AS 'ID',
  m.nome AS 'Nome',
  m.crm AS 'CRM',
  m.cpf AS 'CPF',
  DATE_FORMAT(m.data_nascimento, '%d/%m/%Y') AS 'Data Nascimento',
  p.nome AS 'Plano',
  CONCAT('R$ ', FORMAT(p.valor, 2, 'pt_BR')) AS 'Valor'
FROM medicos m
LEFT JOIN planos p ON m.plano_id = p.id
ORDER BY m.id;

SELECT '=== PACIENTES CADASTRADOS ===' AS '';
SELECT 
  pa.id AS 'ID',
  pa.nome AS 'Nome',
  pa.cpf AS 'CPF',
  DATE_FORMAT(pa.data_nascimento, '%d/%m/%Y') AS 'Data Nascimento',
  p.nome AS 'Plano',
  CONCAT('R$ ', FORMAT(p.valor, 2, 'pt_BR')) AS 'Valor'
FROM pacientes pa
LEFT JOIN planos p ON pa.plano_id = p.id
ORDER BY pa.id;

-- Totais
SELECT '=== RESUMO ===' AS '';
SELECT 
  (SELECT COUNT(*) FROM medicos) AS total_medicos,
  (SELECT COUNT(*) FROM pacientes) AS total_pacientes,
  (SELECT COUNT(*) FROM planos) AS total_planos;

SELECT '✅ Dados de exemplo inseridos com sucesso!' AS 'STATUS';

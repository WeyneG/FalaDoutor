-- ================================================================
-- MIGRATION COMPLETA - Sistema Fala Doutor v2.0
-- Recria banco de dados com estrutura de planos alfanuméricos
-- Execute este script COMPLETO no MySQL Workbench
-- ================================================================

USE faladoutor;

-- ================================================================
-- PASSO 1: REMOVER TABELAS ANTIGAS
-- ================================================================
-- Remove foreign keys e tabelas na ordem correta
DROP TABLE IF EXISTS medicos;
DROP TABLE IF EXISTS pacientes;
DROP TABLE IF EXISTS planos;

-- ================================================================
-- PASSO 2: CRIAR TABELA PLANOS
-- ================================================================
-- Tabela de planos de saúde com ID alfanumérico (P1, P2, P3, etc)
CREATE TABLE planos (
  id VARCHAR(10) PRIMARY KEY COMMENT 'ID alfanumérico do plano (ex: P1, P2, P3)',
  nome VARCHAR(100) NOT NULL UNIQUE COMMENT 'Nome do plano',
  valor DECIMAL(10, 2) NOT NULL COMMENT 'Valor mensal do plano',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Planos de saúde disponíveis';

-- ================================================================
-- PASSO 3: INSERIR PLANOS PADRÃO
-- ================================================================
INSERT INTO planos (id, nome, valor) VALUES
('P1', 'Plano Básico', 150.00),
('P2', 'Plano Intermediário', 250.00),
('P3', 'Plano Premium', 400.00);

-- ================================================================
-- PASSO 4: CRIAR TABELA MEDICOS
-- ================================================================
CREATE TABLE medicos (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único do médico',
  nome VARCHAR(255) NOT NULL COMMENT 'Nome completo do médico',
  cpf VARCHAR(11) NOT NULL UNIQUE COMMENT 'CPF (somente números)',
  crm VARCHAR(20) NOT NULL UNIQUE COMMENT 'Número do CRM',
  data_nascimento DATE NOT NULL COMMENT 'Data de nascimento',
  plano_id VARCHAR(10) NOT NULL COMMENT 'ID do plano de saúde',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de cadastro',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
  
  -- Foreign Key para tabela planos
  CONSTRAINT fk_medico_plano 
    FOREIGN KEY (plano_id) 
    REFERENCES planos(id) 
    ON DELETE RESTRICT 
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Cadastro de médicos';

-- ================================================================
-- PASSO 5: CRIAR TABELA PACIENTES
-- ================================================================
CREATE TABLE pacientes (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID único do paciente',
  nome VARCHAR(255) NOT NULL COMMENT 'Nome completo do paciente',
  cpf VARCHAR(11) NOT NULL UNIQUE COMMENT 'CPF (somente números)',
  data_nascimento DATE NOT NULL COMMENT 'Data de nascimento',
  plano_id VARCHAR(10) NOT NULL COMMENT 'ID do plano de saúde',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de cadastro',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
  
  -- Foreign Key para tabela planos
  CONSTRAINT fk_paciente_plano 
    FOREIGN KEY (plano_id) 
    REFERENCES planos(id) 
    ON DELETE RESTRICT 
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Cadastro de pacientes';

-- ================================================================
-- PASSO 6: CRIAR ÍNDICES PARA PERFORMANCE
-- ================================================================
-- Índices na tabela medicos
CREATE INDEX idx_medico_cpf ON medicos(cpf) COMMENT 'Índice para busca por CPF';
CREATE INDEX idx_medico_crm ON medicos(crm) COMMENT 'Índice para busca por CRM';
CREATE INDEX idx_medico_plano ON medicos(plano_id) COMMENT 'Índice para JOIN com planos';
CREATE INDEX idx_medico_nome ON medicos(nome) COMMENT 'Índice para busca por nome';

-- Índices na tabela pacientes
CREATE INDEX idx_paciente_cpf ON pacientes(cpf) COMMENT 'Índice para busca por CPF';
CREATE INDEX idx_paciente_plano ON pacientes(plano_id) COMMENT 'Índice para JOIN com planos';
CREATE INDEX idx_paciente_nome ON pacientes(nome) COMMENT 'Índice para busca por nome';

-- ================================================================
-- PASSO 7: VERIFICAÇÕES FINAIS
-- ================================================================
-- Mostrar estrutura das tabelas criadas
SELECT '=== ESTRUTURA DA TABELA PLANOS ===' AS '';
DESCRIBE planos;

SELECT '=== ESTRUTURA DA TABELA MEDICOS ===' AS '';
DESCRIBE medicos;

SELECT '=== ESTRUTURA DA TABELA PACIENTES ===' AS '';
DESCRIBE pacientes;

-- Mostrar planos cadastrados
SELECT '=== PLANOS CADASTRADOS ===' AS '';
SELECT 
  id AS 'ID',
  nome AS 'Nome do Plano',
  CONCAT('R$ ', FORMAT(valor, 2, 'pt_BR')) AS 'Valor',
  created_at AS 'Criado em'
FROM planos
ORDER BY valor;

-- Contar registros
SELECT '=== TOTAIS ===' AS '';
SELECT 
  (SELECT COUNT(*) FROM planos) AS total_planos,
  (SELECT COUNT(*) FROM medicos) AS total_medicos,
  (SELECT COUNT(*) FROM pacientes) AS total_pacientes;

-- ================================================================
-- MIGRATION CONCLUÍDA COM SUCESSO!
-- ================================================================
SELECT '✅ Migration concluída! Banco de dados pronto para uso.' AS 'STATUS';

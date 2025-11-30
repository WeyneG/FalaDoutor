-- Migration: Adicionar coluna plano_id nas tabelas medicos e pacientes
-- Execute este script no MySQL Workbench ou outro cliente MySQL

USE faladoutor;

-- 1. Remover a coluna antiga 'plano' da tabela medicos (se existir)
ALTER TABLE medicos DROP COLUMN IF EXISTS plano;

-- 2. Adicionar a nova coluna plano_id na tabela medicos
ALTER TABLE medicos 
ADD COLUMN plano_id VARCHAR(10) NOT NULL DEFAULT 'P1' AFTER data_nascimento;

-- 3. Adicionar foreign key na tabela medicos
ALTER TABLE medicos
ADD CONSTRAINT fk_medico_plano 
FOREIGN KEY (plano_id) REFERENCES planos(id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- 4. Remover a coluna antiga 'plano' da tabela pacientes (se existir)
ALTER TABLE pacientes DROP COLUMN IF EXISTS plano;

-- 5. Adicionar a nova coluna plano_id na tabela pacientes
ALTER TABLE pacientes 
ADD COLUMN plano_id VARCHAR(10) NOT NULL DEFAULT 'P1' AFTER data_nascimento;

-- 6. Adicionar foreign key na tabela pacientes
ALTER TABLE pacientes
ADD CONSTRAINT fk_paciente_plano 
FOREIGN KEY (plano_id) REFERENCES planos(id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- Verificar as estruturas das tabelas
DESCRIBE medicos;
DESCRIBE pacientes;

-- Verificar se há planos cadastrados (necessário ter pelo menos P1, P2, P3)
SELECT * FROM planos;

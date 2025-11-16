-- Script SQL para criar a tabela de médicos no banco faladoutor
-- Execute este script no MySQL Workbench caso a tabela ainda não exista

USE faladoutor;

-- Criar tabela de médicos
CREATE TABLE IF NOT EXISTS medicos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  cpf VARCHAR(11) NOT NULL UNIQUE,
  crm VARCHAR(20) NOT NULL UNIQUE,
  data_nascimento DATE NOT NULL,
  plano INT NOT NULL CHECK (plano IN (1, 2, 3)),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Índices para melhor performance
CREATE INDEX idx_cpf ON medicos(cpf);
CREATE INDEX idx_crm ON medicos(crm);
CREATE INDEX idx_plano ON medicos(plano);

-- Inserir alguns dados de exemplo (opcional)
INSERT INTO medicos (nome, cpf, crm, data_nascimento, plano) VALUES
('Dr. João Silva', '12345678901', 'CRM/SP 123456', '1980-05-15', 1),
('Dra. Maria Santos', '98765432100', 'CRM/RJ 654321', '1985-08-20', 2),
('Dr. Pedro Oliveira', '11122233344', 'CRM/MG 789012', '1975-12-10', 3);

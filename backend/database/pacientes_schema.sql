-- Script SQL para a tabela de pacientes no banco faladoutor
-- Execute este script no MySQL Workbench caso a tabela ainda não exista

USE faladoutor;

-- Criar tabela de pacientes
CREATE TABLE IF NOT EXISTS pacientes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  cpf VARCHAR(11) NOT NULL UNIQUE,
  data_nascimento DATE NOT NULL,
  plano INT NOT NULL CHECK (plano IN (1, 2, 3)),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Índices para melhor performance
CREATE INDEX idx_cpf_paciente ON pacientes(cpf);
CREATE INDEX idx_plano_paciente ON pacientes(plano);

-- Inserir alguns dados de exemplo (opcional)
INSERT INTO pacientes (nome, cpf, data_nascimento, plano) VALUES
('Ana Silva', '11111111111', '1990-03-15', 1),
('Carlos Santos', '22222222222', '1985-07-20', 2),
('Beatriz Oliveira', '33333333333', '1995-11-08', 3),
('Daniel Costa', '44444444444', '1988-01-25', 1);

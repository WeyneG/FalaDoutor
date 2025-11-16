# 🏥 Fala Doutor – Sistema de Gerenciamento Médico

Um sistema completo para gerenciamento de **médicos** e **pacientes**, composto por:

- **Backend (API REST)** desenvolvido em **Node.js + Express + MySQL**
- **Frontend (Aplicativo Mobile)** desenvolvido em **Flutter**

---

## ✨ Visão Geral do Projeto

O sistema provê um CRUD completo (**Create, Read, Update, Delete**) para a gestão de dados de médicos e pacientes, servindo como **base de dados** para o aplicativo móvel.

---


## 🛠️ Tecnologias Utilizadas

| Componente          | Tecnologias Principais                                  |
|---------------------|----------------------------------------------------------|
| **Backend (API)**   | Node.js, Express.js, MySQL2, dotenv                     |
| **Frontend (Mobile)** | Flutter, Dart, `http` package, Material Design 3     |

---

## 📋 Requisitos de Sistema

Certifique-se de ter os seguintes softwares instalados para rodar o projeto:

- **Node.js** (versão 14 ou superior)
- **Flutter SDK** e ambiente configurado
- **MySQL Server**
- **MySQL Workbench** (opcional, mas útil)

---

## 📁 Estrutura do Projeto

```bash
FALA DOUTOR G4/
├── backend/            # API REST em Node.js (Servidor)
└── frontend/           # Aplicativo mobile em Flutter (Cliente)
```
## 🚀 Guia de Instalação e Execução

### 1. ⚙️ Configuração Inicial

#### a) Banco de Dados (MySQL)

1. Crie o banco de dados chamado **`faladoutor`** no MySQL.
2. Execute os scripts SQL necessários para criar as tabelas:

    backend/database/schema.sql           # tabela de médicos  
    backend/database/pacientes_schema.sql # tabela de pacientes  

#### b) Variáveis de Ambiente

Crie um arquivo chamado **`.env`** dentro da pasta `backend/` e preencha com suas credenciais do MySQL e a porta do servidor:

    DB_HOST=localhost
    DB_USER=root
    DB_PASSWORD=sua_senha
    DB_NAME=faladoutor
    DB_PORT=3306

    PORT=3000

---

### 2. ▶️ Iniciar o Backend (API)

    # 1. Entre na pasta do backend
    cd backend

    # 2. Instale as dependências do Node.js
    npm install

    # 3. Inicie o servidor em modo desenvolvimento (com nodemon)
    npm run dev

A API ficará disponível em: **http://localhost:3000**

---

### 3. ▶️ Iniciar o Frontend (Mobile)

⚠️ **Importante:** o Frontend precisa do **endereço IP correto da API**.

Edite o arquivo:

    frontend/lib/services/medico_service.dart

Configure a URL base de acordo com o ambiente:

**Emulador Android:**

    const String baseUrl = 'http://10.0.2.2:3000/api';

**Dispositivo físico:**

    const String baseUrl = 'http://SEU_IP_NA_REDE:3000/api';

Depois:

    # 1. Entre na pasta do frontend
    cd frontend

    # 2. Instale as dependências do Flutter
    flutter pub get

    # 3. Execute o aplicativo
    flutter run

---

## 📡 Endpoints da API (Backend)

A API REST roda na porta **3000** e utiliza o prefixo **`/api`**.  
Exemplo: `http://localhost:3000/api/medicos`

### 🔹 Gerenciamento de Médicos (`/api/medicos`)

| Método | Endpoint                     | Descrição                          |
|--------|------------------------------|------------------------------------|
| POST   | `/api/medicos`              | Cria um novo médico               |
| GET    | `/api/medicos`              | Lista todos os médicos            |
| GET    | `/api/medicos/:id`          | Busca médico por ID               |
| GET    | `/api/medicos/plano/:plano` | Busca médicos por número de plano |
| PUT    | `/api/medicos/:id`          | Atualiza um médico existente      |
| DELETE | `/api/medicos/:id`          | Deleta um médico                  |

### 🔹 Gerenciamento de Pacientes (`/api/pacientes`)

| Método | Endpoint                     | Descrição                          |
|--------|------------------------------|------------------------------------|
| POST   | `/api/pacientes`            | Cria um novo paciente             |
| GET    | `/api/pacientes`            | Lista todos os pacientes          |
| GET    | `/api/pacientes/:id`        | Busca paciente por ID             |
| PUT    | `/api/pacientes/:id`        | Atualiza um paciente existente    |
| DELETE | `/api/pacientes/:id`        | Deleta um paciente                |

---

## 📊 Estrutura do Banco de Dados

### Tabela: `medicos`

| Campo             | Tipo          | Descrição                          |
|-------------------|---------------|------------------------------------|
| `id`              | INT           | ID auto-incremento (**PK**)       |
| `nome`            | VARCHAR(255)  | Nome completo do médico           |
| `cpf`             | VARCHAR(11)   | CPF (único)                       |
| `crm`             | VARCHAR(20)   | CRM (único)                       |
| `plano`           | INT           | Plano (1, 2 ou 3)                 |
| `data_nascimento` | DATE          | Data de nascimento                |

**Restrições:**

- `cpf` e `crm` devem ser **únicos**.  
- `plano` deve ser **1, 2 ou 3**.


# 🖥️ Backend - Fala Doutor API# CRUD de Médicos - Fala Doutor



API REST para gerenciamento de médicos e pacientes.Sistema CRUD completo para gerenciamento de médicos usando Node.js, Express e MySQL.



## 📋 Tecnologias## 📋 Requisitos



- **Node.js** - Runtime JavaScript- Node.js (versão 14 ou superior)

- **Express.js** - Framework web- MySQL Server

- **MySQL2** - Driver MySQL com suporte a Promises- MySQL Workbench (opcional)

- **dotenv** - Gerenciamento de variáveis de ambiente

- **body-parser** - Parse de requisições HTTP## 🚀 Instalação



---1. **Instalar dependências:**

```bash

## 📁 Estruturanpm install

```

```

backend/2. **Configurar banco de dados:**

├── config/   - Certifique-se de que o banco de dados `faladoutor` existe no MySQL

│   └── database.js           # Configuração do MySQL   - Execute o script SQL em `database/schema.sql` no MySQL Workbench para criar a tabela

├── controllers/

│   ├── medicoController.js   # Lógica de médicos3. **Configurar variáveis de ambiente:**

│   └── pacienteController.js # Lógica de pacientes   - Edite o arquivo `.env` com suas credenciais do MySQL:

├── models/   ```

│   ├── medicoModel.js        # Model de médicos   DB_HOST=localhost

│   └── pacienteModel.js      # Model de pacientes   DB_USER=root

├── routes/   DB_PASSWORD=sua_senha_aqui

│   ├── medicoRoutes.js       # Rotas de médicos   DB_NAME=faladoutor

│   └── pacienteRoutes.js     # Rotas de pacientes   DB_PORT=3306

├── database/   PORT=3000

│   ├── schema.sql            # Tabela de médicos   ```

│   └── pacientes_schema.sql  # Tabela de pacientes

├── .env                      # Variáveis de ambiente## ▶️ Executar o Projeto

├── package.json              # Dependências

└── server.js                 # Servidor principal**Modo desenvolvimento (com nodemon):**

``````bash

npm run dev

---```



## 🚀 Instalação**Modo produção:**

```bash

### **1. Instalar dependências:**npm start

```bash```

npm install

```O servidor estará rodando em: `http://localhost:3000`



### **2. Configurar banco de dados:**## 📡 Endpoints da API



No MySQL Workbench, crie o banco:### Criar Médico

```sql- **POST** `/api/medicos`

CREATE DATABASE faladoutor;- Body (JSON):

``````json

{

Execute os scripts:  "nome": "Dr. João Silva",

```sql  "cpf": "12345678901",

-- Tabela de médicos  "crm": "CRM/SP 123456",

SOURCE database/schema.sql;  "data_nascimento": "1980-05-15",

  "plano": 1

-- Tabela de pacientes}

SOURCE database/pacientes_schema.sql;```

```

### Listar Todos os Médicos

### **3. Configurar variáveis de ambiente:**- **GET** `/api/medicos`



Edite o arquivo `.env`:### Buscar Médico por ID

```env- **GET** `/api/medicos/:id`

DB_HOST=localhost

DB_USER=root### Buscar Médicos por Plano

DB_PASSWORD=sua_senha_aqui- **GET** `/api/medicos/plano/:plano`

DB_NAME=faladoutor- Exemplo: `/api/medicos/plano/1`

DB_PORT=3306

PORT=3000### Atualizar Médico

```- **PUT** `/api/medicos/:id`

- Body (JSON):

---```json

{

## ▶️ Executar  "nome": "Dr. João Silva Atualizado",

  "cpf": "12345678901",

### **Modo desenvolvimento (com nodemon):**  "crm": "CRM/SP 123456",

```bash  "data_nascimento": "1980-05-15",

npm run dev  "plano": 2

```}

```

### **Modo produção:**

```bash### Deletar Médico

npm start- **DELETE** `/api/medicos/:id`

```

## 📊 Estrutura do Banco de Dados

Servidor rodando em: `http://localhost:3000`

### Tabela: medicos

---| Campo | Tipo | Descrição |

|-------|------|-----------|

## 📡 Endpoints da API| id | INT | ID auto-incremento (PK) |

| nome | VARCHAR(255) | Nome completo do médico |

### **🏠 Home**| cpf | VARCHAR(11) | CPF (único) |

```| crm | VARCHAR(20) | CRM (único) |

GET /| data_nascimento | DATE | Data de nascimento |

```| plano | INT | Plano (1, 2 ou 3) |

Retorna informações da API e lista de endpoints.| created_at | TIMESTAMP | Data de criação |

| updated_at | TIMESTAMP | Data de atualização |

---

## 🧪 Testando a API

### **👨‍⚕️ Médicos**

Você pode testar usando:

#### Criar Médico- **Postman**

```- **Insomnia**

POST /api/medicos- **cURL**

Content-Type: application/json- **Thunder Client** (extensão do VS Code)



{Exemplo com cURL:

  "nome": "Dr. João Silva",```bash

  "cpf": "12345678901",curl -X POST http://localhost:3000/api/medicos -H "Content-Type: application/json" -d "{\"nome\":\"Dr. Teste\",\"cpf\":\"12345678901\",\"crm\":\"CRM/SP 123456\",\"data_nascimento\":\"1980-01-01\",\"plano\":1}"

  "crm": "123456-SP",```

  "data_nascimento": "1980-05-15",

  "plano": 1## 📁 Estrutura do Projeto

}

``````

FALA DOUTOR G4/

#### Listar Todos├── config/

```│   └── database.js          # Configuração do banco de dados

GET /api/medicos├── controllers/

```│   └── medicoController.js  # Lógica de controle

├── models/

#### Buscar por ID│   └── medicoModel.js       # Model de médico

```├── routes/

GET /api/medicos/:id│   └── medicoRoutes.js      # Rotas da API

```├── database/

│   └── schema.sql           # Script SQL

#### Buscar por Plano├── .env                     # Variáveis de ambiente

```├── package.json             # Dependências

GET /api/medicos/plano/:plano├── server.js                # Servidor principal

```└── README.md                # Documentação

```

#### Atualizar

```## 🔒 Validações

PUT /api/medicos/:id

Content-Type: application/json- Todos os campos são obrigatórios

- CPF deve ser único

{- CRM deve ser único

  "nome": "Dr. João Silva",- Plano deve ser 1, 2 ou 3

  "cpf": "12345678901",

  "crm": "123456-SP",## 🛠️ Tecnologias Utilizadas

  "data_nascimento": "1980-05-15",

  "plano": 2- Node.js

}- Express.js

```- MySQL2

- dotenv

#### Deletar- body-parser

```
DELETE /api/medicos/:id
```

---

### **👤 Pacientes**

#### Criar Paciente
```
POST /api/pacientes
Content-Type: application/json

{
  "nome": "Ana Silva",
  "cpf": "11111111111",
  "data_nascimento": "1990-03-15",
  "plano": 1
}
```

#### Listar Todos
```
GET /api/pacientes
```

#### Buscar por ID
```
GET /api/pacientes/:id
```

#### Buscar por Plano
```
GET /api/pacientes/plano/:plano
```

#### Atualizar
```
PUT /api/pacientes/:id
Content-Type: application/json

{
  "nome": "Ana Silva Santos",
  "cpf": "11111111111",
  "data_nascimento": "1990-03-15",
  "plano": 2
}
```

#### Deletar
```
DELETE /api/pacientes/:id
```

---

## 🗄️ Estrutura das Tabelas

### **Tabela: medicos**
| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | INT | ID auto-incremento (PK) |
| nome | VARCHAR(255) | Nome completo |
| cpf | VARCHAR(11) | CPF (único) |
| crm | VARCHAR(20) | CRM (único) |
| data_nascimento | DATE | Data de nascimento |
| plano | INT | Plano (1, 2 ou 3) |
| created_at | TIMESTAMP | Data de criação |
| updated_at | TIMESTAMP | Data de atualização |

### **Tabela: pacientes**
| Campo | Tipo | Descrição |
|-------|------|-----------|
| id | INT | ID auto-incremento (PK) |
| nome | VARCHAR(255) | Nome completo |
| cpf | VARCHAR(11) | CPF (único) |
| data_nascimento | DATE | Data de nascimento |
| plano | INT | Plano (1, 2 ou 3) |
| created_at | TIMESTAMP | Data de criação |
| updated_at | TIMESTAMP | Data de atualização |

---

## ✅ Validações

- Todos os campos são obrigatórios
- CPF deve ser único
- CRM deve ser único (médicos)
- Plano deve ser 1, 2 ou 3
- Data de nascimento em formato YYYY-MM-DD

---

## 🧪 Testar a API

### **cURL**
```bash
curl http://localhost:3000/api/medicos
```

### **Postman/Insomnia**
Importe as requisições ou crie manualmente.

### **Navegador**
```
http://localhost:3000
http://localhost:3000/api/medicos
```

---

## 🛠️ Comandos Úteis

### **Ver médicos no MySQL:**
```sql
SELECT * FROM faladoutor.medicos;
```

### **Ver pacientes no MySQL:**
```sql
SELECT * FROM faladoutor.pacientes;
```

### **Limpar tabelas:**
```sql
TRUNCATE TABLE faladoutor.medicos;
TRUNCATE TABLE faladoutor.pacientes;
```

---

## 🐛 Problemas Comuns

| Erro | Solução |
|------|---------|
| `ECONNREFUSED` | MySQL não está rodando |
| `ER_ACCESS_DENIED` | Senha incorreta no .env |
| `ER_BAD_DB_ERROR` | Banco faladoutor não existe |
| `ER_NO_SUCH_TABLE` | Execute os scripts SQL |
| `ER_DUP_ENTRY` | CPF ou CRM duplicado |
| `Porta 3000 ocupada` | Mude PORT no .env |

---

## 📦 Dependências

```json
{
  "express": "^4.18.2",
  "mysql2": "^3.6.0",
  "dotenv": "^16.3.1",
  "body-parser": "^1.20.2"
}
```

---

## 🔒 Segurança

- ✅ Prepared statements (SQL Injection)
- ✅ Validações em múltiplas camadas
- ✅ Variáveis de ambiente
- ✅ Constraints no banco de dados

---

## 📝 Arquitetura

**Padrão MVC (Model-View-Controller)**

- **Model:** Comunicação com banco de dados
- **Controller:** Lógica de negócio e validações
- **Routes:** Definição de endpoints

---

**✅ Backend configurado e pronto para uso!**

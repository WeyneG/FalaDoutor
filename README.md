# 🏥 Fala Doutor - Sistema de Gerenciamento Médico# CRUD de Médicos - Fala Doutor



Sistema completo de gerenciamento de médicos e pacientes com backend em Node.js e frontend mobile em Flutter.Sistema CRUD completo para gerenciamento de médicos usando Node.js, Express e MySQL.



## 📁 Estrutura do Projeto## 📋 Requisitos



```- Node.js (versão 14 ou superior)

FALA DOUTOR G4/- MySQL Server

├── backend/           # API REST em Node.js + Express + MySQL- MySQL Workbench (opcional)

└── frontend/          # Aplicativo mobile em Flutter

```## 🚀 Instalação



---1. **Instalar dependências:**

```bash

## 🚀 Início Rápidonpm install

```

### **1. Backend (API)**

2. **Configurar banco de dados:**

```bash   - Certifique-se de que o banco de dados `faladoutor` existe no MySQL

cd backend   - Execute o script SQL em `database/schema.sql` no MySQL Workbench para criar a tabela

npm install

npm run dev3. **Configurar variáveis de ambiente:**

```   - Edite o arquivo `.env` com suas credenciais do MySQL:

   ```

O servidor estará rodando em: `http://localhost:3000`   DB_HOST=localhost

   DB_USER=root

### **2. Frontend (Flutter)**   DB_PASSWORD=sua_senha_aqui

   DB_NAME=faladoutor

```bash   DB_PORT=3306

cd frontend   PORT=3000

flutter pub get   ```

flutter run

```## ▶️ Executar o Projeto



**⚠️ Importante:** Configure o IP da API no arquivo `frontend/lib/services/medico_service.dart`**Modo desenvolvimento (com nodemon):**

```bash

---npm run dev

```

## 🔧 Tecnologias Utilizadas

**Modo produção:**

### **Backend**```bash

- Node.jsnpm start

- Express.js```

- MySQL

- dotenvO servidor estará rodando em: `http://localhost:3000`



### **Frontend**## 📡 Endpoints da API

- Flutter

- Dart### Criar Médico

- HTTP package- **POST** `/api/medicos`

- Material Design 3- Body (JSON):

```json

---{

  "nome": "Dr. João Silva",

## 📊 Banco de Dados  "cpf": "12345678901",

  "crm": "CRM/SP 123456",

**Banco:** `faladoutor`  "data_nascimento": "1980-05-15",

  "plano": 1

**Tabelas:**}

- `medicos` - Gerenciamento de médicos```

- `pacientes` - Gerenciamento de pacientes

### Listar Todos os Médicos

---- **GET** `/api/medicos`



## 📡 API Endpoints### Buscar Médico por ID

- **GET** `/api/medicos/:id`

### **Médicos**

- `POST /api/medicos` - Criar médico### Buscar Médicos por Plano

- `GET /api/medicos` - Listar todos- **GET** `/api/medicos/plano/:plano`

- `GET /api/medicos/:id` - Buscar por ID- Exemplo: `/api/medicos/plano/1`

- `GET /api/medicos/plano/:plano` - Buscar por plano

- `PUT /api/medicos/:id` - Atualizar### Atualizar Médico

- `DELETE /api/medicos/:id` - Deletar- **PUT** `/api/medicos/:id`

- Body (JSON):

### **Pacientes**```json

- `POST /api/pacientes` - Criar paciente{

- `GET /api/pacientes` - Listar todos  "nome": "Dr. João Silva Atualizado",

- `GET /api/pacientes/:id` - Buscar por ID  "cpf": "12345678901",

- `GET /api/pacientes/plano/:plano` - Buscar por plano  "crm": "CRM/SP 123456",

- `PUT /api/pacientes/:id` - Atualizar  "data_nascimento": "1980-05-15",

- `DELETE /api/pacientes/:id` - Deletar  "plano": 2

}

---```



## 📱 Funcionalidades do App### Deletar Médico

- **DELETE** `/api/medicos/:id`

✅ Tela inicial elegante

✅ Listagem de médicos## 📊 Estrutura do Banco de Dados

✅ Cadastro de médicos

✅ Edição de médicos### Tabela: medicos

✅ Exclusão de médicos| Campo | Tipo | Descrição |

✅ Visualização de detalhes|-------|------|-----------|

✅ Validações completas| id | INT | ID auto-incremento (PK) |

✅ Design moderno| nome | VARCHAR(255) | Nome completo do médico |

| cpf | VARCHAR(11) | CPF (único) |

---| crm | VARCHAR(20) | CRM (único) |

| data_nascimento | DATE | Data de nascimento |

## 📝 Configuração Inicial| plano | INT | Plano (1, 2 ou 3) |

| created_at | TIMESTAMP | Data de criação |

### **1. Banco de Dados**| updated_at | TIMESTAMP | Data de atualização |



No MySQL Workbench, execute os scripts:## 🧪 Testando a API

- `backend/database/schema.sql` (tabela de médicos)

- `backend/database/pacientes_schema.sql` (tabela de pacientes)Você pode testar usando:

- **Postman**

### **2. Variáveis de Ambiente**- **Insomnia**

- **cURL**

Configure o arquivo `backend/.env`:- **Thunder Client** (extensão do VS Code)

```env

DB_HOST=localhostExemplo com cURL:

DB_USER=root```bash

DB_PASSWORD=sua_senhacurl -X POST http://localhost:3000/api/medicos -H "Content-Type: application/json" -d "{\"nome\":\"Dr. Teste\",\"cpf\":\"12345678901\",\"crm\":\"CRM/SP 123456\",\"data_nascimento\":\"1980-01-01\",\"plano\":1}"

DB_NAME=faladoutor```

DB_PORT=3306

PORT=3000## 📁 Estrutura do Projeto

```

```

### **3. IP da API (Frontend)**FALA DOUTOR G4/

├── config/

Edite `frontend/lib/services/medico_service.dart`:│   └── database.js          # Configuração do banco de dados

- **Emulador Android:** `http://10.0.2.2:3000/api`├── controllers/

- **Dispositivo Físico:** `http://SEU_IP:3000/api`│   └── medicoController.js  # Lógica de controle

├── models/

---│   └── medicoModel.js       # Model de médico

├── routes/

## 🎯 Como Testar│   └── medicoRoutes.js      # Rotas da API

├── database/

1. **Inicie o backend:**│   └── schema.sql           # Script SQL

   ```bash├── .env                     # Variáveis de ambiente

   cd backend├── package.json             # Dependências

   npm run dev├── server.js                # Servidor principal

   ```└── README.md                # Documentação

```

2. **Inicie o frontend:**

   ```bash## 🔒 Validações

   cd frontend

   flutter run- Todos os campos são obrigatórios

   ```- CPF deve ser único

- CRM deve ser único

3. **Teste no navegador (API):**- Plano deve ser 1, 2 ou 3

   ```

   http://localhost:3000## 🛠️ Tecnologias Utilizadas

   ```

- Node.js

---- Express.js

- MySQL2

## 📚 Documentação Detalhada- dotenv

- body-parser

- [Backend README](backend/README.md)
- [Frontend README](frontend/README.md)

---

## 👥 Desenvolvido por

Projeto desenvolvido para o sistema Fala Doutor

---

## 📄 Licença

Este projeto é de uso educacional.

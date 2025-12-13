const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
require('dotenv').config();

const medicoRoutes = require('./routes/medicoRoutes');
const pacienteRoutes = require('./routes/pacienteRoutes');
const planoRoutes = require('./routes/planoRoutes');
const consultaRoutes = require('./routes/consultaRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors()); // Habilita CORS para todas as origens
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Rota inicial
app.get('/', (req, res) => {
  res.json({ 
    message: 'API Fala Doutor - Sistema de Gestão Médica',
    version: '3.0.0',
    endpoints: {
      medicos: {
        'POST /api/medicos': 'Criar novo médico',
        'GET /api/medicos': 'Listar todos os médicos',
        'GET /api/medicos/:id': 'Buscar médico por ID',
        'GET /api/medicos/plano/:plano': 'Buscar médicos por plano_id',
        'PUT /api/medicos/:id': 'Atualizar médico',
        'DELETE /api/medicos/:id': 'Deletar médico'
      },
      pacientes: {
        'POST /api/pacientes': 'Criar novo paciente',
        'GET /api/pacientes': 'Listar todos os pacientes',
        'GET /api/pacientes/:id': 'Buscar paciente por ID',
        'GET /api/pacientes/plano/:plano': 'Buscar pacientes por plano_id',
        'PUT /api/pacientes/:id': 'Atualizar paciente',
        'DELETE /api/pacientes/:id': 'Deletar paciente'
      },
      planos: {
        'POST /api/planos': 'Criar novo plano',
        'GET /api/planos': 'Listar todos os planos',
        'GET /api/planos/:id': 'Buscar plano por ID',
        'PUT /api/planos/:id': 'Atualizar plano',
        'DELETE /api/planos/:id': 'Deletar plano'
      },
      consultas: {
        'POST /api/consultas': 'Agendar nova consulta',
        'GET /api/consultas': 'Listar todas as consultas',
        'GET /api/consultas/:id': 'Buscar consulta por ID',
        'GET /api/consultas/paciente/:pacienteId/medicos': 'Buscar médicos disponíveis para o paciente',
        'PUT /api/consultas/:id': 'Atualizar consulta',
        'DELETE /api/consultas/:id': 'Deletar consulta'
      }
    }
  });
});

// Rotas da API
app.use('/api', medicoRoutes);
app.use('/api', pacienteRoutes);
app.use('/api', planoRoutes);
app.use('/api/consultas', consultaRoutes);

// Tratamento de rotas não encontradas
app.use((req, res) => {
  res.status(404).json({ 
    error: 'Rota não encontrada' 
  });
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Acesse: http://localhost:${PORT}`);
});

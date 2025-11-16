const express = require('express');
const router = express.Router();
const PacienteController = require('../controllers/pacienteController');

// Rotas para pacientes
router.post('/pacientes', PacienteController.create);           // Criar paciente
router.get('/pacientes', PacienteController.getAll);            // Listar todos
router.get('/pacientes/:id', PacienteController.getById);       // Buscar por ID
router.get('/pacientes/plano/:plano', PacienteController.getByPlano); // Buscar por plano
router.put('/pacientes/:id', PacienteController.update);        // Atualizar paciente
router.delete('/pacientes/:id', PacienteController.delete);     // Deletar paciente

module.exports = router;

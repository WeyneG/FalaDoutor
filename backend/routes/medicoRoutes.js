const express = require('express');
const router = express.Router();
const MedicoController = require('../controllers/medicoController');

// Rotas para médicos
router.post('/medicos', MedicoController.create);           // Criar médico
router.get('/medicos', MedicoController.getAll);            // Listar todos
router.get('/medicos/:id', MedicoController.getById);       // Buscar por ID
router.get('/medicos/plano/:plano', MedicoController.getByPlano); // Buscar por plano
router.put('/medicos/:id', MedicoController.update);        // Atualizar médico
router.delete('/medicos/:id', MedicoController.delete);     // Deletar médico

module.exports = router;

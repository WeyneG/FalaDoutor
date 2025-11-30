const express = require('express');
const router = express.Router();
const PlanoController = require('../controllers/planoController');

// Rotas para planos
router.post('/planos', PlanoController.create);           // Criar plano
router.get('/planos', PlanoController.getAll);            // Listar todos
router.get('/planos/:id', PlanoController.getById);       // Buscar por ID
router.put('/planos/:id', PlanoController.update);        // Atualizar plano
router.delete('/planos/:id', PlanoController.delete);     // Deletar plano

module.exports = router;

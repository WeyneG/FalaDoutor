const express = require('express');
const router = express.Router();
const ConsultaController = require('../controllers/consultaController');

// Rotas de consultas
router.get('/', ConsultaController.getAll);
router.get('/:id', ConsultaController.getById);
router.get('/paciente/:pacienteId/medicos', ConsultaController.getMedicosByPaciente);
router.post('/', ConsultaController.create);
router.put('/:id', ConsultaController.update);
router.delete('/:id', ConsultaController.delete);

module.exports = router;

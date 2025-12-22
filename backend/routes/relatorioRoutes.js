const express = require('express');
const router = express.Router();
const RelatorioController = require('../controllers/relatorioController');

router.get('/medicos', RelatorioController.getRelatorioMedicos);
router.get('/pacientes', RelatorioController.getRelatorioPacientes);
router.get('/consultas', RelatorioController.getRelatorioConsultas);

module.exports = router;

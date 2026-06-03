const express = require('express');
const router = express.Router();
const { registerStudent } = require('../controllers/studentController');

// POST / - Register a new student
router.post('/', registerStudent);

module.exports = router;

const express = require('express');
const router = express.Router();
const authController = require('./auth.controller');

// URL Akhir: POST http://localhost:3000/api/auth/admin/login
router.post('/admin/login', authController.loginAdmin);

module.exports = router;
const express = require('express');
const router = express.Router();
const controller = require('./admin_log.controller');
const { verifyToken } = require('../../core/middleware/auth.middleware');

// GET /api/admin-logs
router.get('/', verifyToken (["admin"]), controller.getLogs);

module.exports = router;
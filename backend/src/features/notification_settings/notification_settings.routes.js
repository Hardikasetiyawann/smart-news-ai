const router = require('express').Router();
const controller = require('./notification_settings.controller');
const { verifyToken } = require('../../core/middleware/auth.middleware');

router.get('/', verifyToken(['user']), controller.getSettings);
router.put('/', verifyToken(['user']), controller.updateSettings);

module.exports = router;

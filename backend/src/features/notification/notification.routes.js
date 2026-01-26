const router = require('express').Router();
const controller = require('./notification.controller');
const { verifyToken } = require('../../core/middleware/auth.middleware');

router.get('/', verifyToken(['user']), controller.getNotifications);
router.patch('/:id/read', verifyToken(['user']), controller.markAsRead);
router.delete('/:id', verifyToken(['user']), controller.deleteNotification);

module.exports = router;

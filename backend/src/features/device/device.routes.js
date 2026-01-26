const router = require('express').Router();
const controller = require('./device.controller');
const { verifyToken } = require('../../core/middleware/auth.middleware');

router.post(
  '/devices',
  verifyToken(['user']),
  controller.storeToken
);

router.delete(
  '/devices',
  verifyToken(['user']),
  controller.removeToken
);

module.exports = router;

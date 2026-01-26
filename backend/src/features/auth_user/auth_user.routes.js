const express = require('express');
const router = express.Router();
const controller = require('./auth_user.controller');
const firebaseAuth = require('../../core/middleware/firebaseAuth');
const { verifyToken } = require('../../core/middleware/auth.middleware');
const uploadAvatar = require('../../core/middleware/uploadAvatar');

// LOGIN
router.post('/login', firebaseAuth, controller.login);

// USER
router.get('/me', verifyToken(['user', 'admin']), controller.getUser);
// UPDATE PROFILE
router.patch(
  '/profile',
  verifyToken(['user', 'admin']),
  uploadAvatar.single('avatar'),
  controller.updateProfile
);

// ADMIN
router.get('/users', verifyToken(['admin']), controller.getAllUsers);
router.get('/:id', verifyToken(['admin']), controller.getUserById);
router.patch('/:id/block', verifyToken(['admin']), controller.toggleBlockUser);
router.delete('/:id', verifyToken(['admin']), controller.deleteUser);

module.exports = router;

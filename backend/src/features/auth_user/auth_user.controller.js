const { User } = require('../../core/config/model');
const jwt = require('jsonwebtoken');
require('dotenv').config();

/* =========================
   LOGIN (Firebase → JWT)
========================== */
exports.login = async (req, res) => {
  try {
    console.log('MASUK LOGIN FIREBASE');

    const fb = req.firebaseUser;
    if (!fb) {
      return res.status(401).json({
        status: false,
        message: 'Firebase user not found',
      });
    }

    const email = fb.email || `${fb.uid}@phone.firebase`;

    const provider =
      fb.firebase?.sign_in_provider === 'google.com'
        ? 'google'
        : fb.firebase?.sign_in_provider === 'password'
          ? 'email'
          : fb.firebase?.sign_in_provider === 'phone'
            ? 'phone'
            : 'firebase';

    // JANGAN PAKE findOrCreate (RAWAN HANG)
    let user = await User.findOne({
      where: { firebase_uid: fb.uid },
    });

    if (!user) {
      user = await User.create({
        firebase_uid: fb.uid,
        email,
        full_name: fb.name || 'User',
        image_url: fb.picture || null,
        auth_provider: provider,
        is_active: true,
      });
    } else {
      if (user.is_active === false) {
        return res.status(403).json({
          status: false,
          message: 'Akun Anda diblokir oleh admin',
        });
      }

      await user.update({
        email,
        auth_provider: provider,
      });
    }

    const token = jwt.sign(
      {
        id: user.id,
        role: 'user',
        email: user.email,
      },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    console.log('JWT GENERATED');
    console.log('RETURN RESPONSE LOGIN');

    return res.status(200).json({
      status: true,
      message: 'Login success',
      token,
      data: user,
    });
  } catch (error) {
    console.error('AUTH_LOGIN_ERROR:', error);
    return res.status(500).json({
      status: false,
      message: 'Internal server error',
    });
  }
};

/* =========================
   USER: GET PROFILE SENDIRI
========================== */
exports.getUser = async (req, res) => {
  try {
    const user = await User.findByPk(req.auth.id);

    if (!user) {
      return res.status(404).json({
        status: false,
        message: 'User not found',
      });
    }

    return res.json({
      status: true,
      data: user,
    });
  } catch (error) {
    console.error('GET_ME_ERROR:', error);
    return res.status(500).json({
      status: false,
      message: 'Internal server error',
    });
  }
};

/* =========================
   ADMIN: GET ALL USERS
========================== */
exports.getAllUsers = async (req, res) => {
  const users = await User.findAll({
    order: [['created_at', 'DESC']],
  });

  res.json({
    status: true,
    total: users.length,
    data: users,
  });
};

/* =========================
   ADMIN: GET USER BY ID
========================== */
exports.getUserById = async (req, res) => {
  const user = await User.findByPk(req.params.id);

  if (!user) {
    return res.status(404).json({
      status: false,
      message: 'User not found',
    });
  }

  res.json({ status: true, data: user });
};

/* =========================
   ADMIN: BLOCK / UNBLOCK USER
========================== */
const { Sequelize } = require('sequelize');

exports.toggleBlockUser = async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);

    if (!user) {
      return res.status(404).json({
        status: false,
        message: 'User not found',
      });
    }

    // BOOLEAN SAFE TOGGLE
    user.is_active = !user.is_active;
    await user.save();

    return res.json({
      status: true,
      message: user.is_active
        ? 'User berhasil diaktifkan'
        : 'User berhasil diblokir',
      data: {
        id: user.id,
        is_active: user.is_active,
      },
    });
  } catch (error) {
    console.error('TOGGLE_USER_ERROR:', error);
    return res.status(500).json({
      status: false,
      message: 'Gagal mengubah status user',
    });
  }
};



/* =========================
   ADMIN: DELETE USER
========================== */
exports.deleteUser = async (req, res) => {
  const user = await User.findByPk(req.params.id);

  if (!user) {
    return res.status(404).json({
      status: false,
      message: 'User not found',
    });
  }

  await user.destroy();

  res.json({
    status: true,
    message: 'User berhasil dihapus',
  });
};

exports.updateProfile = async (req, res) => {
  try {
    const user = await User.findByPk(req.auth.id);

    if (!user) {
      return res.status(404).json({
        status: false,
        message: "User not found",
      });
    }

    // 🔍 DEBUG DI SINI (WAJIB)
    console.log('BODY:', req.body);
    console.log('FILE:', req.file);
    console.log('BEFORE image_url:', user.image_url);

    const { full_name } = req.body;

    if (full_name) {
      user.full_name = full_name;
    }

    if (req.file) {
      user.image_url = `/api/uploads/avatar/${req.file.filename}`;
    }

    await user.save();

    console.log('AFTER image_url:', user.image_url);

    return res.json({
      status: true,
      message: "Profile updated successfully",
      data: {
        id: user.id,
        full_name: user.full_name,
        email: user.email,
        image_url: user.image_url,
      },
    });
  } catch (error) {
    console.error("UPDATE_PROFILE_ERROR:", error);
    return res.status(500).json({
      status: false,
      message: "Failed to update profile",
    });
  }
};
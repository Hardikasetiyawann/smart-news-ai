const admin = require('../config/firebase');

module.exports = async (req, res, next) => {
  const authHeader = req.headers.authorization;

  console.log('FIREBASE AUTH MIDDLEWARE TERPANGGIL');


  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      status: false,
      message: 'Authorization token missing',
    });
  }

  const token = authHeader.split(' ')[1];

  try {
    // Verifikasi Firebase ID Token
    const decodedToken = await admin.auth().verifyIdToken(token);

    // LOGGING YANG BENAR (DEBUG ONLY)
    if (process.env.NODE_ENV !== 'production') {
      console.log('FIREBASE USER (decoded ID token)');
      console.log({
        uid: decodedToken.uid,
        email: decodedToken.email,
        provider: decodedToken.firebase?.sign_in_provider,
        auth_time: decodedToken.auth_time,
        exp: decodedToken.exp,
      });
    }

    // Simpan hasil verifikasi ke request
    req.firebaseUser = decodedToken;
    next();
  } catch (error) {
    return res.status(401).json({
      status: false,
      message: 'Invalid or expired Firebase token',
    });
  }
};

const jwt = require("jsonwebtoken");
require("dotenv").config();

/**
 * Middleware JWT + Role Based
 * @param {Array} allowedRoles - contoh: ['admin'] atau ['user', 'admin']
 */
const verifyToken = (allowedRoles = []) => {
  return (req, res, next) => {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.split(" ")[1];

    if (!token) {
      return res.status(401).json({
        success: false,
        message: "Akses ditolak! Token tidak ada.",
      });
    }

    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
      if (err) {
        return res.status(403).json({
          success: false,
          message: "Token tidak valid atau kadaluarsa.",
        });
      }

      if (allowedRoles.length && !allowedRoles.includes(decoded.role)) {
        return res.status(403).json({
          success: false,
          message: "Akses ditolak! Role tidak diizinkan.",
        });
      }

      // INI PENTING
      req.auth = {
        id: decoded.id,
        role: decoded.role,
        email: decoded.email,
      };

      next();
    });
  };
};

module.exports = { verifyToken };
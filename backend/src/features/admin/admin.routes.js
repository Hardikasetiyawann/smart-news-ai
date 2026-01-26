const express = require("express");
const router = express.Router();
const adminController = require("./admin.controller");
const { verifyToken } = require("../../core/middleware/auth.middleware");

/* ======================================================
   DASHBOARD
   GET /api/admin/dashboard
====================================================== */
router.get(
  "/dashboard",
  verifyToken(["admin"]),
  adminController.getDashboardStats
);

/* ======================================================
   CREATE ADMIN (SUPER ADMIN ONLY)
   POST /api/admin
====================================================== */
router.post(
  "/",
  verifyToken(["admin"]),
  adminController.createAdmin
);

/* ======================================================
   GET ALL ADMINS
   GET /api/admin
====================================================== */
router.get(
  "/",
  verifyToken(["admin"]),
  adminController.getAllAdmins
);

/* ======================================================
   GET ADMIN BY ID
   GET /api/admin/:id
====================================================== */
router.get(
  "/:id",
  verifyToken(["admin"]),
  adminController.getAdminById
);

/* ======================================================
   UPDATE ADMIN (SUPER ADMIN ONLY)
   PUT /api/admin/:id
====================================================== */
router.put(
  "/:id",
  verifyToken(["admin"]),
  adminController.updateAdmin
);

/* ======================================================
   DELETE ADMIN (SUPER ADMIN ONLY)
   DELETE /api/admin/:id
====================================================== */
router.delete(
  "/:id",
  verifyToken(["admin"]),
  adminController.deleteAdmin
);

module.exports = router;

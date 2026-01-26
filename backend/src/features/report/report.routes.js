const express = require("express");
const router = express.Router();
const controller = require("./report.controller");
const { verifyToken } = require("../../core/middleware/auth.middleware");

/* =========================
   ADMIN ONLY
========================= */
router.get(
  "/",
  verifyToken(["admin"]),
  controller.getAllReports
);

router.get(
  "/:id",
  verifyToken(["admin"]),
  controller.getReportById
);

router.patch(
  "/:id",
  verifyToken(["admin"]),
  controller.updateReportStatus
);

router.delete(
  "/:id",
  verifyToken(["admin"]),
  controller.deleteReport
);

/* =========================
   USER ONLY
========================= */
router.post(
  "/",
  verifyToken(["user"]),
  controller.createReport
);

module.exports = router;

const express = require("express");
const router = express.Router();

const { verifyToken } = require("../../core/middleware/auth.middleware");
const { uploadNewsImage } = require("../../core/middleware/upload_news.middleware");
const controller = require("./news.controller");

/* =========================
   USER & ADMIN (WAJIB TOKEN)
========================= */

router.get(
  "/search", 
  verifyToken(["user", "admin"]), 
  controller.searchNews
);

// Dashboard
router.get(
  "/latest",
  verifyToken(["user", "admin"]),
  controller.getLatestNews
);

router.get(
  "/trending",
  verifyToken(["user", "admin"]),
  controller.getTrendingNews
);

// Detail
router.get(
  "/:id/interactions",
  verifyToken(["user", "admin"]),
  controller.getNewsInteractions
);

// Detail news
router.get(
  "/:id",
  verifyToken(["user", "admin"]),
  controller.getNewsById
);

// Filter
router.get(
  "/kategori/:id",
  verifyToken(["user", "admin"]),
  controller.getNewsByCategoryId
);

router.get(
  "/publisher/:id",
  verifyToken(["user", "admin"]),
  controller.getNewsByPublisherId
);

// Semua news (misalnya dashboard admin / user login)
router.get(
  "/",
  verifyToken(["user", "admin"]),
  controller.getAllNews
);

router.post(
  "/:id/view",
  verifyToken(["user", "admin"]),
  controller.recordNewsView
);



/* =========================
   ADMIN ONLY
========================= */

router.post(
  "/",
  verifyToken(["admin"]),
  uploadNewsImage.single("image"),
  controller.createNews
);

router.put(
  "/:id",
  verifyToken(["admin"]),
  uploadNewsImage.single("image"),
  controller.updateNews
);

router.delete(
  "/:id",
  verifyToken(["admin"]),
  controller.deleteNews
);

module.exports = router;

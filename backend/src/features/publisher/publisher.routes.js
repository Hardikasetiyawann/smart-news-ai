const express = require("express");
const router = express.Router();
const controller = require("./publisher.controller");
const { verifyToken } = require("../../core/middleware/auth.middleware");
const upload = require("../../core/middleware/publishers.upload.middleware");

/* =========================
   GET (USER & ADMIN)
========================= */
router.get("/", verifyToken(["user", "admin"]), controller.getAllPublishers);
router.get("/:id", verifyToken(["user", "admin"]), controller.getPublisherById);

/* =========================
   ADMIN ONLY
========================= */

// CREATE publisher + upload logo
router.post(
  "/",
  verifyToken(["admin"]),
  upload.single("logo"), // ⬅️ WAJIB
  controller.createPublisher
);

// UPDATE publisher + upload logo
router.put(
  "/:id",
  verifyToken(["admin"]),
  upload.single("logo"), // ⬅️ WAJIB
  controller.updatePublisher
);

// DELETE publisher
router.delete(
  "/:id",
  verifyToken(["admin"]),
  controller.deletePublisher
);

module.exports = router;

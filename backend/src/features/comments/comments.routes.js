const express = require("express");
const router = express.Router();
const { verifyToken } = require("../../core/middleware/auth.middleware");
const controller = require("./comments.controller");



/* =========================
   PUBLIC
========================= */

router.get("/", controller.getAllComments);

/* =========================
   COMMENT DETAIL (USER + ADMIN)
========================= */
router.get(
  "/detail/:id",
  verifyToken(["user", "admin"], true),
  controller.getCommentDetail
);


router.get("/:id", controller.getCommentById);

/* =========================
   USER & ADMIN
========================= */

router.get(
  "/user/:user_id",
  verifyToken(["user", "admin"]),
  controller.getCommentsByUserId
);
router.get(
  "/news/:news_id",
  verifyToken(["user", "admin"], true),
  controller.getCommentsByNewsId
);
router.post(
  "/",
  verifyToken(["user", "admin"]),
  controller.createComment
);

router.put(
  "/:id",
  verifyToken(["user", "admin"]),
  controller.updateComment
);

router.delete(
  "/:id",
  verifyToken(["user", "admin"]),
  controller.deleteComment
);

module.exports = router;

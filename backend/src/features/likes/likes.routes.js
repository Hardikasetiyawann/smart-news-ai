const express = require("express");
const router = express.Router();

const { verifyToken } = require("../../core/middleware/auth.middleware");
const controller = require("./likes.controller");


router.get(
  "/",
  verifyToken(["user"]),
  controller.getLikedNews
);

router.post(
  "/:newsId",
  verifyToken(["user"]),
  controller.likeNews
);

router.delete(
  "/:newsId",
  verifyToken(["user"]),
  controller.unlikeNews
);

module.exports = router;
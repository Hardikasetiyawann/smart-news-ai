const express = require("express");
const router = require("express").Router();
const controller = require("./history.controller");
const { verifyToken } = require("../../core/middleware/auth.middleware");

router.use(verifyToken(['user']));

router.get("/", controller.getUserHistory);
router.post("/", controller.recordRead);
router.delete("/:news_id", controller.deleteOneHistory);
router.delete("/", controller.clearHistory);

module.exports = router;
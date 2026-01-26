const express = require("express");
const router = express.Router();
const controller = require("./ai_summary.controller");

// GET ALL AI SUMMARY (ADMIN)
//http://localhost:3000/api/ai-summary
router.get("/", controller.getAllAiSummariesAdmin);


// GET STATUS SUMMARY PER NEWS (ADMIN)
//http://localhost:3000/api/ai-summary/status/news
router.get("/status/news", controller.getSummaryStatusAdmin);


// GET / CREATE SUMMARY BY NEWS ID
router.get("/:news_id", controller.getOrCreateSummary);

module.exports = router;

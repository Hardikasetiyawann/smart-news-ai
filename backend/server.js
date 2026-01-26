require('dotenv').config();
require('./src/core/config/firebase');

const express = require('express');
const cors = require('cors');
const bodyParser = require("body-parser");
require("./src/core/config/model");

const path = require("path");
const multer = require("multer");

const app = express();

/* =========================
    CONFIG
========================= */

const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(bodyParser.urlencoded({ extended: true }));

/* =========================
    GLOBAL MIDDLEWARE
    (WAJIB DI ATAS ROUTE)
========================= */

// logging news
const logNewsRequest = require("./src/core/middleware/news.middleware");
app.use(logNewsRequest);

// logging comment
const logCommentRequest = require("./src/core/middleware/comment.middleware");
app.use(logCommentRequest);

/* =========================
    AUTH ROUTES
========================= */

// Admin auth
app.use('/api/auth', require('./src/features/auth/auth.routes'));

// User auth (Firebase)
app.use('/api/auth-user', require('./src/features/auth_user/auth_user.routes'));

/* =========================
    ROUTES AUTH & MASTER
========================= */

app.use('/api/admin', require('./src/features/admin/admin.routes'));
app.use('/api/publishers', require('./src/features/publisher/publisher.routes'));
app.use('/api/categories', require('./src/features/category/category.routes'));
app.use('/api/admin-logs', require('./src/features/admin_logs/admin_log.routes'));
app.use('/api/likes', require('./src/features/likes/likes.routes'));
app.use("/api/ai-summary", require("./src/features/ai_summary/ai_summary.routes"));
app.use('/api/history', require('./src/features/history/history.routes'));
app.use('/api/notifications', require('./src/features/notification/notification.routes'));
app.use('/api', require('./src/features/device/device.routes')); 
app.use('/api/uploads', express.static('public/uploads'));
app.use(
  '/api/notification-settings',
  require('./src/features/notification_settings/notification_settings.routes')
);


/* =========================
    ROUTES NEWS, COMMENT & REPORT
========================= */

app.use("/api/reports", require("./src/features/report/report.routes"));
app.use("/api/news", require("./src/features/news/news.routes"));
app.use("/api/comments", require("./src/features/comments/comments.routes"));

/* =========================
    MULTER ERROR HANDLER
========================= */
app.use((err, req, res, next) => {
  if (err instanceof multer.MulterError) {
    if (err.code === "LIMIT_FILE_SIZE") {
      return res.status(400).json({
        success: false,
        message: "Image size must be less than 10 MB",
      });
    }
  }

  if (err.message?.includes("Only image files")) {
    return res.status(400).json({
      success: false,
      message: err.message,
    });
  }

  next(err);
});

/* =========================
    DATABASE
========================= */

const sequelize = require("./src/core/config/db");

sequelize.authenticate()
  .then(() => console.log("✅ Database connected"))
  .catch((err) => console.log("❌ DB error:", err));

/* =========================
   START SERVER
========================= */

app.listen(PORT, () => {
  console.log(`🚀 Server berjalan di http://localhost:${PORT}`);
});

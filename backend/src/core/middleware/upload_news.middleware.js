const multer = require("multer");
const path = require("path");
const fs = require("fs");

// ==========================
// CONFIG
// ==========================
const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10 MB
const uploadDir = path.join(__dirname, "..", "..", "..","public", "uploads", "news");

// auto-create folder if not exists
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

// ==========================
// STORAGE
// ==========================
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueName =
      Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, uniqueName + path.extname(file.originalname));
  },
});

// ==========================
// FILE FILTER (IMAGE ONLY)
// ==========================
const fileFilter = (req, file, cb) => {
 const allowedTypes = [
  "image/jpeg",
  "image/jpg",
  "image/png",
  "image/webp",
  "application/octet-stream"
];

  if (!allowedTypes.includes(file.mimetype)) {
    return cb(
      new Error("Only image files (JPG, PNG, WEBP) are allowed"),
      false
    );
  }

  cb(null, true);
};

// ==========================
// MULTER INSTANCE
// ==========================
const uploadNewsImage = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: MAX_FILE_SIZE, // 🔥 LIMIT 10MB
  },
});

module.exports = { uploadNewsImage };

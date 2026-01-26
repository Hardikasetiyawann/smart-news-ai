const express = require("express");
const router = express.Router();

const { verifyToken } = require("../../core/middleware/auth.middleware");
const categoryController = require("./category.controller");

// GET all categories
router.get(
  "/",
  verifyToken (["user", "admin"]),
  categoryController.getAllCategories
);

// GET category by ID
router.get(
  "/:id",
  verifyToken (["user", "admin"]),
  categoryController.getCategoryById
);

// CREATE category
router.post(
  "/",
  verifyToken (["admin"]),
  categoryController.createCategory
);

// UPDATE category
router.put(
  "/:id",
  verifyToken (["admin"]),
  categoryController.updateCategory
);

// DELETE category
router.delete(
  "/:id",
  verifyToken (["admin"]),
  categoryController.deleteCategory
);

module.exports = router;

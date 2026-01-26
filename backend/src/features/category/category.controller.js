const Category = require("./category.model");
const AdminLog = require("../admin_logs/admin_log.model");

/* =========================
   HELPER: ADMIN LOG
========================= */
const createAdminLog = async (req, action, details = null) => {
  try {
    if (!req.auth || !req.auth.id) return;

    await AdminLog.create({
      admin_id: req.auth.id,
      action,
      details,
    });
  } catch (err) {
    console.error("AdminLog Error:", err.message);
  }
};

/* =========================
   CREATE CATEGORY (ADMIN)
========================= */
exports.createCategory = async (req, res) => {
  try {
    if (!req.auth || req.auth.role !== "admin") {
      return res.status(403).json({
        success: false,
        message: "Forbidden",
      });
    }

    const { name } = req.body;

    if (!name) {
      return res.status(400).json({
        success: false,
        message: "Category name is required",
      });
    }

    const category = await Category.create({ name });

    await createAdminLog(
      req,
      "Create Category",
      `Category "${name}" berhasil dibuat`
    );

    return res.status(201).json({
      success: true,
      data: category,
    });
  } catch (err) {
    if (err.name === "SequelizeUniqueConstraintError") {
      return res.status(409).json({
        success: false,
        message: "Category name already exists",
      });
    }

    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

/* =========================
   GET ALL CATEGORIES
========================= */
exports.getAllCategories = async (req, res) => {
  try {
    const categories = await Category.findAll({
      order: [["name", "ASC"]],
    });

    return res.json({
      success: true,
      results: categories.length,
      data: categories,
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

/* =========================
   GET CATEGORY BY ID
========================= */
exports.getCategoryById = async (req, res) => {
  try {
    const category = await Category.findByPk(req.params.id);

    if (!category) {
      return res.status(404).json({
        success: false,
        message: "Category not found",
      });
    }

    return res.json({
      success: true,
      data: category,
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

/* =========================
   UPDATE CATEGORY (ADMIN)
========================= */
exports.updateCategory = async (req, res) => {
  try {
    if (!req.auth || req.auth.role !== "admin") {
      return res.status(403).json({
        success: false,
        message: "Forbidden",
      });
    }

    const { name } = req.body;
    const { id } = req.params;

    if (!name) {
      return res.status(400).json({
        success: false,
        message: "Category name is required",
      });
    }

    const category = await Category.findByPk(id);

    if (!category) {
      return res.status(404).json({
        success: false,
        message: "Category not found",
      });
    }

    await category.update({ name });

    await createAdminLog(
      req,
      "Update Category",
      `Category ID ${id} diubah menjadi "${name}"`
    );

    return res.json({
      success: true,
      data: category,
    });
  } catch (err) {
    if (err.name === "SequelizeUniqueConstraintError") {
      return res.status(409).json({
        success: false,
        message: "Category name already exists",
      });
    }

    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

/* =========================
   DELETE CATEGORY (ADMIN)
========================= */
exports.deleteCategory = async (req, res) => {
  try {
    if (!req.auth || req.auth.role !== "admin") {
      return res.status(403).json({
        success: false,
        message: "Forbidden",
      });
    }

    const category = await Category.findByPk(req.params.id);

    if (!category) {
      return res.status(404).json({
        success: false,
        message: "Category not found",
      });
    }

    await category.destroy();

    await createAdminLog(
      req,
      "Delete Category",
      `Category "${category.name}" dihapus`
    );

    return res.json({
      success: true,
      message: "Category deleted",
    });
  } catch (err) {
    if (err.name === "SequelizeForeignKeyConstraintError") {
      return res.status(409).json({
        success: false,
        message:
          "Category tidak bisa dihapus karena masih digunakan oleh news",
      });
    }

    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

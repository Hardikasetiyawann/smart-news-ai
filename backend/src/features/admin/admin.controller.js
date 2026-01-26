const { News, Publisher, User } = require("../../core/config/model");
const Report = require("../report/report.model");
const Admin = require("./admin.models");
const AdminLog = require("../admin_logs/admin_log.model");
const bcrypt = require("bcryptjs");

/* ======================================================
   DASHBOARD STATS
   GET /api/admin/dashboard
====================================================== */
exports.getDashboardStats = async (req, res) => {
  try {
    const [
      totalNews,
      totalUsers,
      totalPublishers,
      pendingReports,
    ] = await Promise.all([
      News.count({ where: { status: "published" } }),
      User.count(),
      Publisher.count(),
      Report.count({ where: { status: "pending" } }),
    ]);

    const recentNews = await News.findAll({
      limit: 5,
      order: [["created_at", "DESC"]],
      attributes: ["id", "title", "status", "created_at", "count_view"],
      include: [
        {
          model: Publisher,
          as: "publisher",
          attributes: ["name"],
        },
      ],
    });

    return res.json({
      success: true,
      data: {
        stats: {
          total_news: totalNews,
          total_users: totalUsers,
          total_publishers: totalPublishers,
          pending_reports: pendingReports,
        },
        recent_news: recentNews,
      },
      
    });
  } catch (error) {
    console.error("Dashboard Error:", error);
    return res.status(500).json({
      success: false,
      message: "Gagal memuat dashboard",
      error: error.message,
    });
  }
};

/* ======================================================
   CREATE ADMIN
   POST /api/admin
   HANYA ADMIN ID = 1
====================================================== */
exports.createAdmin = async (req, res) => {
  try {
    // 🔒 HANYA SUPER ADMIN (ID = 1)
    if (req.auth.id !== 1) {
      return res.status(403).json({
        success: false,
        message: "Akses ditolak. Hanya Super Admin yang dapat membuat admin baru",
      });
    }

    const { username, email, password, full_name } = req.body;

    if (!username || !email || !password || !full_name) {
      return res.status(400).json({
        success: false,
        message: "Semua field wajib diisi",
      });
    }

    // 🔎 Cek duplikasi
    const existingAdmin = await Admin.findOne({
      where: { username },
    });

    if (existingAdmin) {
      return res.status(409).json({
        success: false,
        message: "Username admin sudah digunakan",
      });
    }

    // 🔐 Hash password
    const passwordHash = await bcrypt.hash(password, 10);

    // ➕ Create admin
    const admin = await Admin.create({
      username,
      email,
      password_hash: passwordHash,
      full_name,
    });

    // 🧾 ADMIN LOG
    await AdminLog.create({
      admin_id: req.auth.id,
      action: "Create Admin",
      details: `Admin "${username}" berhasil dibuat`,
    });

    return res.status(201).json({
      success: true,
      message: "Admin berhasil dibuat",
      data: {
        id: admin.id,
        username: admin.username,
        email: admin.email,
        full_name: admin.full_name,
      },
    });
  } catch (error) {
    console.error("Create Admin Error:", error);
    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};


//GET ALL

exports.getAllAdmins = async (req, res) => {
  const admins = await Admin.findAll({
    attributes: ['id', 'username', 'email', 'full_name', 'last_login'],
    order: [['created_at', 'DESC']],
  });

  res.json({ success: true, data: admins });
};

/* ======================================================
   GET ADMIN BY ID
   GET /api/admin/:id
====================================================== */
exports.getAdminById = async (req, res) => {
  try {
    const admin = await Admin.findByPk(req.auth.id, {
      attributes: ['id', 'username', 'email', 'full_name', 'last_login'],
    });

    if (!admin) {
      return res.status(404).json({
        success: false,
        message: "Admin tidak ditemukan",
      });
    }

    res.json({ success: true, data: admin });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};


/* ======================================================
   DELETE ADMIN
   DELETE /api/admin/:id
   HANYA ADMIN ID = 1
====================================================== */
exports.deleteAdmin = async (req, res) => {
  try {
    if (req.auth.id !== 1) {
      return res.status(403).json({
        success: false,
        message: "Akses ditolak. Hanya Super Admin",
      });
    }

    if (Number(req.params.id) === 1) {
      return res.status(400).json({
        success: false,
        message: "Super Admin tidak boleh dihapus",
      });
    }

    const admin = await Admin.findByPk(req.params.id);
    if (!admin) {
      return res.status(404).json({
        success: false,
        message: "Admin tidak ditemukan",
      });
    }

    await admin.destroy();

    // 🧾 ADMIN LOG
    await AdminLog.create({
      admin_id: req.auth.id,
      action: "Delete Admin",
      details: `Admin "${admin.username}" dihapus`,
    });

    res.json({
      success: true,
      message: "Admin berhasil dihapus",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};


/* ======================================================
   UPDATE ADMIN
   PUT /api/admin/:id
   HANYA ADMIN ID = 1
====================================================== */
exports.updateAdmin = async (req, res) => {
  try {
    if (req.auth.id !== 1) {
      return res.status(403).json({
        success: false,
        message: "Akses ditolak. Hanya Super Admin",
      });
    }

    const { username, email, password, full_name } = req.body;
    const admin = await Admin.findByPk(req.params.id);

    if (!admin) {
      return res.status(404).json({
        success: false,
        message: "Admin tidak ditemukan",
      });
    }

    // Update password jika diisi
    let passwordHash = admin.password_hash;
    if (password) {
      passwordHash = await bcrypt.hash(password, 10);
    }

    await admin.update({
      username: username ?? admin.username,
      email: email ?? admin.email,
      full_name: full_name ?? admin.full_name,
      password_hash: passwordHash,
    });

    // 🧾 ADMIN LOG
    await AdminLog.create({
      admin_id: req.auth.id,
      action: "Update Admin",
      details: `Admin "${admin.username}" diperbarui`,
    });

    res.json({
      success: true,
      message: "Admin berhasil diperbarui",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

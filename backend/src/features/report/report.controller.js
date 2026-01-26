const Report = require("./report.model");
const AdminLog = require("../admin_logs/admin_log.model");

/* =========================
   HELPER: ADMIN LOG
========================= */
const createAdminLog = async (req, action, details = null) => {
  try {
    if (!req.auth || req.auth.role !== "admin") return;

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
   GET ALL REPORTS (ADMIN)
========================= */
exports.getAllReports = async (req, res) => {
  try {
    const reports = await Report.findAll({
      order: [["created_at", "DESC"]],
    });

    return res.json({ success: true, data: reports });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
};

/* =========================
   GET REPORT BY ID (ADMIN)
========================= */
exports.getReportById = async (req, res) => {
  try {
    const report = await Report.findByPk(req.params.id);

    if (!report) {
      return res.status(404).json({ message: "Report not found" });
    }

    return res.json({ success: true, data: report });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
};

/* =========================
   CREATE REPORT (USER)
========================= */
exports.createReport = async (req, res) => {
  try {
    const { type, news_id, comment_id, content } = req.body;

    if (!["news", "comment"].includes(type)) {
      return res.status(400).json({ message: "Invalid report type" });
    }

    if (type === "news" && !news_id) {
      return res.status(400).json({ message: "news_id is required" });
    }

    if (type === "comment" && !comment_id) {
      return res.status(400).json({ message: "comment_id is required" });
    }

    const report = await Report.create({
      user_id: req.auth.id,
      type,
      news_id: type === "news" ? news_id : null,
      comment_id: type === "comment" ? comment_id : null,
      content,
      status: "pending",
    });

    return res.status(201).json({ success: true, data: report });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
};

/* =========================
   UPDATE STATUS (ADMIN ONLY)
   🔴 ADMIN LOG DI SINI
========================= */
exports.updateReportStatus = async (req, res) => {
  try {
    const { status } = req.body;

    if (!["pending", "resolved"].includes(status)) {
      return res.status(400).json({ message: "Invalid status value" });
    }

    const report = await Report.findByPk(req.params.id);

    if (!report) {
      return res.status(404).json({ message: "Report not found" });
    }

    const oldStatus = report.status;

    await report.update({ status });

    // 🔴 ADMIN LOG (HANYA UPDATE STATUS)
    await createAdminLog(
      req,
      "Update Report Status",
      `Report ID ${report.id} diubah dari "${oldStatus}" ke "${status}"`
    );

    return res.json({
      success: true,
      message: "Report status updated",
    });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
};

/* =========================
   DELETE REPORT (ADMIN)
   🔴 ADMIN LOG DI SINI
========================= */
exports.deleteReport = async (req, res) => {
  try {
    const report = await Report.findByPk(req.params.id);

    if (!report) {
      return res.status(404).json({ message: "Report not found" });
    }

    await report.destroy();

    // 🔴 ADMIN LOG (HANYA DELETE)
    await createAdminLog(
      req,
      "Delete Report",
      `Report ID ${report.id} berhasil dihapus`
    );

    return res.json({
      success: true,
      message: "Report deleted",
    });
  } catch (err) {
    return res.status(500).json({ success: false, message: err.message });
  }
};

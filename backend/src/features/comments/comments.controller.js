const Comment = require("./comments.model");
const AdminLog = require("../admin_logs/admin_log.model");
const User = require("../auth_user/user.model");

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
   GET ALL COMMENTS (PUBLIC)
========================= */
exports.getAllComments = async (req, res) => {
  try {
    const data = await Comment.findAll({
      order: [["created_at", "DESC"]],
    });

    return res.json(data);
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};

/* =========================
   GET COMMENT BY ID (PUBLIC)
========================= */
exports.getCommentById = async (req, res) => {
  try {
    const data = await Comment.findByPk(req.params.id);

    if (!data) {
      return res.status(404).json({ message: "Comment not found" });
    }

    return res.json({ success: true, data });
  } catch (err) {
    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};
/* =========================
   GET COMMENTS BY NEWS ID
//========================= */
exports.getCommentsByNewsId = async (req, res) => {
  try {
    const newsId = req.params.news_id;
    const currentUserId = req.auth?.id ?? null;

    const comments = await Comment.findAll({
      where: { news_id: newsId },
      order: [["created_at", "ASC"]],
      include: [
        {
          model: User,
          as: "user",
          attributes: ["id", "full_name", "image_url"],
        },
      ],
    });

    const result = comments.map((c) => ({
      id: c.id,
      content: c.content,
      created_at: c.created_at,
      is_mine: currentUserId
        ? String(c.user_id) === String(currentUserId)
        : false,
      user: {
        id: c.user.id,
        full_name: c.user.full_name,
        image_url: c.user.image_url,
      },
    }));

    return res.json(result);
  } catch (err) {
    console.error("GET COMMENTS ERROR:", err);
    return res.status(500).json({ error: err.message });
  }
};
/* =========================
   GET COMMENTS BY USER ID
   (USER: milik sendiri)
   (ADMIN: semua)
========================= */
exports.getCommentsByUserId = async (req, res) => {
  try {
    const userId = parseInt(req.params.user_id, 10);

    if (req.auth.role !== "admin" && req.auth.id !== userId) {
      return res.status(403).json({ message: "Forbidden" });
    }

    const comments = await Comment.findAll({
      where: { user_id: userId },
      order: [["created_at", "ASC"]],
    });

    return res.json(comments);
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};

/* =========================
   CREATE COMMENT
========================= */
exports.createComment = async (req, res) => {
  try {
    const { news_id, content } = req.body;

    if (!news_id || !content) {
      return res.status(400).json({
        message: "news_id and content are required",
      });
    }

    const newData = await Comment.create({
      news_id,
      content,
      user_id: req.auth.id,
    });

    return res.status(201).json({
      success: true,
      data: newData,
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

/* =========================
   UPDATE COMMENT
========================= */
exports.updateComment = async (req, res) => {
  try {
    const { id } = req.params;
    const { content } = req.body;

    const comment = await Comment.findByPk(id);

    if (!comment) {
      return res.status(404).json({ message: "Comment not found" });
    }

    if (req.auth.role !== "admin" && comment.user_id !== req.auth.id) {
      return res.status(403).json({ message: "Forbidden" });
    }

    await comment.update({ content });

    return res.json({
      success: true,
      message: "Comment updated",
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

/* =========================
   DELETE COMMENT
========================= */
exports.deleteComment = async (req, res) => {
  try {
    const { id } = req.params;

    const comment = await Comment.findByPk(id);

    if (!comment) {
      return res.status(404).json({ message: "Comment not found" });
    }

    if (req.auth.role !== "admin" && comment.user_id !== req.auth.id) {
      return res.status(403).json({ message: "Forbidden" });
    }

    await comment.destroy();

    await createAdminLog(
      req,
      "Delete Comment",
      `Komentar ID ${id} berhasil dihapus`
    );

    return res.json({
      success: true,
      message: "Comment deleted",
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};


/* =========================
   GET COMMENT DETAIL (WITH USER)
========================= */
exports.getCommentDetail = async (req, res) => {
  try {
    const { id } = req.params;
    const currentUserId = req.auth?.id ?? null;

    const comment = await Comment.findOne({
      where: { id },
      attributes: ["id", "content", "created_at", "user_id"],
      include: [
        {
          model: User,
          as: "user",
          attributes: ["id", "full_name", "image_url"],
        },
      ],
    });

    if (!comment) {
      return res.status(404).json({
        success: false,
        message: "Comment not found",
      });
    }

    return res.json({
      success: true,
      data: {
        id: comment.id,
        content: comment.content,
        created_at: comment.created_at,
        is_mine: currentUserId
          ? String(comment.user_id) === String(currentUserId)
          : false,
        user: {
          id: comment.user.id,
          full_name: comment.user.full_name,
          image_url: comment.user.image_url,
        },
      },
    });
  } catch (err) {
    console.error("GET COMMENT DETAIL ERROR:", err);
    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

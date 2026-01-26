
const AiSummary = require("../ai_summary/ai_summary.model");
const AdminLog = require("../admin_logs/admin_log.model");
const { Op } = require("sequelize");
const NewsView = require("./news_view.model");
const { sendBroadcastNotification } =
  require('../../core/utils/notification.service');

const {
  News,
  Publisher,
  Category,
  Like,
  Comment,
} = require("../../core/config/model");

const startOfToday = () => {
  const d = new Date();
  d.setHours(0, 0, 0, 0);
  return d;
};

/* =========================
   HELPER: FILTER ROLE
========================= */
const getRoleFilter = (req) => {
  if (req.auth?.role === "admin") return {};
  return { status: "published" };
};

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
   GET ALL NEWS (ADMIN)
========================= */
exports.getAllNews = async (req, res) => {
  try {
    const data = await News.findAll({
      order: [["created_at", "DESC"]],
    });

    return res.json(data);
  } catch (err) {
    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

/* =========================
   GET NEWS BY ID
========================= */
exports.getNewsById = async (req, res) => {
  try {
    const where = {
      id: req.params.id,
      ...getRoleFilter(req),
    };

    const data = await News.findOne({ where });

    if (!data) {
      return res.status(404).json({
        success: false,
        message: "News not found",
      });
    }

    return res.json({
      success: true,
      data,
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

/* =========================
   CREATE NEWS (ADMIN)
========================= */
exports.createNews = async (req, res) => {
  try {
    if (!req.auth || !req.auth.id) {
      return res.status(401).json({
        success: false,
        message: "Unauthorized",
      });
    }

    const {
      category_id,
      publisher_id,
      title,
      content,
      link_news,
      status,
      count_view,
      published_at,
    } = req.body;

    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: "Image is required",
      });
    }

    const imageUrl = `/uploads/news/${req.file.filename}`;


    const newData = await News.create({
      admin_id: req.auth.id,
      category_id,
      publisher_id,
      title,
      content,
      image_url: imageUrl,
      link_news,
      status,
      count_view: count_view ?? 0,
      published_at: status === "published"
        ? published_at ?? new Date()
        : null,
    });

    // 🔴 ADMIN LOG
    await createAdminLog(
      req,
      "Create News",
      `News "${title}" berhasil dibuat`
    );
    if (status === 'published') {
      await sendBroadcastNotification({
        title: 'Berita Baru',
        body: title,
        data: {
          type: 'news',
          news_id: newData.id,
        },
      });
    }
    return res.status(201).json({
      success: true,
      data: newData,
    });
  } catch (err) {
    console.error("Create news error:", err);
    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

/* =========================
   UPDATE NEWS (ADMIN)
========================= */
exports.updateNews = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, content, ...otherFields } = req.body;

    const news = await News.findByPk(id);
    if (!news) {
      return res.status(404).json({
        success: false,
        message: "News not found",
      });
    }

    let imageUrl = news.image_url;
    if (req.file) {
      imageUrl = `/uploads/news/${req.file.filename}`;

    }

    const isContentChanged =
      typeof content === "string" && content !== news.content;

    await news.update({
      ...(title !== undefined && { title }),
      ...(content !== undefined && { content }),
      image_url: imageUrl,
      ...otherFields,
    });

    if (isContentChanged) {
      await AiSummary.destroy({
        where: { news_id: id },
      });
    }

    // 🔴 ADMIN LOG
    await createAdminLog(
      req,
      "Update News",
      `News ID ${id} berhasil diupdate`
    );

    return res.json({
      success: true,
      message: "News updated",
      content_changed: isContentChanged,
    });
  } catch (err) {
    console.error("Update news error:", err);
    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

/* =========================
   DELETE NEWS (ADMIN)
========================= */
exports.deleteNews = async (req, res) => {
  try {
    const news = await News.findByPk(req.params.id);

    if (!news) {
      return res.status(404).json({
        success: false,
        message: "News not found",
      });
    }

    await news.destroy();

    // 🔴 ADMIN LOG
    await createAdminLog(
      req,
      "Delete News",
      `News "${news.title}" berhasil dihapus`
    );

    return res.json({
      success: true,
      message: "News deleted",
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

/* =========================
   GET LATEST NEWS
========================= */
exports.getLatestNews = async (req, res) => {
  try {
    const news = await News.findAll({
      where: getRoleFilter(req),
      order: [["created_at", "DESC"]],
      limit: 10,
    });

    return res.json(news);
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};

/* =========================
   GET TRENDING NEWS
========================= */
exports.getTrendingNews = async (req, res) => {
  try {
    const news = await News.findAll({
      where: getRoleFilter(req),
      order: [["count_view", "DESC"]],
      limit: 10,
    });

    return res.json(news);
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};

/* =========================
   GET NEWS BY CATEGORY
========================= */
exports.getNewsByCategoryId = async (req, res) => {
  try {
    const newsList = await News.findAll({
      where: {
        category_id: req.params.id,
        ...getRoleFilter(req),
      },
      order: [["created_at", "DESC"]],
    });

    return res.json(newsList);
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};

/* =========================
   GET NEWS BY PUBLISHER
========================= */
exports.getNewsByPublisherId = async (req, res) => {
  try {
    const newsList = await News.findAll({
      where: {
        publisher_id: req.params.id,
        ...getRoleFilter(req),
      },
      order: [["created_at", "DESC"]],
    });

    return res.json(newsList);
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};

/* =========================
   GET NEWS INTERACTIONS
========================= */
exports.getNewsInteractions = async (req, res) => {
  try {
    const newsId = req.params.id;
    const userId = req.auth?.role === "user" ? req.auth.id : null;

    const total_like = await Like.count({
      where: { news_id: newsId },
    });

    const total_comment = await Comment.count({
      where: { news_id: newsId },
    });

    let is_liked = false;

    if (userId) {
      const liked = await Like.findOne({
        where: {
          news_id: newsId,
          user_id: userId,
        },
      });
      is_liked = !!liked;
    }

    return res.json({
      success: true,
      data: {
        total_like,
        total_comment,
        is_liked,
      },
    });
  } catch (e) {
    console.error("GET NEWS INTERACTIONS ERROR:", e);
    res.status(500).json({
      success: false,
      message: e.message,
    });
  }
};

/* =========================
   SEARCH NEWS
========================= */
exports.searchNews = async (req, res) => {
  try {
    const q = req.query.q;

    if (!q || q.trim() === "") {
      return res.json([]);
    }

    const newsList = await News.findAll({
      where: {
        ...getRoleFilter(req),
        [Op.or]: [
          { title: { [Op.like]: `%${q}%` } },
          { content: { [Op.like]: `%${q}%` } },
        ],
      },
      include: [
        {
          model: Publisher,
          as: "publisher",
          attributes: ["id", "name"],
        },
        {
          model: Category,
          as: "category",
          attributes: ["id", "name"],
        },
      ],
      order: [["published_at", "DESC"]],
      limit: 50,
    });

    return res.json(newsList);
  } catch (err) {
    console.error("SEARCH NEWS ERROR:", err);
    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};

exports.recordNewsView = async (req, res) => {
  try {
    const newsId = req.params.id;
    const userId = req.auth?.id;

    if (!userId) {
      return res.status(401).json({
        success: false,
        message: 'Unauthorized',
      });
    }


    //  LOGIC ANTI SPAM
    //  news_views punya UNIQUE
    //  (news_id, user_id, view_day)
    //  view_day di-generate dari created_at
    //  cukup TRY INSERT
    //  jika duplicate → skip


    try {
      await NewsView.create({
        news_id: newsId,
        user_id: userId,
      });

      // hanya increment kalau INSERT berhasil
      await News.increment(
        { count_view: 1 },
        { where: { id: newsId } }
      );

      return res.json({
        success: true,
        message: 'View recorded',
      });
    } catch (e) {
      // Duplicate view (user sudah lihat hari ini)
      if (e.name === 'SequelizeUniqueConstraintError') {
        return res.json({
          success: true,
          skipped: true,
          message: 'Already viewed today',
        });
      }

      throw e;
    }
  } catch (err) {
    console.error('RECORD VIEW ERROR:', err);
    return res.status(500).json({
      success: false,
      message: err.message,
    });
  }
};
const AiSummary = require("./ai_summary.model");
const News = require("../news/news.model");
const { requestAISummary } = require("./ai_summary.service");

exports.getOrCreateSummary = async (req, res) => {
  try {
    const { news_id } = req.params;

    // 1️⃣ cek database dulu
    const existing = await AiSummary.findOne({
      where: { news_id },
    });

    if (existing) {
      return res.json({
        source: "database",
        summary_text: existing.summary_text,
        model_name: existing.model_name,
      });
    }

    // 2️⃣ ambil berita
    const news = await News.findByPk(news_id);
    if (!news) {
      return res.status(404).json({ message: "News not found" });
    }

    // 3️⃣ panggil AI
    const aiResult = await requestAISummary(news.content);

    // 4️⃣ simpan ke DB
    const saved = await AiSummary.create({
      news_id,
      summary_text: aiResult.summary_text,
      model_name: aiResult.model_name,
    });

    return res.json({
      source: "ai",
      summary_text: saved.summary_text,
      model_name: saved.model_name,
    });

  } catch (error) {
    console.error("AI SUMMARY ERROR:", error);
    res.status(500).json({
      message: "Failed to generate AI summary",
    });
  }
};


exports.getAllAiSummariesAdmin = async (req, res) => {
  try {
    const summaries = await AiSummary.findAll({
      include: {
        model: News,
        as: "news",
        attributes: ["id", "title"],
      },
      order: [["created_at", "DESC"]],
    });

    res.json({
      success: true,
      total: summaries.length,
      data: summaries,
    });
  } catch (e) {
    res.status(500).json({ success: false });
  }
};

exports.getSummaryStatusAdmin = async (req, res) => {
  const news = await News.findAll({
    attributes: ["id", "title"],
    include: {
      model: AiSummary,
      as: "ai_summary",
      required: false,
    },
  });

  res.json({
    success: true,
    data: news.map(n => ({
      id: n.id,
      title: n.title,
      summarized: !!n.ai_summary,
      model: n.ai_summary?.model_name ?? null,
    })),
  });
};

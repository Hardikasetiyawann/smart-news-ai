const ReadingHistory = require("./history.model");
const News = require("../news/news.model");

// GET USER HISTORY
exports.getUserHistory = async (req, res) => {
  try {
    const userId = req.auth.id;

    const history = await ReadingHistory.findAll({
      where: { user_id: userId },
      include: [{
        model: News,
        as: "news",
        attributes: ["id", "title", "image_url", "published_at"],
      }],
      order: [["read_at", "DESC"]],
    });

    res.json({ status: "success", data: history });
  } catch (err) {
    res.status(500).json({ message: "Gagal ambil history" });
  }
};

// RECORD READ (AUTO UPDATE read_at)
exports.recordRead = async (req, res) => {
  console.log('POST /api/history', {
    userId: req.auth.id,
    body: req.body,
  });
  try {
    const userId = req.auth.id;
    const { news_id } = req.body;

    const [history, created] = await ReadingHistory.findOrCreate({
      where: { user_id: userId, news_id },
      defaults: { read_at: new Date() },
    });

    if (!created) {
      await history.update({ read_at: new Date() });
    }

    res.json({ status: 'success' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Gagal mencatat history' });
  }
};



// DELETE ONE
exports.deleteOneHistory = async (req, res) => {
  await ReadingHistory.destroy({
    where: { user_id: req.auth.id, news_id: req.params.news_id },
  });
  res.json({ status: "success" });
};

// CLEAR ALL
exports.clearHistory = async (req, res) => {
  await ReadingHistory.destroy({ where: { user_id: req.auth.id } });
  res.json({ status: "success" });
};
const service = require("./likes.service");

exports.getLikedNews = async (req, res) => {
  try {
    console.log('AUTH USER:', req.auth);

    const data = await service.getLikedNewsByUser(req.auth.id);
    console.log('LIKED NEWS RESULT:', data);

    res.json({ success: true, data });
  } catch (e) {
    console.error("GET LIKED ERROR:", e);
    res.status(500).json({
      success: false,
      message: "Failed to load liked news",
    });
  }
};


exports.likeNews = async (req, res) => {
  try {
    if (req.auth.role !== "user") {
      return res.status(403).json({
        success: false,
        message: "Only user can like news",
      });
    }

    await service.likeNews(req.auth.id, req.params.newsId);

    return res.json({
      success: true,
      message: "Liked",
    });
  } catch (e) {
    console.error("LIKE ERROR:", e);
    res.status(500).json({
      success: false,
      message: "Failed to like news",
    });
  }
};

exports.unlikeNews = async (req, res) => {
  try {
    if (req.auth.role !== "user") {
      return res.status(403).json({
        success: false,
        message: "Only user can unlike news",
      });
    }

    await service.unlikeNews(req.auth.id, req.params.newsId);

    return res.json({
      success: true,
      message: "Unliked",
    });
  } catch (e) {
    console.error("UNLIKE ERROR:", e);
    res.status(500).json({
      success: false,
      message: "Failed to unlike news",
    });
  }
};
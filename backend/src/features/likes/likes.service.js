const { User, News, Publisher, Like } = require("../../core/config/model");

exports.getLikedNewsByUser = async (userId) => {
  const user = await User.findByPk(userId, {
    attributes: ["id"],
    include: [
      {
        model: News,
        as: "likedNews",
        attributes: ["id", "title", "image_url", "published_at"],
        through: { attributes: [] },
        include: [
          {
            model: Publisher,
            as: "publisher",
            attributes: ["name"],
          },
        ],
      },
    ],
  });

  if (!user) return [];

  return user.likedNews.map((news) => ({
    id: news.id,
    title: news.title,
    imageUrl: news.image_url,
    publisher: news.publisher?.name ?? "-",
    publishedAt: news.published_at,
  }));
};

exports.likeNews = async (userId, newsId) => {
  console.log('LIKE PARAM:', {
    userId,
    newsId,
    userIdType: typeof userId,
  });

  if (!userId) {
    throw new Error('USER ID UNDEFINED');
  }

  return Like.findOrCreate({
    where: {
      user_id: userId,
      news_id: newsId,
    },
  });
};


exports.unlikeNews = async (userId, newsId) => {
  return await Like.destroy({
    where: {
      user_id: userId,
      news_id: newsId,
    },
  });
};
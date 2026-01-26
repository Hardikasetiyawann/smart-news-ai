const { DataTypes } = require("sequelize");
const sequelize = require("../../core/config/db");
const News = require("../news/news.model");
const User = require("../auth_user/user.model");

const ReadingHistory = sequelize.define(
  "ReadingHistory",
  {
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    news_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    read_at: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW,
    },
  },
  {
    tableName: "ReadingHistories",
    timestamps: false,
    underscored: true,
  }
);

// RELASI
ReadingHistory.belongsTo(News, {
  foreignKey: "news_id",
  as: "news",
});

ReadingHistory.belongsTo(User, {
  foreignKey: "user_id",
  as: "user",
});

module.exports = ReadingHistory;
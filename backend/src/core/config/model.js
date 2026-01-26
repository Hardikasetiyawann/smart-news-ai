const sequelize = require("./db");
const { DataTypes } = require("sequelize");

// MODELS
const News = require("../../features/news/news.model");
const Publisher = require("../../features/publisher/publisher.model");
const UserFactory = require("../../../database/models/user");
const LikeFactory = require("../../features/likes/likes.model");
const Comment = require("../../features/comments/comments.model");
const AiSummary = require("../../features/ai_summary/ai_summary.model");
const NewsView = require("../../features/news/news_view.model");
const Category = require("../../features/category/category.model");
const NotificationFactory = require("../../../database/models/notification");
const UserDeviceFactory = require("../../../database/models/user_device");
const NotificationSettingsFactory = require("../../../database/models/notification_settings");

// INIT
const User = UserFactory(sequelize, DataTypes);
const Like = LikeFactory(sequelize, DataTypes);
const Notification = NotificationFactory(sequelize, DataTypes);
const UserDevice = UserDeviceFactory(sequelize, DataTypes);
const NotificationSettings = NotificationSettingsFactory(sequelize, DataTypes);

// RELATION (WAJIB)
User.belongsToMany(News, {
  through: Like,
  foreignKey: "user_id",
  otherKey: "news_id",
  as: "likedNews",
});

News.belongsToMany(User, {
  through: Like,
  foreignKey: "news_id",
  otherKey: "user_id",
  as: "likedUsers",
});

// ======================
// USER ↔ NOTIFICATION
// ======================
User.hasMany(Notification, {
  foreignKey: "user_id",
  as: "notifications",
});

Notification.belongsTo(User, {
  foreignKey: "user_id",
  as: "user",
});

// ======================
// USER ↔ DEVICE
// ======================
User.hasMany(UserDevice, {
  foreignKey: "user_id",
  as: "devices",
});

UserDevice.belongsTo(User, {
  foreignKey: "user_id",
  as: "user",
});

User.hasOne(NotificationSettings, {
  foreignKey: 'user_id',
  as: 'notificationSettings',
});

NotificationSettings.belongsTo(User, {
  foreignKey: 'user_id',
  as: 'user',
});

// ======================
// NEWS ↔ PUBLISHER
// ======================

Publisher.hasMany(News, {
  foreignKey: "publisher_id",
  as: "news",
});

News.belongsTo(Publisher, {
  foreignKey: "publisher_id",
  as: "publisher",
});


// ======================
// NEWS ↔ AI SUMMARY
// ======================

AiSummary.belongsTo(News, {
  foreignKey: "news_id",
  as: "news",
});

News.hasOne(AiSummary, {
  foreignKey: "news_id",
  as: "ai_summary",
});

// kategori
Category.hasMany(News, {
  foreignKey: "category_id",
  as: "news",
});

News.belongsTo(Category, {
  foreignKey: "category_id",
  as: "category",
});

module.exports = {
  sequelize,
  User,
  News,
  Publisher,
  Like,
  Comment,
  NewsView,
  Category,
  Notification,
  UserDevice,
  NotificationSettings,
};

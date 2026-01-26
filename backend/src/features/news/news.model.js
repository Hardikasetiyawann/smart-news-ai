const { DataTypes } = require("sequelize");
const sequelize = require("../../core/config/db");

const News = sequelize.define('News', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  admin_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  category_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  publisher_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  title: {
    type: DataTypes.STRING(255),
    allowNull: false
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  image_url: {
    type: DataTypes.STRING(255),
    allowNull: false
  },
  link_news: {
    type: DataTypes.STRING(255),
    allowNull: false
  },
  status: {
    type: DataTypes.ENUM("draft", "published"),
    allowNull: false
  },
  count_view: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  published_at: {
    type: DataTypes.DATE,
    allowNull: true
  }
}, {
  timestamps: true,          // aktifkan auto created_at & updated_at
  createdAt: "created_at",   // pakai nama kolom kamu
  updatedAt: "updated_at"
});

module.exports = News;

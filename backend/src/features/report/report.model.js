const { DataTypes } = require("sequelize");
const sequelize = require("../../core/config/db");

const Report = sequelize.define("Report", {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  type: {
    type: DataTypes.ENUM("comment", "news"),
    allowNull: false
  },
  news_id: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  comment_id: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  status: {
    type: DataTypes.ENUM("pending", "resolved"),
    allowNull: false,
    defaultValue: "pending"
  }
}, {
  tableName: "reports",
  timestamps: true,
  createdAt: "created_at",
  updatedAt: "updated_at"
});

module.exports = Report;

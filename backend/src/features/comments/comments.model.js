const { DataTypes } = require("sequelize");
const sequelize = require("../../core/config/db");
const User = require("../auth_user/user.model");

const Comment = sequelize.define(
  "Comment",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    news_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    user_id: {
      type: DataTypes.INTEGER, // ⬅️ PENTING: samakan dengan User.id
      allowNull: false,
    },
    content: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
  },
  {
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
    tableName: "comments",
  }
);

/* =========================
   RELATION
========================= */
Comment.belongsTo(User, {
  foreignKey: "user_id",
  as: "user",
});

module.exports = Comment;

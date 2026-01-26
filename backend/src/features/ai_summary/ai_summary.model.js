// src/features/ai_summary/ai_summary.model.js
const { DataTypes } = require("sequelize");
const sequelize = require("../../core/config/db");

const AiSummary = sequelize.define(
  "AiSummary",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    news_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      unique: true,
    },
    summary_text: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    model_name: {
      type: DataTypes.STRING,
      defaultValue: "cahya/t5-base-indonesian-summarization-cased",
    },
  },
  {
    tableName: "ai_summaries",
    underscored: true,
    timestamps: true,
  }
);

module.exports = AiSummary;

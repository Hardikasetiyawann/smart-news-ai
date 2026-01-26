const { DataTypes } = require('sequelize');
const sequelize = require('../../core/config/db');

const NewsView = sequelize.define(
  'NewsView',
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
      type: DataTypes.INTEGER,
      allowNull: false,
    },
  },
  {
    tableName: 'news_views',

    // created_at dipakai untuk:
    // timestamp view
    // sumber generated column view_day

    timestamps: true,
    createdAt: 'created_at',
    updatedAt: false,
  }
);

module.exports = NewsView;

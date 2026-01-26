'use strict';

const { DataTypes } = require('sequelize');
const sequelize = require('../../core/config/db');

const User = sequelize.define(
  'User',
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },

    email: {
      type: DataTypes.STRING(100),
      allowNull: false,
      unique: true,
    },

    password_hash: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },

    full_name: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },

    image_url: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },

    auth_provider: {
      type: DataTypes.STRING(50),
      allowNull: false,
      defaultValue: 'local',
    },

    firebase_uid: {
      type: DataTypes.STRING(128),
      allowNull: true,
      unique: true,
    },

    is_active: {
      type: DataTypes.BOOLEAN,
      defaultValue: true,
    },

  },
  {
    tableName: 'users',
    underscored: true,
    timestamps: true,
  }
);

module.exports = User;

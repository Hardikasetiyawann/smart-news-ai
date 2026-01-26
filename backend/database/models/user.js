'use strict';
const { Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class User extends Model {}

  User.init(
    {
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
      sequelize,
      tableName: 'users',
      underscored: true,
      timestamps: true,
    }
  );

  return User;
};

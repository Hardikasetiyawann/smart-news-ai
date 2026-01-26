const { DataTypes } = require('sequelize');
const sequelize = require('../../core/config/db'); 

const Admin = sequelize.define('admin', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  username: {
    type: DataTypes.STRING(50),
    allowNull: false,
    unique: true
  },
  email: {
    type: DataTypes.STRING(100),
    allowNull: false,
    unique: true
  },
  password_hash: {
    type: DataTypes.STRING(255),
    allowNull: false
  },
  full_name: {
    type: DataTypes.STRING(100),
    allowNull: false
  },
  last_login: {
    type: DataTypes.DATE,
    allowNull: true
  }
}, {
  underscored: true, // Agar otomatis baca created_at (bukan createdAt)
  tableName: 'admins' // Pastikan nama tabelnya jamak sesuai database
});

module.exports = Admin;
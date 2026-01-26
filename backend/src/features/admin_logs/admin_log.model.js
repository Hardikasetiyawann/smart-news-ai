const { DataTypes } = require('sequelize');
const sequelize = require('../../core/config/db');
const Admin = require('../admin/admin.models');

const AdminLog = sequelize.define('admin_log', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  admin_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  action: {
    type: DataTypes.STRING,
    allowNull: false
  },
  details: {
    type: DataTypes.TEXT,
    allowNull: true
  }
}, {
  underscored: true,
  tableName: 'admin_logs',
  timestamps: true,
  updatedAt: false 
});

AdminLog.belongsTo(Admin, { foreignKey: 'admin_id' });

module.exports = AdminLog;
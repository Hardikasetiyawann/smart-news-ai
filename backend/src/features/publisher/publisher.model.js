const { DataTypes } = require('sequelize');
const sequelize = require('../../core/config/db'); // Path relative tetap sama

const Publisher = sequelize.define('publisher', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  },
  logo_url: {
    type: DataTypes.STRING,
    allowNull: true
  },
  website: {
    type: DataTypes.STRING,
    allowNull: true
  }
}, {
  underscored: true,
  tableName: 'publishers'
});

module.exports = Publisher;
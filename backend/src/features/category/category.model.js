const { DataTypes } = require('sequelize');
const sequelize = require('../../core/config/db'); 

// Definisikan Model Category
const Category = sequelize.define('Category', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    name: {
        type: DataTypes.STRING(100),
        allowNull: false,
        unique: true,
    },
}, {
    tableName: 'Categories', 
    timestamps: true,
    underscored: true, 
});


module.exports = Category;
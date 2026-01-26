'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('reports', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Users', // Nama tabel induk (harus sama persis dengan di database)
          key: 'id'
        },
        onUpdate: 'CASCADE', // Jika ID admin berubah, di sini ikut berubah
        onDelete: 'CASCADE'  // Jika Admin dihapus, log-nya ikut terhapus (Opsional, bisa juga RESTRICT)
      },
      type: {
        allowNull: false,
        type: Sequelize.ENUM('comment', 'news'),
      },
      news_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'news', // Nama tabel induk (harus sama persis dengan di database)
          key: 'id'
        },
        onUpdate: 'CASCADE', // Jika ID admin berubah, di sini ikut berubah
        onDelete: 'CASCADE'  // Jika Admin dihapus, log-nya ikut terhapus (Opsional, bisa juga RESTRICT)
      },
      comment_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'comments', // Nama tabel induk (harus sama persis dengan di database)
          key: 'id'
        },
        onUpdate: 'CASCADE', // Jika ID admin berubah, di sini ikut berubah
        onDelete: 'CASCADE'  // Jika Admin dihapus, log-nya ikut terhapus (Opsional, bisa juga RESTRICT)
      },
        content: {
        allowNull: false,
        type: Sequelize.TEXT,
      },
        status:{ 
        allowNull: false,
        type: Sequelize.ENUM('pending', 'resolved'),
      },
      created_at: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
      updated_at: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('reports');
  }
};
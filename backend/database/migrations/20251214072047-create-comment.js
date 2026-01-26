'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('comments', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      news_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'news', // Nama tabel induk (harus sama persis dengan di database)
          key: 'id'
        },
        onUpdate: 'CASCADE', // Jika ID news berubah, di sini ikut berubah
        onDelete: 'CASCADE'  // Jika news dihapus, log-nya ikut terhapus (Opsional, bisa juga RESTRICT)
      },
      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Users', // Nama tabel induk (harus sama persis dengan di database)
          key: 'id'
        },
        onUpdate: 'CASCADE', // Jika ID user berubah, di sini ikut berubah
        onDelete: 'CASCADE'  // Jika user dihapus, log-nya ikut terhapus (Opsional, bisa juga RESTRICT)
      },
      content: {
        allowNull: false,
        type: Sequelize.TEXT,
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
    await queryInterface.dropTable('comments');
  }
};
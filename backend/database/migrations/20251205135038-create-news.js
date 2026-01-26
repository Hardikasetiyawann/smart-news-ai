'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('news', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      admin_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Admins', // Nama tabel induk (harus sama persis dengan di database)
          key: 'id'
        },
        onUpdate: 'CASCADE', // Jika ID admin berubah, di sini ikut berubah
        onDelete: 'CASCADE'  // Jika Admin dihapus, log-nya ikut terhapus (Opsional, bisa juga RESTRICT)
      },
      category_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Categories', // Nama tabel induk (harus sama persis dengan di database)
          key: 'id'
        },
        onUpdate: 'CASCADE', // Jika ID admin berubah, di sini ikut berubah
        onDelete: 'CASCADE'  // Jika Admin dihapus, log-nya ikut terhapus (Opsional, bisa juga RESTRICT)
      },
      publisher_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Publishers', // Nama tabel induk (harus sama persis dengan di database)
          key: 'id'
        },
        onUpdate: 'CASCADE', // Jika ID admin berubah, di sini ikut berubah
        onDelete: 'CASCADE'  // Jika Admin dihapus, log-nya ikut terhapus (Opsional, bisa juga RESTRICT)
      },
      title: {
        allowNull: false,
        type: Sequelize.STRING(255),
      },
      content: {
        allowNull: false,
        type: Sequelize.TEXT,
      },
      image_url: {
        allowNull: false,
        type: Sequelize.STRING(255),
      },
      link_news: {
        allowNull: false,
        type: Sequelize.STRING(255),
      },
      status: {
        allowNull: false,
        type: Sequelize.ENUM('draft', 'published'),
      },
      count_view: {
        allowNull: false,
        type: Sequelize.INTEGER,
      },
      published_at: {
        allowNull: true,
        type: Sequelize.DATE,
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
    await queryInterface.dropTable('news');
  }
};
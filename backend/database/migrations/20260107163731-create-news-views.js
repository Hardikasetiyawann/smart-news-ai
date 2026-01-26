'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('news_views', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },

      // ======================
      // RELATIONS
      // ======================
      news_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'news', // nama tabel HARUS sesuai
          key: 'id',
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE',
      },

      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'users', // sesuaikan dengan tabel user kamu
          key: 'id',
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE',
      },

      // ======================
      // TIMESTAMP
      // ======================
      created_at: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
      },

      /**
       * 🔥 GENERATED COLUMN
       * Digunakan untuk unique per hari
       */
      view_day: {
        type: Sequelize.DATEONLY,
        allowNull: false,
        defaultValue: Sequelize.literal('(DATE(created_at))'),
      },
    });

    // ======================
    // 🔐 UNIQUE CONSTRAINT
    // ======================
    await queryInterface.addConstraint('news_views', {
      fields: ['news_id', 'user_id', 'view_day'],
      type: 'unique',
      name: 'unique_news_user_per_day',
    });
  },

  async down(queryInterface) {
    await queryInterface.dropTable('news_views');
  },
};

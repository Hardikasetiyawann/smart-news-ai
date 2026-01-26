'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('users', {
      id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        primaryKey: true,
        allowNull: false,
      },

      email: {
        type: Sequelize.STRING(100),
        allowNull: false,
        unique: true,
      },

      password_hash: {
        type: Sequelize.STRING(255),
        allowNull: true, // Firebase user tidak punya password
      },

      full_name: {
        type: Sequelize.STRING(100),
        allowNull: false,
      },

      image_url: {
        type: Sequelize.STRING(255),
        allowNull: true,
      },

      auth_provider: {
        type: Sequelize.STRING(50),
        allowNull: false,
        comment: 'google | email | otp',
      },

      firebase_uid: {
        type: Sequelize.STRING(128),
        allowNull: true,
        unique: true,
      },

      created_at: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
      },

      updated_at: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.literal(
          'CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'
        ),
      },
    });
  },

  async down(queryInterface) {
    await queryInterface.dropTable('users');
  },
};

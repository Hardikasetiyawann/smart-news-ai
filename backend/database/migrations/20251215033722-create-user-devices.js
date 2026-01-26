'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('user_devices', {
      id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        primaryKey: true
      },

      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'users',
          key: 'id'
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },

      fcm_token: {
        type: Sequelize.STRING(255),
        allowNull: false
      },

      platform: {
        type: Sequelize.ENUM('android', 'ios', 'web'),
        allowNull: false
      },

      is_active: {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: true
      },

      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },

      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP')
      },

      deleted_at: {
        type: Sequelize.DATE,
        allowNull: true
      }
    });

    // 🔒 token tidak boleh dobel untuk user yg sama
    await queryInterface.addConstraint('user_devices', {
      fields: ['user_id', 'fcm_token'],
      type: 'unique',
      name: 'unique_user_device'
    });

    // ⚡ index performa
    await queryInterface.addIndex('user_devices', ['user_id']);
    await queryInterface.addIndex('user_devices', ['fcm_token']);
    await queryInterface.addIndex('user_devices', ['is_active']);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeConstraint(
      'user_devices',
      'unique_user_device'
    );
    await queryInterface.dropTable('user_devices');
    await queryInterface.sequelize.query(
      'DROP TYPE IF EXISTS "enum_user_devices_platform";'
    );
  }
};

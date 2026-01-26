'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('users', 'is_active', {
      type: Sequelize.BOOLEAN,
      allowNull: false,
      defaultValue: true,
      comment: 'Status user: true = aktif, false = diblokir',
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('users', 'is_active');
  },
};

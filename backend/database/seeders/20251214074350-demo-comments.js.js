'use strict';
const bcrypt = require('bcryptjs');

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    // Masukkan ke Database
    await queryInterface.bulkInsert('comments', [{
      id: 1,
      user_id: 1,
      news_id: 1,
      content: 'komentar pertama',
      created_at: new Date(),
      updated_at: new Date()
    }], {});
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.bulkDelete('admins', null, {});
  }
};
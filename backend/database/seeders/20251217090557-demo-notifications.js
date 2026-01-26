'use strict';

/** @type {import('sequelize-cli').Seeder} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert('notifications', [
      {
        id: 1,
        user_id: 1,
        news_id: 1,
        type: 'broadcast',
        title: 'Berita Baru',
        body: 'Berita terbaru telah dipublikasikan, yuk baca sekarang!',
        is_read: false,
        created_at: new Date()
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('notifications', null, {});
  }
};

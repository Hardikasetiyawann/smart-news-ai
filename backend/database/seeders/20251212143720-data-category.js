'use strict';

/** @type {import('sequelize-cli').Seeder} */
module.exports = {
  async up (queryInterface, Sequelize) {
    // Masukkan data kategori awal
    await queryInterface.bulkInsert('Categories', [
      {
        id : '1',
        name: 'Ekonomi',
        created_at: new Date(),
        updated_at: new Date()
      },
    ], {});
  },

  async down (queryInterface, Sequelize) {
    // Hapus semua data dari tabel Categories saat rollback
    await queryInterface.bulkDelete('Categories', null, {});
  }
};
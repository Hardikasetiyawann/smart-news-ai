'use strict';
const bcrypt = require('bcryptjs');

module.exports = {
  async up(queryInterface) {
    const salt = bcrypt.genSaltSync(10);

    await queryInterface.bulkInsert(
      'admins',
      [
        {
          username: 'superadmin',
          email: 'admin@lensnews.com',
          password_hash: bcrypt.hashSync('123456', salt),
          full_name: 'Admin Utama',
          last_login: null,
          created_at: new Date(),
          updated_at: new Date(),
        },
        {
          username: 'editor',
          email: 'editor@lensnews.com',
          password_hash: bcrypt.hashSync('admin123', salt),
          full_name: 'Admin Editor',
          last_login: null,
          created_at: new Date(),
          updated_at: new Date(),
        },
      ],
      {
        ignoreDuplicates: true, // ⬅️ INI KUNCI PENTING
      }
    );
  },

  async down(queryInterface) {
    await queryInterface.bulkDelete('admins', null, {});
  },
};

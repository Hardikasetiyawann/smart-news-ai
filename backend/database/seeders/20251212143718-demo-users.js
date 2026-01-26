'use strict';

const bcrypt = require('bcryptjs');

/** @type {import('sequelize-cli').Seeder} */
module.exports = {
  async up(queryInterface) {
    const passwordHash = await bcrypt.hash('password123', 10);

    await queryInterface.bulkInsert(
      'users',
      [
        {
          id: '1',
          email: 'firebase.user@gmail.com',
          password_hash: null,
          full_name: 'Firebase User',
          image_url: 'https://i.pravatar.cc/150?img=1',
          auth_provider: 'google',
          firebase_uid: 'firebase_uid_dummy_123',
          created_at: new Date(),
          updated_at: new Date(),
        },
        {
          id: '2',
          email: 'manual.user@gmail.com',
          password_hash: passwordHash,
          full_name: 'Manual User',
          image_url: null,
          auth_provider: 'email',
          firebase_uid: null,
          created_at: new Date(),
          updated_at: new Date(),
        },
      ],
      {}
    );
  },

  async down(queryInterface) {
    await queryInterface.bulkDelete('users', null, {});
  },
};

'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.bulkInsert('publishers', [{
      
        id : '1',
        name: 'Kompas.com',
        logo_url: 'https://upload.wikimedia.org/wikipedia/commons/9/97/Kompascom_2020.png',
        website: 'https://www.kompas.com',
        created_at: new Date(),
        updated_at: new Date()
      }], {});
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.bulkDelete('publishers', null, {});
  }
};
const { Sequelize } = require('sequelize');
require('dotenv').config(); // Load variabel dari file .env
// Membuat instance Sequelize (Koneksi ke MySQL)
const sequelize = new Sequelize(
    process.env.DB_NAME,   // Nama Database
    process.env.DB_USER,   // User (root)
    process.env.DB_PASS,   // Password
    {
        host: process.env.DB_HOST, // Host (localhost)
        dialect: 'mysql',          // Driver Database
        logging: false,            // false = agar tidak muncul log SQL panjang di terminal
        timezone: '+07:00',        // Set Waktu Indonesia Barat (WIB)
        
        // Konfigurasi Pool Koneksi (Opsional, agar performa stabil)
        pool: {
            max: 5,     // Maksimal koneksi simultan
            min: 0,     // Minimal koneksi
            acquire: 30000,
            idle: 10000
        }
    }
);

module.exports = sequelize;